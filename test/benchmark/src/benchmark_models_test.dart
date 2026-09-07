import 'package:flutter_test/flutter_test.dart';

import '../../../benchmark/src/benchmark_models.dart';

void main() {
  group('benchmarkModels', () {
    test('has no no-thinking variant for gemini-3.7-flash or 3.8-flash', () {
      final ids = benchmarkModels.map((m) => m.id).toSet();

      expect(ids, isNot(contains('gemini-3.7-flash-no-thinking')));
      expect(ids, isNot(contains('gemini-3.8-flash-no-thinking')));
    });

    test(
      'still benchmarks gemini-3.7-flash and 3.8-flash with thinking on',
      () {
        final ids = benchmarkModels.map((m) => m.id).toSet();

        expect(ids, contains('gemini-3.7-flash'));
        expect(ids, contains('gemini-3.8-flash'));
      },
    );

    test('other Gemini 3.x models keep their no-thinking variant', () {
      final ids = benchmarkModels.map((m) => m.id).toSet();

      expect(ids, contains('gemini-3.6-flash-no-thinking'));
    });
  });
}
