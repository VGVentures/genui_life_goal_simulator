@Timeout(Duration(hours: 6))
library;

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
/// (comma-separated model ids to run; empty = all). Models not run keep their
/// existing `benchmark/results/<id>.json`.
const _iterations = int.fromEnvironment(
  'BENCHMARK_ITERATIONS',
  defaultValue: 5,
);
const _turns = int.fromEnvironment('BENCHMARK_TURNS', defaultValue: 3);
const _stepDelaySeconds = int.fromEnvironment('BENCHMARK_COOLDOWN_SECONDS');
const _modelsFilter = String.fromEnvironment('BENCHMARK_MODELS');

void main() {
  setUpAll(() {
    // flutter_test installs a mock HTTP client that returns 400 for every
    // request. Clear it so the benchmark makes real provider API calls.
    HttpOverrides.global = null;
  });

  test('benchmark', () async {
    // Optional subset to run (e.g. only the previously-failed models). Models
    // left out keep their existing result JSON.
    final filterIds = _modelsFilter.isEmpty
        ? null
        : _modelsFilter
              .split(',')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toSet();

    final models = [
      for (final model in benchmarkModels)
        if (model.hasKey && (filterIds == null || filterIds.contains(model.id)))
          model,
    ];
    for (final model in benchmarkModels) {
      if (!model.hasKey) {
        debugPrint('Skipping ${model.id}: no API key configured.');
      }
    }
    if (filterIds != null) {
      debugPrint('Model filter active — running: ${models.map((m) => m.id)}');
    }
    expect(
      models,
      isNotEmpty,
      reason: filterIds != null
          ? 'No keyed models matched BENCHMARK_MODELS=$_modelsFilter.'
          : 'No models had API keys; set them in benchmark/keys.env.',
    );

    final resultsDir = Directory('benchmark/results')
      ..createSync(recursive: true);

    debugPrint(
      'Benchmarking ${models.length} model(s) round-robin '
      '($_iterations iterations x $_turns turns each).',
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
