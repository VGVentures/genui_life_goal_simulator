import 'package:finance_app/app/presentation/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(LightThemeColors, () {
    late LightThemeColors colors;

    setUp(() {
      colors = LightThemeColors();
    });

    test('brightness is light', () {
      expect(colors.brightness, Brightness.light);
    });

    test('primary shade500 matches primary value', () {
      expect(colors.primary.shade500, const Color(0xFF4714E0));
    });

    test('all standard shades are defined for primary', () {
      for (final shade in [50, 100, 200, 300, 400, 500, 600, 700, 800, 900]) {
        expect(colors.primary[shade], isNotNull, reason: 'shade $shade');
      }
    });

    test('surface and onSurface are defined', () {
      expect(colors.surface, isA<Color>());
      expect(colors.onSurface, isA<Color>());
    });

    test('neutral and neutralVariant are defined', () {
      expect(colors.neutral, isA<MaterialColor>());
      expect(colors.neutralVariant, isA<MaterialColor>());
    });

    test('copyWith returns a $LightThemeColors', () {
      expect(colors.copyWith(), isA<LightThemeColors>());
    });

    test('lerp returns this when t < 0.5', () {
      final other = DarkThemeColors();
      expect(colors.lerp(other, 0), same(colors));
      expect(colors.lerp(other, 0.4), same(colors));
    });

    test('lerp returns other when t >= 0.5', () {
      final other = DarkThemeColors();
      expect(colors.lerp(other, 0.5), same(other));
      expect(colors.lerp(other, 1), same(other));
    });

    test('lerp returns this when other is null and t >= 0.5', () {
      expect(colors.lerp(null, 1), same(colors));
    });
  });

  group(DarkThemeColors, () {
    late DarkThemeColors colors;

    setUp(() {
      colors = DarkThemeColors();
    });

    test('brightness is dark', () {
      expect(colors.brightness, Brightness.dark);
    });

    test('primary shade500 matches swatch primary value', () {
      expect(colors.primary.shade500, const Color(0xFF4714E0));
    });

    test('all standard shades are defined for primary', () {
      for (final shade in [50, 100, 200, 300, 400, 500, 600, 700, 800, 900]) {
        expect(colors.primary[shade], isNotNull, reason: 'shade $shade');
      }
    });

    test('surface is dark', () {
      expect(colors.surface, const Color(0xFF1C1B1F));
    });

    test('onSurface is light', () {
      expect(colors.onSurface, const Color(0xFFE6E1E5));
    });

    test('neutral and neutralVariant are defined', () {
      expect(colors.neutral, isA<MaterialColor>());
      expect(colors.neutralVariant, isA<MaterialColor>());
    });

    test('copyWith returns a DarkThemeColors', () {
      expect(colors.copyWith(), isA<DarkThemeColors>());
    });

    test('lerp returns this when t < 0.5', () {
      final other = LightThemeColors();
      expect(colors.lerp(other, 0), same(colors));
    });

    test('lerp returns other when t >= 0.5', () {
      final other = LightThemeColors();
      expect(colors.lerp(other, 0.5), same(other));
    });
  });
}
