import 'package:dartantic_ai/dartantic_ai.dart';

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

/// Builds an OpenAI-compatible chat model (OpenAI, Kimi, DeepSeek).
///
/// `streamOptions.includeUsage` is enabled so token usage is reported during
/// streaming — this mirrors what `OpenAIProvider.createChatModel` sets and is
/// what lets the benchmark capture token counts.
OpenAIChatModel _openAiCompatible({
  required String name,
  required String apiKey,
  Uri? baseUrl,
}) {
  return OpenAIChatModel(
    name: name,
    apiKey: apiKey,
    baseUrl: baseUrl,
    defaultOptions: const OpenAIChatOptions(
      streamOptions: StreamOptions(includeUsage: true),
    ),
  );
}

/// All benchmarkable models. Each builds its dartantic [ChatModel] class
/// directly. Every model uses a direct provider API (pure Dart HTTP), so the
/// suite runs anywhere — no Firebase, no browser CORS.
///
/// IMPORTANT: the model name strings are provider-specific ids that change
/// often. Confirm each against the provider's current catalog before a run.
/// Kimi and DeepSeek are OpenAI-compatible, so they use [OpenAIChatModel] with
/// a custom `baseUrl`.
final List<BenchmarkModel> benchmarkModels = [
  // --- Google Gemini (direct API) ---
  BenchmarkModel(
    id: 'gemini-3.5-flash',
    apiKey: BenchmarkConfig.geminiApiKey,
    build: () => GoogleChatModel(
      name: 'gemini-3.5-flash',
      apiKey: BenchmarkConfig.geminiApiKey,
      baseUrl: _googleBaseUrl,
    ),
  ),
  BenchmarkModel(
    id: 'gemini-3-flash-preview',
    apiKey: BenchmarkConfig.geminiApiKey,
    build: () => GoogleChatModel(
      name: 'gemini-3-flash-preview',
      apiKey: BenchmarkConfig.geminiApiKey,
      baseUrl: _googleBaseUrl,
    ),
  ),
  BenchmarkModel(
    id: 'gemini-3.1-flash-lite',
    apiKey: BenchmarkConfig.geminiApiKey,
    build: () => GoogleChatModel(
      name: 'gemini-3.1-flash-lite',
      apiKey: BenchmarkConfig.geminiApiKey,
      baseUrl: _googleBaseUrl,
    ),
  ),
  BenchmarkModel(
    id: 'gemini-2.5-flash',
    apiKey: BenchmarkConfig.geminiApiKey,
    build: () => GoogleChatModel(
      name: 'gemini-2.5-flash',
      apiKey: BenchmarkConfig.geminiApiKey,
      baseUrl: _googleBaseUrl,
    ),
  ),

  // --- Anthropic (direct API) ---
  BenchmarkModel(
    id: 'claude-opus-4-8',
    apiKey: BenchmarkConfig.anthropicApiKey,
    build: () => AnthropicChatModel(
      name: 'claude-opus-4-8',
      apiKey: BenchmarkConfig.anthropicApiKey,
    ),
  ),
  BenchmarkModel(
    id: 'claude-sonnet-4-6',
    apiKey: BenchmarkConfig.anthropicApiKey,
    build: () => AnthropicChatModel(
      name: 'claude-sonnet-4-6',
      apiKey: BenchmarkConfig.anthropicApiKey,
    ),
  ),
  BenchmarkModel(
    id: 'claude-haiku-4-5',
    apiKey: BenchmarkConfig.anthropicApiKey,
    build: () => AnthropicChatModel(
      name: 'claude-haiku-4-5',
      apiKey: BenchmarkConfig.anthropicApiKey,
    ),
  ),

  // --- OpenAI (direct API) ---
  BenchmarkModel(
    id: 'gpt-5.5',
    apiKey: BenchmarkConfig.openAiApiKey,
    build: () => _openAiCompatible(
      name: 'gpt-5.5',
      apiKey: BenchmarkConfig.openAiApiKey,
    ),
  ),
  BenchmarkModel(
    id: 'gpt-5.4',
    apiKey: BenchmarkConfig.openAiApiKey,
    build: () => _openAiCompatible(
      name: 'gpt-5.4',
      apiKey: BenchmarkConfig.openAiApiKey,
    ),
  ),
  BenchmarkModel(
    id: 'gpt-5.4-mini',
    apiKey: BenchmarkConfig.openAiApiKey,
    build: () => _openAiCompatible(
      name: 'gpt-5.4-mini',
      apiKey: BenchmarkConfig.openAiApiKey,
    ),
  ),

  // --- Kimi / Moonshot (OpenAI-compatible) ---
  BenchmarkModel(
    id: 'kimi-k2.7-code',
    apiKey: BenchmarkConfig.kimiApiKey,
    build: () => _openAiCompatible(
      name: 'kimi-k2.7-code',
      apiKey: BenchmarkConfig.kimiApiKey,
      baseUrl: Uri.parse('https://api.moonshot.ai/v1'),
    ),
  ),
  BenchmarkModel(
    id: 'kimi-k2.7-code-highspeed',
    apiKey: BenchmarkConfig.kimiApiKey,
    build: () => _openAiCompatible(
      name: 'kimi-k2.7-code-highspeed',
      apiKey: BenchmarkConfig.kimiApiKey,
      baseUrl: Uri.parse('https://api.moonshot.ai/v1'),
    ),
  ),

  // --- DeepSeek (OpenAI-compatible) ---
  BenchmarkModel(
    id: 'deepseek-v4-flash',
    apiKey: BenchmarkConfig.deepSeekApiKey,
    build: () => _openAiCompatible(
      name: 'deepseek-v4-flash',
      apiKey: BenchmarkConfig.deepSeekApiKey,
      baseUrl: Uri.parse('https://api.deepseek.com'),
    ),
  ),
];
