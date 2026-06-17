import 'dart:convert';

/// Metrics captured for a single model round trip (one turn).
class TurnMetric {
  TurnMetric({
    required this.iteration,
    required this.turnIndex,
    required this.totalMs,
    required this.chunkCount,
    required this.surfaceProduced,
    this.timeToFirstChunkMs,
    this.promptTokens,
    this.responseTokens,
    this.totalTokens,
    this.error,
  });

  final int iteration;
  final int turnIndex;
  final int totalMs;
  final int chunkCount;

  /// Whether the model output parsed into at least one valid GenUI surface.
  /// False means the model failed to produce renderable output for this turn —
  /// the schema/validation failure the benchmark cares about.
  final bool surfaceProduced;

  final int? timeToFirstChunkMs;
  final int? promptTokens;
  final int? responseTokens;
  final int? totalTokens;

  /// Transport or GenUI error string, otherwise null.
  final String? error;

  /// A turn counts as a failure if it errored or produced no valid surface.
  bool get isFailure => error != null || !surfaceProduced;

  Map<String, Object?> toJson() => {
    'iteration': iteration,
    'turnIndex': turnIndex,
    'totalMs': totalMs,
    'chunkCount': chunkCount,
    'surfaceProduced': surfaceProduced,
    'timeToFirstChunkMs': timeToFirstChunkMs,
    'promptTokens': promptTokens,
    'responseTokens': responseTokens,
    'totalTokens': totalTokens,
    'error': error,
  };
}

/// Accumulates [TurnMetric]s across iterations for a single model.
class BenchmarkRecorder {
  BenchmarkRecorder(this.modelId);

  /// Identifier of the model under test (e.g. `anthropic-opus`).
  final String modelId;

  final List<TurnMetric> _turns = [];
  int _iteration = 0;
  int _turnIndex = 0;

  List<TurnMetric> get turns => List.unmodifiable(_turns);

  /// Begins a new iteration. Call once per pass through the journey.
  void startIteration() {
    _iteration += 1;
    _turnIndex = 0;
  }

  /// Records one completed (or failed) round trip, stamping iteration/turn.
  void recordTurn({
    required int totalMs,
    required int chunkCount,
    required bool surfaceProduced,
    int? timeToFirstChunkMs,
    int? promptTokens,
    int? responseTokens,
    int? totalTokens,
    String? error,
  }) {
    _turns.add(
      TurnMetric(
        iteration: _iteration,
        turnIndex: _turnIndex,
        totalMs: totalMs,
        chunkCount: chunkCount,
        surfaceProduced: surfaceProduced,
        timeToFirstChunkMs: timeToFirstChunkMs,
        promptTokens: promptTokens,
        responseTokens: responseTokens,
        totalTokens: totalTokens,
        error: error,
      ),
    );
    _turnIndex += 1;
  }

  Map<String, Object?> toJson() => {
    'modelId': modelId,
    'iterations': _iteration,
    'turns': [for (final turn in _turns) turn.toJson()],
  };

  String toJsonString() => const JsonEncoder.withIndent('  ').convert(toJson());
}
