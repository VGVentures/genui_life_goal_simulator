import 'dart:convert';
import 'dart:math';

import 'package:dartantic_ai/dartantic_ai.dart';
import 'package:http/http.dart' as http;

/// API keys for the benchmark, supplied at run time via
/// `--dart-define-from-file=benchmark/keys.env`.
///
/// These must be compile-time constants, so they are read with
/// [String.fromEnvironment]. Empty means "not provided" — the runner skips any
/// model whose key is missing.
abstract final class BenchmarkConfig {
  static const openAiApiKey = String.fromEnvironment('OPENAI_API_KEY');
  static const anthropicApiKey = String.fromEnvironment('ANTHROPIC_API_KEY');
  static const geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const kimiApiKey = String.fromEnvironment('KIMI_API_KEY');
  static const deepSeekApiKey = String.fromEnvironment('DEEPSEEK_API_KEY');
  static const inceptionApiKey = String.fromEnvironment('INCEPTION_API_KEY');
}

/// Builds a dartantic [ChatModel] for a benchmark model id.
typedef ChatModelFactory = ChatModel Function();

/// One benchmarkable model: how to build it and which key it needs.
class BenchmarkModel {
  const BenchmarkModel({
    required this.id,
    required this.apiKey,
    required this.build,
  });

  /// Short stable id, also used as the result filename.
  final String id;

  /// The API key this model needs. Empty → the model is skipped.
  final String apiKey;

  /// Constructs the dartantic [ChatModel].
  final ChatModelFactory build;

  bool get hasKey => apiKey.isNotEmpty;
}

/// Default Google AI (Gemini) endpoint, matching dartantic's GoogleProvider.
final Uri _googleBaseUrl = Uri.parse(
  'https://generativelanguage.googleapis.com/v1beta',
);

final Uri _moonshotBaseUrl = Uri.parse('https://api.moonshot.ai/v1');
final Uri _deepSeekBaseUrl = Uri.parse('https://api.deepseek.com');
final Uri _inceptionBaseUrl = Uri.parse('https://api.inceptionlabs.ai/v1');

/// A model definition that may also describe a thinking-disabled variant.
///
/// Models think by default; when [buildNoThinking] is non-null the registry
/// emits a second `<id>-no-thinking` entry so the two modes can be compared.
class _ModelDef {
  const _ModelDef({
    required this.id,
    required this.apiKey,
    required this.build,
    this.buildNoThinking,
  });

  final String id;
  final String apiKey;
  final ChatModelFactory build;
  final ChatModelFactory? buildNoThinking;
}

/// Builds a Gemini chat model. [thinkingLevel] (Gemini 3+) or a zero
/// [thinkingBudgetTokens] (Gemini 2.5) disables/minimizes thinking; omit both
/// for the model's default (thinking on).
GoogleChatModel _gemini(
  String name, {
  GoogleThinkingLevel? thinkingLevel,
  int? thinkingBudgetTokens,
}) {
  return GoogleChatModel(
    name: name,
    apiKey: BenchmarkConfig.geminiApiKey,
    baseUrl: _googleBaseUrl,
    // The 2.5-style budget path is only sent when thinking is enabled on the
    // model; enable it so a budget of 0 actually disables thinking.
    enableThinking: thinkingBudgetTokens != null,
    defaultOptions: GoogleChatModelOptions(
      thinkingLevel: thinkingLevel,
      thinkingBudgetTokens: thinkingBudgetTokens,
    ),
  );
}

