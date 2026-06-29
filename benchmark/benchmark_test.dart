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
/// (comma-separated model ids to run; empty = all), BENCHMARK_ONLY_NEW (when
/// true, skip models that already have a `benchmark/results/<id>.json`). Models
/// not run keep their existing result file.
const _iterations = int.fromEnvironment(
  'BENCHMARK_ITERATIONS',
  defaultValue: 5,
);
const _turns = int.fromEnvironment('BENCHMARK_TURNS', defaultValue: 3);
const _stepDelaySeconds = int.fromEnvironment('BENCHMARK_COOLDOWN_SECONDS');
const _modelsFilter = String.fromEnvironment('BENCHMARK_MODELS');
const _onlyNew = bool.fromEnvironment('BENCHMARK_ONLY_NEW');

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

    // Apply the filters: an explicit id list, and/or only-new (skip models that
    // already have a result file, so a run only fills in what's missing).
    bool alreadyRun(BenchmarkModel m) =>
        File('${resultsDir.path}/${m.id}.json').existsSync();
    final models = [
      for (final model in keyed)
        if ((filterIds == null || filterIds.contains(model.id)) &&
            (!_onlyNew || !alreadyRun(model)))
          model,
    ];

    if (models.isEmpty) {
      debugPrint(
        _onlyNew
            ? 'No new models to run; every configured benchmark already has '
                  'results.'
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
