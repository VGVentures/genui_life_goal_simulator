import 'package:dartantic_ai/dartantic_ai.dart';

/// Latency and token data captured for one `sendStream` round trip.
class TurnTiming {
  TurnTiming({
    required this.totalMs,
    required this.chunkCount,
    this.timeToFirstChunkMs,
    this.promptTokens,
    this.responseTokens,
    this.totalTokens,
    this.errorMessage,
  });

  final int totalMs;
  final int chunkCount;
  final int? timeToFirstChunkMs;
  final int? promptTokens;
  final int? responseTokens;
  final int? totalTokens;

  /// Set when the stream threw (transport/HTTP failure), otherwise null.
  final String? errorMessage;

  bool get hadError => errorMessage != null;
}

/// A [ChatModel] decorator that times each `sendStream` round trip and reports
/// the result via [onTurn].
///
/// It wraps any underlying dartantic [ChatModel] and is transparent to the
/// simulator repository, which only sees the [ChatModel] interface. This is the
/// single latency-measurement point for the benchmark.
class TimingChatModel extends ChatModel<ChatModelOptions> {
  TimingChatModel(this._delegate, {required this.onTurn})
    : super(
        name: _delegate.name,
        defaultOptions: const ChatModelOptions(),
        tools: _delegate.tools,
        temperature: _delegate.temperature,
      );

  final ChatModel _delegate;

  /// Invoked once per round trip with its timing (on success or failure).
  final void Function(TurnTiming timing) onTurn;

  @override
  Stream<ChatResult<ChatMessage>> sendStream(
    List<ChatMessage> messages, {
    ChatModelOptions? options,
    Schema? outputSchema,
  }) async* {
    final stopwatch = Stopwatch()..start();
    var chunkCount = 0;
    int? timeToFirstChunkMs;
    int? promptTokens;
    int? responseTokens;
    int? totalTokens;

    try {
      await for (final result in _delegate.sendStream(
        messages,
        outputSchema: outputSchema,
      )) {
        if (result.output.text.isNotEmpty) {
          chunkCount += 1;
          timeToFirstChunkMs ??= stopwatch.elapsedMilliseconds;
        }
        final usage = result.usage;
        if (usage != null) {
          promptTokens = usage.promptTokens ?? promptTokens;
          responseTokens = usage.responseTokens ?? responseTokens;
          totalTokens = usage.totalTokens ?? totalTokens;
        }
        yield result;
      }
      stopwatch.stop();
      onTurn(
        TurnTiming(
          totalMs: stopwatch.elapsedMilliseconds,
          chunkCount: chunkCount,
          timeToFirstChunkMs: timeToFirstChunkMs,
          promptTokens: promptTokens,
          responseTokens: responseTokens,
          totalTokens: totalTokens,
        ),
      );
    } on Object catch (e) {
      stopwatch.stop();
      onTurn(
        TurnTiming(
          totalMs: stopwatch.elapsedMilliseconds,
          chunkCount: chunkCount,
          timeToFirstChunkMs: timeToFirstChunkMs,
          promptTokens: promptTokens,
          responseTokens: responseTokens,
          totalTokens: totalTokens,
          errorMessage: e.toString(),
        ),
      );
      rethrow;
    }
  }

  @override
  void dispose() => _delegate.dispose();
}
