import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// The report builder lives under tool/, not lib/, so import it by path.
import '../../tool/build_benchmark_report.dart';

/// One turn entry in a `benchmark/results/<id>.json` file.
Map<String, Object?> _turn({
  required int iteration,
  required int turnIndex,
  required int totalMs,
  required int chunkCount,
  required bool surfaceProduced,
  int? timeToFirstChunkMs,
  int? responseTokens,
  String? error,
  String? failureReason,
}) => {
  'iteration': iteration,
  'turnIndex': turnIndex,
  'totalMs': totalMs,
  'chunkCount': chunkCount,
  'surfaceProduced': surfaceProduced,
  'timeToFirstChunkMs': timeToFirstChunkMs,
  'responseTokens': responseTokens,
  'error': error,
  'failureReason': failureReason,
};

void main() {
  group('buildBenchmarksJson', () {
    // A model with two clean, successful turns in a single iteration.
    final clean = ModelSummary.fromJson({
      'modelId': 'gemini-3.1-flash-lite',
      'iterations': 1,
      'turns': [
        _turn(
          iteration: 1,
          turnIndex: 0,
          totalMs: 1000,
          chunkCount: 10,
          surfaceProduced: true,
          timeToFirstChunkMs: 500,
          responseTokens: 100,
        ),
        _turn(
          iteration: 1,
          turnIndex: 1,
          totalMs: 2000,
          chunkCount: 20,
          surfaceProduced: true,
          timeToFirstChunkMs: 700,
          responseTokens: 200,
        ),
      ],
    });

    // A model whose every turn failed — no successful turn, so latency/chunk/
    // token stats are absent.
    final failed = ModelSummary.fromJson({
      'modelId': 'broken-model',
      'iterations': 1,
      'turns': [
        _turn(
          iteration: 1,
          turnIndex: 0,
          totalMs: 100,
          chunkCount: 0,
          surfaceProduced: false,
          error: 'boom',
          failureReason: 'missing createSurface',
        ),
        _turn(
          iteration: 1,
          turnIndex: 1,
          totalMs: 100,
          chunkCount: 0,
          surfaceProduced: false,
          error: 'boom',
          failureReason: 'missing createSurface',
        ),
      ],
    });

    // A degenerate empty result (no turns) that can't form a valid row.
    final empty = ModelSummary.fromJson({
      'modelId': 'no-data',
      'iterations': 0,
      'turns': <Map<String, dynamic>>[],
    });

    final generatedAt = DateTime.utc(2026, 7, 17, 12, 30);

    test('stamps generatedAt as an ISO 8601 UTC timestamp', () {
      final json = buildBenchmarksJson([clean], generatedAt);
      expect(json['generatedAt'], '2026-07-17T12:30:00.000Z');
      expect(
        DateTime.parse(json['generatedAt']! as String).isUtc,
        isTrue,
      );
    });

    test('honors the injected timestamp in the local zone', () {
      // A non-UTC input is normalized to UTC in the payload.
      final local = DateTime(2026); // local midnight, Jan 1 2026
      final json = buildBenchmarksJson([clean], local);
      expect(json['generatedAt'], local.toUtc().toIso8601String());
    });

    test('maps a clean model to the website contract', () {
      final json = buildBenchmarksJson([clean], generatedAt);
      final models = json['models']! as List;
      expect(models, hasLength(1));
      final m = models.single as Map<String, Object?>;

      expect(m['model'], 'gemini-3.1-flash-lite');
      expect(m['avgRoundTripMs'], 1500.0);
      expect(m['avgTtfcMs'], 600.0);
      expect(
        m['p95TtfcMs'],
        closeTo(690, 0.001),
      ); // interpolated p95 of 500,700
      expect(m['avgPerPassMs'], 3000.0);
      expect(m['errorRate'], 0.0);
      expect(m['errorNote'], isNull);
      expect(m['avgChunks'], 15.0);
      expect(m['avgOutputTokens'], 150.0);
      expect(m['turnsPerIter'], 2);
      expect(m['iterations'], 1);
    });

    test('errorRate is a fraction in [0, 1], not a percentage', () {
      final json = buildBenchmarksJson([failed], generatedAt);
      final m = (json['models']! as List).single as Map<String, Object?>;
      final errorRate = m['errorRate']! as num;
      expect(errorRate, 1.0);
      expect(errorRate, lessThanOrEqualTo(1));
    });

    test('coerces absent numerics to 0 for a fully-failed model', () {
      final json = buildBenchmarksJson([failed], generatedAt);
      final m = (json['models']! as List).single as Map<String, Object?>;
      expect(m['avgRoundTripMs'], 0);
      expect(m['avgTtfcMs'], 0);
      expect(m['p95TtfcMs'], 0);
      expect(m['avgPerPassMs'], 0);
      expect(m['avgChunks'], 0);
      expect(m['avgOutputTokens'], 0);
    });

    test('errorNote is a single non-empty plain-text line when there are '
        'failures', () {
      final json = buildBenchmarksJson([failed], generatedAt);
      final m = (json['models']! as List).single as Map<String, Object?>;
      final note = m['errorNote']! as String;
      expect(note, '2× missing createSurface');
      expect(note, isNotEmpty);
      expect(note, isNot(contains('\n')));
      expect(note, isNot(contains('&'))); // no HTML entities
    });

    test('turnsPerIter and iterations are positive integers', () {
      final json = buildBenchmarksJson([clean, failed], generatedAt);
      for (final entry in json['models']! as List) {
        final m = entry as Map<String, Object?>;
        expect(m['turnsPerIter'], isA<int>());
        expect(m['iterations'], isA<int>());
        expect(m['turnsPerIter']! as int, greaterThan(0));
        expect(m['iterations']! as int, greaterThan(0));
      }
    });

    test('skips degenerate rows with no iterations or turns', () {
      final json = buildBenchmarksJson([clean, empty, failed], generatedAt);
      final models = (json['models']! as List).cast<Map<String, Object?>>();
      expect(models.map((m) => m['model']), [
        'gemini-3.1-flash-lite',
        'broken-model',
      ]);
    });

    test('emits exactly the schema keys per model (strict shape)', () {
      final json = buildBenchmarksJson([clean], generatedAt);
      final m = (json['models']! as List).single as Map<String, Object?>;
      expect(
        m.keys.toSet(),
        {
          'model',
          'avgRoundTripMs',
          'avgTtfcMs',
          'p95TtfcMs',
          'avgPerPassMs',
          'errorRate',
          'errorNote',
          'avgChunks',
          'avgOutputTokens',
          'turnsPerIter',
          'iterations',
        },
      );
      expect(json.keys.toSet(), {'generatedAt', 'models'});
    });
  });

  group('purgeStaleResults', () {
    late Directory resultsDir;

    setUp(() {
      resultsDir = Directory.systemTemp.createTempSync(
        'benchmark_results_test',
      );
    });

    tearDown(() {
      resultsDir.deleteSync(recursive: true);
    });

    test(
      'deletes result files whose id is no longer in the valid set',
      () {
        File(
          '${resultsDir.path}/kept-model.json',
        ).writeAsStringSync(jsonEncode({'modelId': 'kept-model'}));
        File(
          '${resultsDir.path}/stale-model.json',
        ).writeAsStringSync(jsonEncode({'modelId': 'stale-model'}));

        final purged = purgeStaleResults(resultsDir, {'kept-model'});

        expect(purged, ['stale-model']);
        expect(File('${resultsDir.path}/kept-model.json').existsSync(), true);
        expect(
          File('${resultsDir.path}/stale-model.json').existsSync(),
          false,
        );
      },
    );

    test('leaves the directory untouched when nothing is stale', () {
      File(
        '${resultsDir.path}/kept-model.json',
      ).writeAsStringSync(jsonEncode({'modelId': 'kept-model'}));

      final purged = purgeStaleResults(resultsDir, {'kept-model'});

      expect(purged, isEmpty);
      expect(File('${resultsDir.path}/kept-model.json').existsSync(), true);
    });
  });
}
