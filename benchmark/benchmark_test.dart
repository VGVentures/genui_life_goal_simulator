@Timeout(Duration(minutes: 30))
library;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'src/benchmark_models.dart';
import 'src/benchmark_runner.dart';

/// Headless model benchmark. Drives the real simulator repository (same
/// composed system prompt and GenUI parser) against each configured model and
/// writes per-model metrics to `benchmark/results/<id>.json`.
///
/// Run it explicitly — it lives outside `test/`, so the normal suite ignores it:
///   flutter test benchmark/benchmark_test.dart \
///     --dart-define-from-file=benchmark/keys.env
///
/// Override the shape with `--dart-define=BENCHMARK_ITERATIONS=1` etc.
const _iterations = int.fromEnvironment(
  'BENCHMARK_ITERATIONS',
  defaultValue: 5,
);
const _turns = int.fromEnvironment('BENCHMARK_TURNS', defaultValue: 3);

void main() {
  setUpAll(() {
    // flutter_test installs a mock HTTP client that returns 400 for every
    // request. Clear it so the benchmark makes real provider API calls.
    HttpOverrides.global = null;
  });

  for (final model in benchmarkModels) {
    test(
      model.id,
      () async {
        debugPrint(
          'Benchmarking ${model.id} '
          '($_iterations iterations x $_turns turns)',
        );

        final recorder = await runBenchmarkForModel(
          model: model,
          iterations: _iterations,
          turns: _turns,
          log: debugPrint,
        );

        final resultsDir = Directory('benchmark/results')
          ..createSync(recursive: true);
        final file = File('${resultsDir.path}/${model.id}.json')
          ..writeAsStringSync(recorder.toJsonString());
        debugPrint('Wrote ${file.path}');

        expect(recorder.turns, isNotEmpty);
      },
      skip: model.hasKey
          ? false
          : 'No API key configured for ${model.id} '
                '(set it in benchmark/keys.env).',
    );
  }
}
