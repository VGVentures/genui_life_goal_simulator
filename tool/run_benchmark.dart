// Runs the headless model benchmark and builds the HTML report.
//
// It drives the real SimulatorRepository (same system prompt + GenUI parser)
// against every model that has an API key in benchmark/keys.env, writing
// per-model metrics to benchmark/results/<id>.json, then aggregates them into
// benchmark/report.html.
//
// Usage:
//   fvm dart run tool/run_benchmark.dart
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
// BENCHMARK_ITERATIONS (default 15), BENCHMARK_TURNS (default 1),
// BENCHMARK_COOLDOWN_SECONDS (default 0 — fixed delay before each request;
// interleaving already spaces providers, so raise this only if one still
// rate-limits).

import 'dart:io';

import 'build_benchmark_report.dart' as report;

Future<void> main() async {
  // Resolve paths relative to the project root regardless of where invoked.
  final projectRoot = File(
    Platform.script.toFilePath(),
  ).parent.parent.path;
  Directory.current = projectRoot;

  final env = Platform.environment;
  final flutter = env['FLUTTER'] ?? 'fvm flutter';
  final keysFile = env['KEYS_FILE'] ?? 'benchmark/keys.env';
  final iterations = env['BENCHMARK_ITERATIONS'] ?? '5';
  final turns = env['BENCHMARK_TURNS'] ?? '3';
  final cooldown = env['BENCHMARK_COOLDOWN_SECONDS'] ?? '3';

  if (!File(keysFile).existsSync()) {
    stderr.writeln(
      'ERROR: $keysFile not found. '
      'Copy benchmark/keys.env.example and fill it in.',
    );
    exitCode = 1;
    return;
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