/// Builds an OpenAI-compatible chat model (OpenAI, Kimi, DeepSeek).
///
/// `streamOptions.includeUsage` is enabled so token usage is reported during
/// streaming. [reasoningEffort] minimizes thinking on OpenAI reasoning models.
/// [client] lets callers inject a custom transport (used to send DeepSeek's
/// non-standard `thinking` body field).
OpenAIChatModel _openAiCompatible({
  required String name,
  required String apiKey,
  Uri? baseUrl,
  ReasoningEffort? reasoningEffort,
  http.Client? client,
}) {
  return OpenAIChatModel(
    name: name,
    apiKey: apiKey,
    baseUrl: baseUrl,
    // Retry transient provider errors beneath dartantic so an occasional API
    // blip never reaches the scoring layer as a model/GenUI failure. Wraps any
    // provider-specific client (DeepSeek body injector, Inception request id).
    client: _RetryingClient(client ?? http.Client()),
    defaultOptions: OpenAIChatOptions(
      streamOptions: const StreamOptions(includeUsage: true),
      reasoningEffort: reasoningEffort,
    ),
  );
}

/// Model definitions. Each may declare a thinking-disabled variant, which the
/// registry expands into a `<id>-no-thinking` entry.
///
/// Notes on thinking control (verified against provider docs):
/// - Gemini 3.x: `thinkingLevel: minimal` (no hard off; minimal is the floor).
/// - Gemini 2.5: `thinkingBudgetTokens: 0` disables it.
/// - OpenAI GPT-5: `reasoningEffort: low` (this SDK's enum has no `minimal`).
/// - DeepSeek: thinking on by default; disabled via the `thinking` body field
///   ({"type": "disabled"}), injected through a custom HTTP client.
/// - Kimi `kimi-k2.7-code`: thinking is permanently on and the `thinking`
///   param must NOT be sent, so it has no no-thinking variant.
/// - Anthropic: thinking is off by default in dartantic, so no variant.
/// - Gemini 3.7 & 3.8 flash: `thinkingLevel: minimal` is rejected/ignored on
///   these two models, so no-thinking can never actually be achieved. No
///   variant for either.
final List<_ModelDef> _modelDefs = [
  // --- Google Gemini (direct API) ---
  _ModelDef(
    id: 'gemini-3.8-flash',
    apiKey: BenchmarkConfig.geminiApiKey,
    build: () => _gemini('gemini-3.8-flash'),
  ),
  _ModelDef(
    id: 'gemini-3.7-flash',
    apiKey: BenchmarkConfig.geminiApiKey,
    build: () => _gemini('gemini-3.7-flash'),
  ),
  _ModelDef(
    id: 'gemini-3.6-flash',
    apiKey: BenchmarkConfig.geminiApiKey,
    build: () => _gemini('gemini-3.6-flash'),
    buildNoThinking: () =>
        _gemini('gemini-3.6-flash', thinkingLevel: GoogleThinkingLevel.minimal),
  ),
  _ModelDef(
    id: 'gemini-3.5-flash',
    apiKey: BenchmarkConfig.geminiApiKey,
    build: () => _gemini('gemini-3.5-flash'),
    buildNoThinking: () =>
        _gemini('gemini-3.5-flash', thinkingLevel: GoogleThinkingLevel.minimal),
  ),
  _ModelDef(
    id: 'gemini-3-flash-preview',
    apiKey: BenchmarkConfig.geminiApiKey,
    build: () => _gemini('gemini-3-flash-preview'),
    buildNoThinking: () => _gemini(
      'gemini-3-flash-preview',
      thinkingLevel: GoogleThinkingLevel.minimal,
    ),
  ),
  _ModelDef(
    id: 'gemini-3.5-flash-lite',
    apiKey: BenchmarkConfig.geminiApiKey,
    build: () => _gemini('gemini-3.5-flash-lite'),
    buildNoThinking: () => _gemini(
      'gemini-3.5-flash-lite',
      thinkingLevel: GoogleThinkingLevel.minimal,
    ),
  ),
  _ModelDef(
    id: 'gemini-3.1-flash-lite',
    apiKey: BenchmarkConfig.geminiApiKey,
    build: () => _gemini('gemini-3.1-flash-lite'),
    buildNoThinking: () => _gemini(
      'gemini-3.1-flash-lite',
      thinkingLevel: GoogleThinkingLevel.minimal,
    ),
  ),
  _ModelDef(
    id: 'gemini-2.5-flash',
    apiKey: BenchmarkConfig.geminiApiKey,
    build: () => _gemini('gemini-2.5-flash'),
    buildNoThinking: () => _gemini('gemini-2.5-flash', thinkingBudgetTokens: 0),
  ),

  // --- Anthropic (direct API) — thinking off by default, no variant ---
  _ModelDef(
    id: 'claude-opus-4-8',
    apiKey: BenchmarkConfig.anthropicApiKey,
    build: () => AnthropicChatModel(
      name: 'claude-opus-4-8',
      apiKey: BenchmarkConfig.anthropicApiKey,
    ),
  ),
  _ModelDef(
    id: 'claude-sonnet-5',
    apiKey: BenchmarkConfig.anthropicApiKey,
    build: () => AnthropicChatModel(
      name: 'claude-sonnet-5',
      apiKey: BenchmarkConfig.anthropicApiKey,
    ),
  ),
  _ModelDef(
    id: 'claude-sonnet-4-6',
    apiKey: BenchmarkConfig.anthropicApiKey,
    build: () => AnthropicChatModel(
      name: 'claude-sonnet-4-6',
      apiKey: BenchmarkConfig.anthropicApiKey,
    ),
  ),
  _ModelDef(
    id: 'claude-haiku-4-5',
    apiKey: BenchmarkConfig.anthropicApiKey,
    build: () => AnthropicChatModel(
      name: 'claude-haiku-4-5',
      apiKey: BenchmarkConfig.anthropicApiKey,
    ),
  ),

  // --- OpenAI (direct API) ---
  _ModelDef(
    id: 'gpt-5.6-terra',
    apiKey: BenchmarkConfig.openAiApiKey,
    build: () => _openAiCompatible(
      name: 'gpt-5.6-terra',
      apiKey: BenchmarkConfig.openAiApiKey,
    ),
    buildNoThinking: () => _openAiCompatible(
      name: 'gpt-5.6-terra',
      apiKey: BenchmarkConfig.openAiApiKey,
      reasoningEffort: ReasoningEffort.low,
    ),
  ),
  _ModelDef(
    id: 'gpt-5.6-luna',
    apiKey: BenchmarkConfig.openAiApiKey,
    build: () => _openAiCompatible(
      name: 'gpt-5.6-luna',
      apiKey: BenchmarkConfig.openAiApiKey,
    ),
    buildNoThinking: () => _openAiCompatible(
      name: 'gpt-5.6-luna',
      apiKey: BenchmarkConfig.openAiApiKey,
      reasoningEffort: ReasoningEffort.low,
    ),
  ),
  _ModelDef(
    id: 'gpt-5.5',
    apiKey: BenchmarkConfig.openAiApiKey,
    build: () => _openAiCompatible(
      name: 'gpt-5.5',
      apiKey: BenchmarkConfig.openAiApiKey,
    ),
    buildNoThinking: () => _openAiCompatible(
      name: 'gpt-5.5',
      apiKey: BenchmarkConfig.openAiApiKey,
      reasoningEffort: ReasoningEffort.low,
    ),
  ),
  _ModelDef(
    id: 'gpt-5.4',
    apiKey: BenchmarkConfig.openAiApiKey,
    build: () => _openAiCompatible(
      name: 'gpt-5.4',
      apiKey: BenchmarkConfig.openAiApiKey,
    ),
    buildNoThinking: () => _openAiCompatible(
      name: 'gpt-5.4',
      apiKey: BenchmarkConfig.openAiApiKey,
      reasoningEffort: ReasoningEffort.low,
    ),
  ),
  _ModelDef(
    id: 'gpt-5.4-mini',
    apiKey: BenchmarkConfig.openAiApiKey,
    build: () => _openAiCompatible(
      name: 'gpt-5.4-mini',
      apiKey: BenchmarkConfig.openAiApiKey,
    ),
    buildNoThinking: () => _openAiCompatible(
      name: 'gpt-5.4-mini',
      apiKey: BenchmarkConfig.openAiApiKey,
      reasoningEffort: ReasoningEffort.low,
    ),
  ),

  // --- Kimi / Moonshot (OpenAI-compatible) — k2.7-code thinks permanently ---
  _ModelDef(
    id: 'kimi-k2.7-code',
    apiKey: BenchmarkConfig.kimiApiKey,
    build: () => _openAiCompatible(
      name: 'kimi-k2.7-code',
      apiKey: BenchmarkConfig.kimiApiKey,
      baseUrl: _moonshotBaseUrl,
    ),
  ),
  _ModelDef(
    id: 'kimi-k2.7-code-highspeed',
    apiKey: BenchmarkConfig.kimiApiKey,
    build: () => _openAiCompatible(
      name: 'kimi-k2.7-code-highspeed',
      apiKey: BenchmarkConfig.kimiApiKey,
      baseUrl: _moonshotBaseUrl,
    ),
  ),

  // --- DeepSeek (OpenAI-compatible) — thinking on by default ---
  _ModelDef(
    id: 'deepseek-v4-flash',
    apiKey: BenchmarkConfig.deepSeekApiKey,
    build: () => _openAiCompatible(
      name: 'deepseek-v4-flash',
      apiKey: BenchmarkConfig.deepSeekApiKey,
      baseUrl: _deepSeekBaseUrl,
    ),
    buildNoThinking: () => _openAiCompatible(
      name: 'deepseek-v4-flash',
      apiKey: BenchmarkConfig.deepSeekApiKey,
      baseUrl: _deepSeekBaseUrl,
      // DeepSeek has no native dartantic option for this; inject the
      // documented `thinking` body field.
      client: _JsonBodyInjector(const {
        'thinking': {'type': 'disabled'},
      }),
    ),
  ),

  // --- Inception Labs / Mercury (OpenAI-compatible diffusion LLM) ---
  _ModelDef(
    id: 'mercury-2',
    apiKey: BenchmarkConfig.inceptionApiKey,
    build: () => _openAiCompatible(
      name: 'mercury-2',
      apiKey: BenchmarkConfig.inceptionApiKey,
      baseUrl: _inceptionBaseUrl,
      // dartantic's OpenAI client sends a non-UUID X-Request-ID, which
      // Inception rejects with a 400. Rewrite it to a valid UUID per request.
      client: _RequestIdClient(),
    ),
  ),
];

