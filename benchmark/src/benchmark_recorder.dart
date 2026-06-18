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

/// Full detail for a failed turn, kept for offline debugging.
class TurnFailure {
  TurnFailure({
    required this.iteration,
    required this.turnIndex,
    required this.reason,
    required this.errors,
    required this.outputText,
  });

  final int iteration;
  final int turnIndex;

  /// Short reason: `error`, `no surface`, or `error + no surface`.
  final String reason;

  /// Every error string seen during the turn (transport + GenUI parser).
  final List<String> errors;

  /// The raw model output for the turn — usually the most useful clue, e.g. the
  /// JSON the GenUI parser rejected.
  final String outputText;
}

/// Accumulates [TurnMetric]s across iterations for a single model.
class BenchmarkRecorder {
  BenchmarkRecorder(this.modelId);

  /// Identifier of the model under test (e.g. `anthropic-opus`).
  final String modelId;

  final List<TurnMetric> _turns = [];
  final List<TurnFailure> _failures = [];
  int _iteration = 0;
  int _turnIndex = 0;

  List<TurnMetric> get turns => List.unmodifiable(_turns);
  List<TurnFailure> get failures => List.unmodifiable(_failures);

  /// Begins a new iteration. Call once per pass through the journey.
  void startIteration() {
    _iteration += 1;
    _turnIndex = 0;
  }

  /// Records one completed (or failed) round trip, stamping iteration/turn.
  ///
  /// When the turn failed, pass [errorDetails] (all error strings seen) and
  /// [outputText] (the raw model output) so a [TurnFailure] is captured for the
  /// debug report.
  void recordTurn({
    required int totalMs,
    required int chunkCount,
    required bool surfaceProduced,
    int? timeToFirstChunkMs,
    int? promptTokens,
    int? responseTokens,
    int? totalTokens,
    String? error,
    List<String> errorDetails = const [],
    String outputText = '',
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

    final failedOnError = error != null;
    if (failedOnError || !surfaceProduced) {
      _failures.add(
        TurnFailure(
          iteration: _iteration,
          turnIndex: _turnIndex,
          reason: [
            if (failedOnError) 'error',
            if (!surfaceProduced) 'no surface',
          ].join(' + '),
          errors: errorDetails.isNotEmpty ? errorDetails : [?error],
          outputText: outputText,
        ),
      );
    }

    _turnIndex += 1;
  }

  Map<String, Object?> toJson() => {
    'modelId': modelId,
    'iterations': _iteration,
    'turns': [for (final turn in _turns) turn.toJson()],
  };

  String toJsonString() => const JsonEncoder.withIndent('  ').convert(toJson());

  /// A human-readable dump of every failed turn, or null if there were none.
  String? failureReport() {
    if (_failures.isEmpty) return null;
    final buffer = StringBuffer()
      ..writeln('=== $modelId — ${_failures.length} failed turn(s) ===');
    for (final f in _failures) {
      buffer
        ..writeln()
        ..writeln(
          '[iteration ${f.iteration}, turn ${f.turnIndex}] '
          '(${f.reason})',
        )
        ..writeln('errors:');
      if (f.errors.isEmpty) {
        buffer.writeln('  (none captured)');
      } else {
        for (final e in f.errors) {
          buffer.writeln('  - $e');
        }
      }
      buffer
        ..writeln('raw output:')
        ..writeln(f.outputText.isEmpty ? '  (empty)' : f.outputText)
        ..writeln('-' * 72);
    }
    return buffer.toString();
  }
}
