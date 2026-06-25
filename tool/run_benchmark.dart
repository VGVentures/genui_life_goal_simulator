// Runs the headless model benchmark and builds the HTML report.
//
// It drives the real SimulatorRepository (same system prompt + GenUI parser)
// against every model that has an API key in benchmark/keys.env, writing
// per-model metrics to benchmark/results/<id>.json, then aggregates them into
// benchmark/report.html.
//
// Usage:
//   fvm dart run tool/run_benchmark.dart                # all keyed models
//   fvm dart run tool/run_benchmark.dart --rerun-failed # only models that
//     had a failed turn in the last run
//   fvm dart run tool/run_benchmark.dart --models=gpt-5.4-mini,kimi-k2.7-code
//
// A subset run leaves the other models' result JSON untouched; the report is
// always rebuilt from every file in benchmark/results/.
//
// Quick dry run (1 iteration):
//   BENCHMARK_ITERATIONS=1 fvm dart run tool/run_benchmark.dart
//
// In CI (plain flutter on PATH):
//   FLUTTER=flutter dart run tool/run_benchmark.dart
//
// Models run round-robin (one iteration of each model per cycle, re-shuffled
// each cycle), so each provider's requests are spread across the whole run
// instead of fired in a burst. That avoids tripping rate/token limits and keeps
// any one model from being penalized by running late.
//
// Environment overrides: FLUTTER (default "fvm flutter"), KEYS_FILE,
// BENCHMARK_ITERATIONS (default 5), BENCHMARK_TURNS (default 3),
// BENCHMARK_COOLDOWN_SECONDS (default 0 — fixed delay before each request;
// interleaving already spaces providers, so raise this only if one still
// rate-limits), BENCHMARK_MODELS (comma-separated ids; same as --models).

import 'dart:convert';
import 'dart:io';

import 'build_benchmark_report.dart' as report;

Future<void> main(List<String> args) async {
  // Resolve paths relative to the project root regardless of where invoked.
  final projectRoot = File(Platform.script.toFilePath()).parent.parent.path;
  Directory.current = projectRoot;

  final env = Platform.environment;
  final flutter = env['FLUTTER'] ?? 'fvm flutter';
  final keysFile = env['KEYS_FILE'] ?? 'benchmark/keys.env';
  final iterations = env['BENCHMARK_ITERATIONS'] ?? '5';
  final turns = env['BENCHMARK_TURNS'] ?? '3';
  final cooldown = env['BENCHMARK_COOLDOWN_SECONDS'] ?? '0';

  if (!File(keysFile).existsSync()) {
    stderr.writeln(
      'ERROR: $keysFile not found. '
      'Copy benchmark/keys.env.example and fill it in.',
    );
    exitCode = 1;
    return;
  }

  // Resolve the model filter: --models=…, else --rerun-failed (auto-detect from
  // existing results), else BENCHMARK_MODELS env, else all.
  final modelsArg = args.firstWhere(
    (a) => a.startsWith('--models='),
    orElse: () => '',
  );
  String? models;
  if (modelsArg.isNotEmpty) {
    models = modelsArg.substring('--models='.length);
  } else if (args.contains('--rerun-failed')) {
    final failed = _failedModelIds(Directory('benchmark/results'));
    if (failed.isEmpty) {
      stdout.writeln(
        'No failed models in benchmark/results — nothing to rerun. '
        'Rebuilding report.',
      );
      report.main();
      return;
    }
    models = failed.join(',');
    stdout.writeln('Re-running ${failed.length} failed model(s): $models');
  } else if ((env['BENCHMARK_MODELS'] ?? '').isNotEmpty) {
    models = env['BENCHMARK_MODELS'];
  }

  stdout.writeln(
    'Running headless benchmark '
    '($iterations iterations x $turns turns per model)...',
  );

  // FLUTTER may be a multi-word command (e.g. "fvm flutter").
  final flutterParts = flutter.split(RegExp(r'\s+'));
  final executable = flutterParts.first;
  final leadingArgs = flutterParts.skip(1).toList();

  final process = await Process.start(executable, [
    ...leadingArgs,
    'test',
    'benchmark/benchmark_test.dart',
    '--dart-define-from-file=$keysFile',
    '--dart-define=BENCHMARK_ITERATIONS=$iterations',
    '--dart-define=BENCHMARK_TURNS=$turns',
    '--dart-define=BENCHMARK_COOLDOWN_SECONDS=$cooldown',
    if (models != null) '--dart-define=BENCHMARK_MODELS=$models',
  ], mode: ProcessStartMode.inheritStdio);

  final code = await process.exitCode;
  if (code != 0) {
    // A non-zero exit usually means one model's test reported failures. The
    // other models still wrote their results, so build the report anyway.
    stderr.writeln(
      'Benchmark test reported failures (exit $code); '
      'building the report from whatever results were written.',
    );
  }

  stdout.writeln('\nBuilding report...');
  report.main();
  stdout.writeln('Open benchmark/report.html');

  // Preserve the failure signal for CI without skipping the report.
  if (code != 0) exitCode = code;
}

/// Model ids whose existing result file contains at least one failed turn
/// (an error, or a turn that produced no surface).
List<String> _failedModelIds(Directory resultsDir) {
  if (!resultsDir.existsSync()) return [];
  final ids = <String>[];
  for (final file in resultsDir.listSync().whereType<File>()) {
    if (!file.path.endsWith('.json')) continue;
    try {
      final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final turns = (data['turns'] as List<dynamic>? ?? <dynamic>[])
          .cast<Map<String, dynamic>>();
      final failed = turns.any(
        (t) => t['error'] != null || (t['surfaceProduced'] ?? true) == false,
      );
      if (failed) ids.add((data['modelId'] ?? '') as String);
    } on Object {
      // Unreadable/!JSON file; skip.
    }
  }
  return ids.where((id) => id.isNotEmpty).toList();
}
