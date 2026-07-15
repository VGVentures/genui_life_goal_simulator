@Timeout(Duration(hours: 6))
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'src/benchmark_models.dart';
import 'src/benchmark_runner.dart';

/// Headless model benchmark. Drives the real simulator repository (same
/// composed system prompt and GenUI parser) against every configured model
/// round-robin, writing per-model metrics to `benchmark/results/<id>.json` and
/// failure detail to `benchmark/results/<id>.failures.txt`.
///
/// This is a single driver test rather than one test per model: `flutter test`
/// is used only as a headless Flutter runtime (the app code it drives needs
/// `dart:ui`); the scheduling (round-robin order, partial-result writes) is
/// ours.
///
/// Run it explicitly — it lives outside `test/`, so the normal suite ignores it:
///   flutter test benchmark/benchmark_test.dart \
///     --dart-define-from-file=benchmark/keys.env
///
/// Override the shape with `--dart-define=BENCHMARK_ITERATIONS=1` etc.:
/// BENCHMARK_ITERATIONS (default 5), BENCHMARK_TURNS (default 3),
/// BENCHMARK_COOLDOWN_SECONDS (fixed delay before each request, default 0 —
/// round-robin interleaving already spaces providers), BENCHMARK_MODELS
/// (comma-separated model ids to run; empty = all), BENCHMARK_ONLY_NEW (skip
/// models that already have a `benchmark/results/<id>.json`), and
/// BENCHMARK_RERUN_FAILED (also re-run models whose result has a failed turn).
/// ONLY_NEW and RERUN_FAILED compose: together they run everything except
/// models that already passed cleanly. Models not run keep their result file.
const _iterations = int.fromEnvironment(
  'BENCHMARK_ITERATIONS',
  defaultValue: 5,
);
const _turns = int.fromEnvironment('BENCHMARK_TURNS', defaultValue: 3);
const _stepDelaySeconds = int.fromEnvironment('BENCHMARK_COOLDOWN_SECONDS');
const _modelsFilter = String.fromEnvironment('BENCHMARK_MODELS');
const _onlyNew = bool.fromEnvironment('BENCHMARK_ONLY_NEW');
const _rerunFailed = bool.fromEnvironment('BENCHMARK_RERUN_FAILED');

void main() {
  setUpAll(() {
    // flutter_test installs a mock HTTP client that returns 400 for every
    // request. Clear it so the benchmark makes real provider API calls.
    HttpOverrides.global = null;
  });

  test('benchmark', () async {
    final resultsDir = Directory('benchmark/results')
      ..createSync(recursive: true);

    // Optional explicit id list (e.g. only the previously-failed models).
    final filterIds = _modelsFilter.isEmpty
        ? null
        : _modelsFilter
              .split(',')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toSet();

    // Models that have an API key configured. No key, no run.
    final keyed = [
      for (final model in benchmarkModels)
        if (model.hasKey) model,
    ];
    for (final model in benchmarkModels) {
      if (!model.hasKey) {
        debugPrint('Skipping ${model.id}: no API key configured.');
      }
    }
    expect(
      keyed,
      isNotEmpty,
      reason: 'No models had API keys; set them in benchmark/keys.env.',
    );

    bool alreadyRun(BenchmarkModel m) =>
        File('${resultsDir.path}/${m.id}.json').existsSync();

    // A restored result counts as failed if any turn errored or produced no
    // surface — the same signal the failure report uses.
    bool hasFailures(BenchmarkModel m) {
      final file = File('${resultsDir.path}/${m.id}.json');
      if (!file.existsSync()) return false;
      try {
        final data =
            jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
        final turns = (data['turns'] as List<dynamic>? ?? const [])
            .cast<Map<String, dynamic>>();
        return turns.any(
          (t) => t['error'] != null || (t['surfaceProduced'] ?? true) == false,
        );
      } on Object {
        return false; // Unreadable/!JSON: treat as nothing to retry.
      }
    }

    // Selection. With no incremental flag, run every (filtered) model.
    // Otherwise run a model if it's new (only-new) or has recorded failures
    // (rerun-failed); skip models that already passed cleanly so a rerun never
    // re-pays for a success.
    bool selected(BenchmarkModel m) {
      if (!_onlyNew && !_rerunFailed) return true;
      final isNew = !alreadyRun(m);
      if (_onlyNew && isNew) return true;
      if (_rerunFailed && !isNew && hasFailures(m)) return true;
      return false;
    }

    final models = [
      for (final model in keyed)
        if ((filterIds == null || filterIds.contains(model.id)) &&
            selected(model))
          model,
    ];

    if (models.isEmpty) {
      debugPrint(
        (_onlyNew || _rerunFailed)
            ? 'Nothing to run: every selected model already has a clean result.'
            : 'No models matched BENCHMARK_MODELS=$_modelsFilter.',
      );
      return;
    }

    debugPrint(
      'Benchmarking ${models.length} model(s) round-robin '
      '($_iterations iterations x $_turns turns each): '
      '${models.map((m) => m.id)}',
    );

    await runRoundRobin(
      models: models,
      iterations: _iterations,
      turns: _turns,
      stepDelaySeconds: _stepDelaySeconds,
      log: debugPrint,
      // Persist after every iteration so partial progress survives an
      // interrupted run (e.g. running out of provider tokens mid-sweep).
      onIterationComplete: (model, recorder) {
        File(
          '${resultsDir.path}/${model.id}.json',
        ).writeAsStringSync(recorder.toJsonString());

        final failureFile = File('${resultsDir.path}/${model.id}.failures.txt');
        final report = recorder.failureReport();
        if (report != null) {
          failureFile.writeAsStringSync(report);
        } else if (failureFile.existsSync()) {
          failureFile.deleteSync();
        }
      },
    );

    debugPrint('Done.');
  });
}
