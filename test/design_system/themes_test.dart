import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

void main() {
  group(AppThemes, () {
    test('light returns a $LightTheme', () {
      expect(AppThemes.light, isA<LightTheme>());
    });

    test('dark returns a $DarkTheme', () {
      expect(AppThemes.dark, isA<DarkTheme>());
    });

    test('getAppTheme returns light theme for ${ThemeType.light}', () {
      expect(AppThemes.getAppTheme(ThemeType.light), isA<LightTheme>());
    });

    test('getAppTheme returns dark theme for ${ThemeType.dark}', () {
      expect(AppThemes.getAppTheme(ThemeType.dark), isA<DarkTheme>());
    });
  });

  group(LightTheme, () {
    test('produces a $ThemeData with light brightness', () {
      final theme = LightTheme();
      expect(theme.themeData.colorScheme.brightness, Brightness.light);
    });
  });

  group(DarkTheme, () {
    test('produces a $ThemeData with dark brightness', () {
      final theme = DarkTheme();
      expect(theme.themeData.colorScheme.brightness, Brightness.dark);
    });

    test('themeData includes $AppColors extension', () {
      final themeData = DarkTheme().themeData.themeData;
      expect(themeData.extension<AppColors>(), isA<DarkThemeColors>());
    });
  });
}
