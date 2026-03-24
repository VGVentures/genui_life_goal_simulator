import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/app_text_styles.dart';

void main() {
  group('AppTextStyles Desktop', () {
    test('displayLargeDesktop has correct properties', () {
      const style = AppTextStyles.displayLargeDesktop;
      expect(style.fontSize, 48);
      expect(style.fontWeight, FontWeight.w700);
      expect(style.letterSpacing, -2);
    });

    test('displayMediumDesktop has correct properties', () {
      const style = AppTextStyles.displayMediumDesktop;
      expect(style.fontSize, 40);
      expect(style.fontWeight, FontWeight.w700);
      expect(style.letterSpacing, -1.5);
    });

    test('headlineLargeDesktop has correct properties', () {
      const style = AppTextStyles.headlineLargeDesktop;
      expect(style.fontSize, 32);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.letterSpacing, -1.5);
    });

    test('titleLargeDesktop has correct properties', () {
      const style = AppTextStyles.titleLargeDesktop;
      expect(style.fontSize, 24);
      expect(style.fontWeight, FontWeight.w500);
      expect(style.letterSpacing, -0.5);
    });

    test('bodyLargeDesktop has correct properties', () {
      const style = AppTextStyles.bodyLargeDesktop;
      expect(style.fontSize, 16);
      expect(style.fontWeight, FontWeight.w500);
      expect(style.letterSpacing, -0.15);
    });

    test('labelLargeDesktop has correct properties', () {
      const style = AppTextStyles.labelLargeDesktop;
      expect(style.fontSize, 16);
      expect(style.fontWeight, FontWeight.w500);
      expect(style.letterSpacing, -0.15);
    });
  });

  group('AppTextStyles Mobile', () {
    test('displayLargeMobile has correct properties', () {
      const style = AppTextStyles.displayLargeMobile;
      expect(style.fontSize, 36);
      expect(style.fontWeight, FontWeight.w700);
      expect(style.letterSpacing, -1.5);
    });

    test('displayMediumMobile has correct properties', () {
      const style = AppTextStyles.displayMediumMobile;
      expect(style.fontSize, 32);
      expect(style.fontWeight, FontWeight.w700);
      expect(style.letterSpacing, -1);
    });

    test('headlineLargeMobile has correct properties', () {
      const style = AppTextStyles.headlineLargeMobile;
      expect(style.fontSize, 28);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.letterSpacing, -1);
    });

    test('titleLargeMobile has correct properties', () {
      const style = AppTextStyles.titleLargeMobile;
      expect(style.fontSize, 20);
      expect(style.fontWeight, FontWeight.w500);
      expect(style.letterSpacing, -0.25);
    });

    test('bodyLargeMobile has correct properties', () {
      const style = AppTextStyles.bodyLargeMobile;
      expect(style.fontSize, 16);
      expect(style.fontWeight, FontWeight.w500);
      expect(style.letterSpacing, -0.15);
    });

    test('labelLargeMobile has correct properties', () {
      const style = AppTextStyles.labelLargeMobile;
      expect(style.fontSize, 16);
      expect(style.fontWeight, FontWeight.w500);
      expect(style.letterSpacing, -0.15);
    });
  });

  group('AppTextStyles TextTheme', () {
    test('desktopTextTheme contains all styles', () {
      final theme = AppTextStyles.desktopTextTheme;
      expect(theme.displayLarge, isNotNull);
      expect(theme.displayMedium, isNotNull);
      expect(theme.displaySmall, isNotNull);
      expect(theme.headlineLarge, isNotNull);
      expect(theme.headlineMedium, isNotNull);
      expect(theme.headlineSmall, isNotNull);
      expect(theme.titleLarge, isNotNull);
      expect(theme.titleMedium, isNotNull);
      expect(theme.titleSmall, isNotNull);
      expect(theme.bodyLarge, isNotNull);
      expect(theme.bodyMedium, isNotNull);
      expect(theme.bodySmall, isNotNull);
      expect(theme.labelLarge, isNotNull);
      expect(theme.labelMedium, isNotNull);
      expect(theme.labelSmall, isNotNull);
    });

    test('mobileTextTheme contains all styles', () {
      final theme = AppTextStyles.mobileTextTheme;
      expect(theme.displayLarge, isNotNull);
      expect(theme.displayMedium, isNotNull);
      expect(theme.displaySmall, isNotNull);
      expect(theme.headlineLarge, isNotNull);
      expect(theme.headlineMedium, isNotNull);
      expect(theme.headlineSmall, isNotNull);
      expect(theme.titleLarge, isNotNull);
      expect(theme.titleMedium, isNotNull);
      expect(theme.titleSmall, isNotNull);
      expect(theme.bodyLarge, isNotNull);
      expect(theme.bodyMedium, isNotNull);
      expect(theme.bodySmall, isNotNull);
      expect(theme.labelLarge, isNotNull);
      expect(theme.labelMedium, isNotNull);
      expect(theme.labelSmall, isNotNull);
    });
  });
}
