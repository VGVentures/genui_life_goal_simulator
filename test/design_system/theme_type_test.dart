import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/theme_type.dart';

void main() {
  group(ThemeType, () {
    test('has light and dark values', () {
      expect(
        ThemeType.values,
        containsAll([ThemeType.light, ThemeType.dark]),
      );
    });

    test('toName returns the enum name', () {
      expect(ThemeType.light.toName(), 'light');
      expect(ThemeType.dark.toName(), 'dark');
    });

    test('fromName returns the correct enum value', () {
      expect(ThemeType.fromName('light'), ThemeType.light);
      expect(ThemeType.fromName('dark'), ThemeType.dark);
    });

    test('fromName throws on invalid name', () {
      expect(
        () => ThemeType.fromName('invalid'),
        throwsArgumentError,
      );
    });
  });
}
