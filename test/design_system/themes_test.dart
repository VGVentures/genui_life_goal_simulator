import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

void main() {
  group(AppThemes, () {
    test('light exposes $LightThemeColors', () {
      expect(AppThemes.light.colors, isA<LightThemeColors>());
    });

    test('dark exposes $DarkThemeColors', () {
      expect(AppThemes.dark.colors, isA<DarkThemeColors>());
    });

    test('light themeData returns an $AppTheme', () {
      expect(AppThemes.light.themeData, isA<AppTheme>());
    });

    test('dark themeData returns an $AppTheme', () {
      expect(AppThemes.dark.themeData, isA<AppTheme>());
    });

    test('light produces a $ThemeData with light brightness', () {
      expect(
        AppThemes.light.themeData.themeData.colorScheme.brightness,
        Brightness.light,
      );
    });

    test('dark produces a $ThemeData with dark brightness', () {
      expect(
        AppThemes.dark.themeData.themeData.colorScheme.brightness,
        Brightness.dark,
      );
    });

    test('dark themeData includes $AppColors extension', () {
      final themeData = AppThemes.dark.themeData.themeData;
      expect(themeData.extension<AppColors>(), isA<DarkThemeColors>());
    });
  });
}
