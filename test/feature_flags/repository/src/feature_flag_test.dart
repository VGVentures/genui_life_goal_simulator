import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/feature_flags/repository/feature_flags_repository.dart';

void main() {
  group(FeatureFlag, () {
    test('can be instantiated', () {
      expect(
        const FeatureFlag(
          id: 'test',
          name: 'Test',
          description: 'A test flag',
          value: false,
          defaultValue: false,
        ),
        isNotNull,
      );
    });

    test('has correct properties', () {
      const flag = FeatureFlag(
        id: 'test',
        name: 'Test',
        description: 'A test flag',
        value: true,
        defaultValue: false,
      );

      expect(flag.id, equals('test'));
      expect(flag.name, equals('Test'));
      expect(flag.description, equals('A test flag'));
      expect(flag.value, isTrue);
      expect(flag.defaultValue, isFalse);
    });
  });
}