/// All benchmarkable models, with each definition's optional thinking-disabled
/// variant expanded into a `<id>-no-thinking` entry.
final List<BenchmarkModel> benchmarkModels = [
  for (final def in _modelDefs) ...[
    BenchmarkModel(id: def.id, apiKey: def.apiKey, build: def.build),
    if (def.buildNoThinking != null)
      BenchmarkModel(
        id: '${def.id}-no-thinking',
        apiKey: def.apiKey,
        build: def.buildNoThinking!,
      ),
  ],
];

/// An [http.Client] that merges extra top-level fields into outgoing JSON
/// request bodies. Used to send provider-specific parameters (e.g. DeepSeek's
/// `thinking` field) that dartantic's options don't expose.
class _JsonBodyInjector extends http.BaseClient {
  _JsonBodyInjector(this._fields) : _inner = http.Client();

  final http.Client _inner;
  final Map<String, Object?> _fields;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    final contentType = request.headers['content-type'] ?? '';
    if (request is http.Request && contentType.contains('application/json')) {
      try {
        final decoded = jsonDecode(request.body);
        if (decoded is Map<String, dynamic>) {
          decoded.addAll(_fields);
          final injected = http.Request(request.method, request.url)
            ..followRedirects = request.followRedirects
            ..maxRedirects = request.maxRedirects
            ..persistentConnection = request.persistentConnection
            ..headers.addAll(request.headers)
            ..body = jsonEncode(decoded);
          return _inner.send(injected);
        }
      } on FormatException {
        // Body wasn't JSON we could parse; send it unchanged.
      }
    }
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}

