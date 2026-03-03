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

    test('primary colors are defined', () {
      expect(colors.primary, isA<Color>());
      expect(colors.onPrimary, isA<Color>());
      expect(colors.primaryContainer, isA<Color>());
      expect(colors.onPrimaryContainer, isA<Color>());
    });

    test('surface colors are defined', () {
      expect(colors.surface, isA<Color>());
      expect(colors.surfaceVariant, isA<Color>());
      expect(colors.surfaceContainer, isA<Color>());
      expect(colors.surfaceContainerHigh, isA<Color>());
      expect(colors.surfaceContainerHighest, isA<Color>());
      expect(colors.onSurface, isA<Color>());
      expect(colors.onSurfaceVariant, isA<Color>());
      expect(colors.onSurfaceMuted, isA<Color>());
      expect(colors.onSurfaceDisabled, isA<Color>());
      expect(colors.inverseSurface, isA<Color>());
      expect(colors.onInverseSurface, isA<Color>());
    });

    test('outline colors are defined', () {
      expect(colors.outline, isA<Color>());
      expect(colors.outlineVariant, isA<Color>());
      expect(colors.outlineStrong, isA<Color>());
    });

    test('error colors are defined', () {
      expect(colors.error, isA<Color>());
      expect(colors.onError, isA<Color>());
      expect(colors.errorContainer, isA<Color>());
      expect(colors.onErrorContainer, isA<Color>());
    });

    test('success colors are defined', () {
      expect(colors.success, isA<Color>());
      expect(colors.onSuccess, isA<Color>());
      expect(colors.successContainer, isA<Color>());
      expect(colors.onSuccessContainer, isA<Color>());
    });

    test('warning colors are defined', () {
      expect(colors.warning, isA<Color>());
      expect(colors.onWarning, isA<Color>());
      expect(colors.warningContainer, isA<Color>());
      expect(colors.onWarningContainer, isA<Color>());
    });

    test('genius gradient is defined', () {
      expect(colors.geniusGradient, isA<LinearGradient>());
      expect(colors.geniusGradient.colors, hasLength(2));
    });

    test('extended colors are defined', () {
      expect(colors.emeraldColor, isA<Color>());
      expect(colors.emeraldSurface, isA<Color>());
      expect(colors.emeraldContainer, isA<Color>());
      expect(colors.pinkColor, isA<Color>());
      expect(colors.pinkSurface, isA<Color>());
      expect(colors.pinkContainer, isA<Color>());
    });

    test('copyWith returns a $LightThemeColors', () {
      expect(colors.copyWith(), isA<LightThemeColors>());
    });

    test('lerp returns this when t < 0.5', () {
      final other = LightThemeColors();
      expect(colors.lerp(other, 0), same(colors));
      expect(colors.lerp(other, 0.4), same(colors));
    });

    test('lerp returns other when t >= 0.5', () {
      final other = LightThemeColors();
      expect(colors.lerp(other, 0.5), same(other));
      expect(colors.lerp(other, 1), same(other));
    });

    test('lerp returns this when other is null and t >= 0.5', () {
      expect(colors.lerp(null, 1), same(colors));
    });
  });
}
