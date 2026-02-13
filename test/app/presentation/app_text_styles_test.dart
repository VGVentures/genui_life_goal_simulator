import 'package:finance_app/app/presentation/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(AppTextStyles, () {
    test('titleLarge has correct properties', () {
      final style = AppTextStyles.titleLarge;
      expect(style?.fontSize, 32);
      expect(style?.fontWeight, FontWeight.w700);
    });

    test('titleMedium has correct properties', () {
      final style = AppTextStyles.titleMedium;
      expect(style?.fontSize, 28);
      expect(style?.fontWeight, FontWeight.w500);
    });

    test('titleSmall has correct properties', () {
      final style = AppTextStyles.titleSmall;
      expect(style?.fontSize, 24);
      expect(style?.fontWeight, FontWeight.w500);
    });

    test('bodyLarge has correct properties', () {
      final style = AppTextStyles.bodyLarge;
      expect(style?.fontSize, 20);
      expect(style?.fontWeight, FontWeight.w400);
    });

    test('bodyMedium has correct properties', () {
      final style = AppTextStyles.bodyMedium;
      expect(style?.fontSize, 16);
      expect(style?.fontWeight, FontWeight.w400);
    });

    test('bodySmall has correct properties', () {
      final style = AppTextStyles.bodySmall;
      expect(style?.fontSize, 12);
      expect(style?.fontWeight, FontWeight.w400);
    });

    test('labelLarge has correct properties', () {
      final style = AppTextStyles.labelLarge;
      expect(style?.fontSize, 16);
    });

    test('labelMedium has correct properties', () {
      final style = AppTextStyles.labelMedium;
      expect(style?.fontSize, 12);
    });

    test('labelSmall has correct properties', () {
      final style = AppTextStyles.labelSmall;
      expect(style?.fontSize, 8);
    });
  });
}
