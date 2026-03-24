import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgv_genui_financial_advisor/design_system/app_colors.dart';

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
      expect(colors.primary, const Color(0xFF6D92F5));
      expect(colors.onPrimary, const Color(0xFFFFFFFF));
      expect(colors.primaryContainer, const Color(0xFFF3F6FF));
      expect(colors.onPrimaryContainer, const Color(0xFF020F30));
      expect(colors.primarySurface, const Color(0xFFE2E8F9));
      expect(colors.primaryStrong, const Color(0xFF2C64F1));
    });

    test('surface colors are defined', () {
      expect(colors.surface, const Color(0xFFF7F6F7));
      expect(colors.surfaceVariant, const Color(0xFFFFFFFF));
      expect(colors.surfaceContainer, const Color(0xFFF0F1F1));
      expect(colors.surfaceContainerHigh, const Color(0xFFC6C6C7));
      expect(colors.surfaceContainerHighest, const Color(0xFFAAABAB));
      expect(colors.onSurface, const Color(0xFF1A1C1C));
      expect(colors.onSurfaceVariant, const Color(0xFF5D5F5F));
      expect(colors.onSurfaceMuted, const Color(0xFF909191));
      expect(colors.onSurfaceDisabled, const Color(0xFFAAABAB));
      expect(colors.inverseSurface, const Color(0xFF6D92F5));
      expect(colors.onInverseSurface, const Color(0xFFFFFFFF));
    });

    test('outline colors are defined', () {
      expect(colors.outline, const Color(0xFFF0F1F1));
      expect(colors.outlineVariant, const Color(0xFFE2E2E2));
      expect(colors.outlineStrong, const Color(0xFFAAABAB));
    });

    test('error colors are defined', () {
      expect(colors.error, const Color(0xFFFF5446));
      expect(colors.onError, const Color(0xFFFFFFFF));
      expect(colors.errorContainer, const Color(0xFFFFDAD5));
      expect(colors.onErrorContainer, const Color(0xFFB8201B));
    });

    test('success colors are defined', () {
      expect(colors.success, const Color(0xFF00A65F));
      expect(colors.onSuccess, const Color(0xFFFFFFFF));
      expect(colors.successContainer, const Color(0xFFC2FFD1));
      expect(colors.onSuccessContainer, const Color(0xFF006D3C));
    });

    test('warning colors are defined', () {
      expect(colors.warning, const Color(0xFFF69426));
      expect(colors.onWarning, const Color(0xFFFFFFFF));
      expect(colors.warningContainer, const Color(0xFFFFEEE1));
      expect(colors.onWarningContainer, const Color(0xFF8D4F00));
    });

    test('genius gradient is defined', () {
      expect(colors.geniusGradient, isA<LinearGradient>());
      expect(colors.geniusGradient.colors, hasLength(2));
    });

    test('extended colors are defined', () {
      expect(colors.emeraldColor, const Color(0xFF0D3823));
      expect(colors.emeraldSurface, const Color(0xFF0D3823));
      expect(colors.emeraldContainer, const Color(0x260D3823));

      expect(colors.darkOliveColor, const Color(0xFF486731));
      expect(colors.darkOliveSurface, const Color(0xFF486731));
      expect(colors.darkOliveContainer, const Color(0x26486731));

      expect(colors.lightOliveColor, const Color(0xFFC1D112));
      expect(colors.lightOliveSurface, const Color(0xFFC1D112));
      expect(colors.lightOliveContainer, const Color(0x26C1D112));

      expect(colors.lightBlueColor, const Color(0xFF83D1EC));
      expect(colors.lightBlueSurface, const Color(0xFF83D1EC));
      expect(colors.lightBlueContainer, const Color(0x2683D1EC));

      expect(colors.aquaColor, const Color(0xFFAFEEF0));
      expect(colors.aquaSurface, const Color(0xFFAFEEF0));
      expect(colors.aquaContainer, const Color(0x26AFEEF0));

      expect(colors.plumColor, const Color(0xFF9B3C6B));
      expect(colors.plumSurface, const Color(0xFF9B3C6B));
      expect(colors.plumContainer, const Color(0x269B3C6B));

      expect(colors.deepRedColor, const Color(0xFF882003));
      expect(colors.deepRedSurface, const Color(0xFF882003));
      expect(colors.deepRedContainer, const Color(0x26882003));

      expect(colors.brightOrangeColor, const Color(0xFFF6602D));
      expect(colors.brightOrangeSurface, const Color(0xFFF6602D));
      expect(colors.brightOrangeContainer, const Color(0x26F6602D));

      expect(colors.orangeColor, const Color(0xFFFA912A));
      expect(colors.orangeSurface, const Color(0xFFFA912A));
      expect(colors.orangeContainer, const Color(0x26FA912A));

      expect(colors.mustardColor, const Color(0xFFF2C01C));
      expect(colors.mustardSurface, const Color(0xFFF2C01C));
      expect(colors.mustardContainer, const Color(0x26F2C01C));

      expect(colors.pinkColor, const Color(0xFFE98AD4));
      expect(colors.pinkSurface, const Color(0xFFE98AD4));
      expect(colors.pinkContainer, const Color(0x26E98AD4));
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

  group(DarkThemeColors, () {
    late DarkThemeColors colors;

    setUp(() {
      colors = DarkThemeColors();
    });

    test('brightness is dark', () {
      expect(colors.brightness, Brightness.dark);
    });

    test('primary colors are defined', () {
      expect(colors.primary, const Color(0xFF8EAAF7));
      expect(colors.onPrimary, const Color(0xFF0A1A3E));
      expect(colors.primaryContainer, const Color(0xFF1C2D5A));
      expect(colors.onPrimaryContainer, const Color(0xFFD6E0FF));
      expect(colors.primarySurface, const Color(0xFF1A2744));
      expect(colors.primaryStrong, const Color(0xFF5B8AF3));
    });

    test('surface colors are defined', () {
      expect(colors.surface, const Color(0xFF121212));
      expect(colors.surfaceVariant, const Color(0xFF1E1E1E));
      expect(colors.surfaceContainer, const Color(0xFF252525));
      expect(colors.surfaceContainerHigh, const Color(0xFF3A3A3A));
      expect(colors.surfaceContainerHighest, const Color(0xFF4E4E4E));
      expect(colors.onSurface, const Color(0xFFE4E4E4));
      expect(colors.onSurfaceVariant, const Color(0xFFBDBDBD));
      expect(colors.onSurfaceMuted, const Color(0xFF8A8A8A));
      expect(colors.onSurfaceDisabled, const Color(0xFF5E5E5E));
      expect(colors.inverseSurface, const Color(0xFF8EAAF7));
      expect(colors.onInverseSurface, const Color(0xFF0A1A3E));
    });

    test('outline colors are defined', () {
      expect(colors.outline, const Color(0xFF2E2E2E));
      expect(colors.outlineVariant, const Color(0xFF3A3A3A));
      expect(colors.outlineStrong, const Color(0xFF5E5E5E));
    });

    test('error colors are defined', () {
      expect(colors.error, const Color(0xFFFF6B5E));
      expect(colors.onError, const Color(0xFF3B0907));
      expect(colors.errorContainer, const Color(0xFF5C1410));
      expect(colors.onErrorContainer, const Color(0xFFFFDAD5));
    });

    test('success colors are defined', () {
      expect(colors.success, const Color(0xFF33C07F));
      expect(colors.onSuccess, const Color(0xFF00391D));
      expect(colors.successContainer, const Color(0xFF004D2B));
      expect(colors.onSuccessContainer, const Color(0xFFC2FFD1));
    });

    test('warning colors are defined', () {
      expect(colors.warning, const Color(0xFFF8A94E));
      expect(colors.onWarning, const Color(0xFF3D2200));
      expect(colors.warningContainer, const Color(0xFF5C3600));
      expect(colors.onWarningContainer, const Color(0xFFFFEEE1));
    });

    test('genius gradient is defined', () {
      expect(colors.geniusGradient, isA<LinearGradient>());
      expect(colors.geniusGradient.colors, hasLength(2));
    });

    test('extended colors are defined', () {
      expect(colors.emeraldColor, const Color(0xFF4CAF78));
      expect(colors.emeraldSurface, const Color(0xFF1A3D2A));
      expect(colors.emeraldContainer, const Color(0x264CAF78));

      expect(colors.darkOliveColor, const Color(0xFF7DA05A));
      expect(colors.darkOliveSurface, const Color(0xFF2A3D1E));
      expect(colors.darkOliveContainer, const Color(0x267DA05A));

      expect(colors.lightOliveColor, const Color(0xFFD4E34A));
      expect(colors.lightOliveSurface, const Color(0xFF3A3D0A));
      expect(colors.lightOliveContainer, const Color(0x26D4E34A));

      expect(colors.lightBlueColor, const Color(0xFF9DDEF2));
      expect(colors.lightBlueSurface, const Color(0xFF1A3640));
      expect(colors.lightBlueContainer, const Color(0x269DDEF2));

      expect(colors.aquaColor, const Color(0xFFC5F4F5));
      expect(colors.aquaSurface, const Color(0xFF1A3A3B));
      expect(colors.aquaContainer, const Color(0x26C5F4F5));

      expect(colors.plumColor, const Color(0xFFBB6C93));
      expect(colors.plumSurface, const Color(0xFF3D1A2D));
      expect(colors.plumContainer, const Color(0x26BB6C93));

      expect(colors.deepRedColor, const Color(0xFFBF5A3D));
      expect(colors.deepRedSurface, const Color(0xFF3D1508));
      expect(colors.deepRedContainer, const Color(0x26BF5A3D));

      expect(colors.brightOrangeColor, const Color(0xFFF88A63));
      expect(colors.brightOrangeSurface, const Color(0xFF3D2014));
      expect(colors.brightOrangeContainer, const Color(0x26F88A63));

      expect(colors.orangeColor, const Color(0xFFFBA95A));
      expect(colors.orangeSurface, const Color(0xFF3D2810));
      expect(colors.orangeContainer, const Color(0x26FBA95A));

      expect(colors.mustardColor, const Color(0xFFF5D04A));
      expect(colors.mustardSurface, const Color(0xFF3D340A));
      expect(colors.mustardContainer, const Color(0x26F5D04A));

      expect(colors.pinkColor, const Color(0xFFEFA4DE));
      expect(colors.pinkSurface, const Color(0xFF3D1A35));
      expect(colors.pinkContainer, const Color(0x26EFA4DE));
    });

    test('copyWith returns a $DarkThemeColors', () {
      expect(colors.copyWith(), isA<DarkThemeColors>());
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
}