/// An [http.Client] that retries transient provider failures with exponential
/// backoff, so occasional API-side errors don't get recorded as model/GenUI
/// failures. Covers rate limits (429), server errors (5xx), and the sporadic
/// 401/403 "insufficient permissions" that brand-new OpenAI models return
/// during rollout — verified transient: identical requests succeed on retry.
///
/// Only non-2xx responses are inspected; a request that has begun streaming a
/// 2xx is passed through untouched, so no partial output is ever duplicated.
/// The (small) error body is buffered to decide whether a 401/403 is the
/// transient permissions flake or a real bad key, and to replay it unchanged
/// when retries are exhausted.
class _RetryingClient extends http.BaseClient {
  _RetryingClient(this._inner);

  final http.Client _inner;

  /// Retries after a failure, so up to `maxRetries + 1` attempts per request.
  /// At ~20% transient-failure rates this drives a turn's residual failure
  /// probability below ~0.1%.
  static const maxRetries = 4;

  static const _retryableStatus = {408, 409, 425, 429, 500, 502, 503, 504};

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Buffer the body once: a finalized request stream is single-shot, but a
    // retry needs to send the same bytes again.
    final bodyBytes = await request.finalize().toBytes();
    final random = Random();

    for (var attempt = 0; ; attempt++) {
      final response = await _inner.send(_replay(request, bodyBytes));
      if (response.statusCode < 400) return response;

      final errorBody = await response.stream.toBytes();
      final canRetry =
          attempt < maxRetries && _isTransient(response.statusCode, errorBody);
      if (!canRetry) {
        // Give up: hand back the buffered error response unchanged.
        return http.StreamedResponse(
          Stream.value(errorBody),
          response.statusCode,
          contentLength: errorBody.length,
          request: response.request,
          headers: response.headers,
          reasonPhrase: response.reasonPhrase,
        );
      }

      // Exponential backoff with jitter: ~0.5s, 1s, 2s, 4s.
      final delayMs = 500 * (1 << attempt) + random.nextInt(250);
      await Future<void>.delayed(Duration(milliseconds: delayMs));
    }
  }

  bool _isTransient(int status, List<int> body) {
    if (_retryableStatus.contains(status)) return true;
    // New OpenAI models sporadically 401/403 with "insufficient permissions"
    // on otherwise-valid requests. Retry that, but not a genuine bad key
    // (which reports "invalid api key" / "invalid_api_key").
    if (status == 401 || status == 403) {
      final text = utf8.decode(body, allowMalformed: true).toLowerCase();
      return text.contains('insufficient permissions');
    }
    return false;
  }

  http.Request _replay(http.BaseRequest original, List<int> bodyBytes) {
    return http.Request(original.method, original.url)
      ..followRedirects = original.followRedirects
      ..maxRedirects = original.maxRedirects
      ..persistentConnection = original.persistentConnection
      ..headers.addAll(original.headers)
      ..bodyBytes = bodyBytes;
  }

  @override
  void close() => _inner.close();
}

/// An [http.Client] that sets a valid UUID `X-Request-ID` on every request.
///
/// dartantic's OpenAI client generates a `req_<timestamp>_<hex>` id, which
/// Inception rejects with a 400. Providers that ignore the header are
/// unaffected.
class _RequestIdClient extends http.BaseClient {
  _RequestIdClient() : _inner = http.Client();

  final http.Client _inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['X-Request-ID'] = _uuidV4();
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}

/// Generates a random RFC 4122 version 4 UUID.
String _uuidV4() {
  final random = Random();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  String hex(int i) => bytes[i].toRadixString(16).padLeft(2, '0');
  return '${hex(0)}${hex(1)}${hex(2)}${hex(3)}-${hex(4)}${hex(5)}-'
      '${hex(6)}${hex(7)}-${hex(8)}${hex(9)}-'
      '${hex(10)}${hex(11)}${hex(12)}${hex(13)}${hex(14)}${hex(15)}';
}
