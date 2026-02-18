import 'package:flutter/material.dart';

/// Text styles used in the app
//TODO(juanRodriguez17): Text styles will be changed to match the design
//system of the app, for now they are just placeholders.
abstract class AppTextStyles {
  static TextStyle? get titleLarge => const TextStyle(
    fontSize: 32,
    height: 1.3,
    fontWeight: FontWeight.w700,
  );

  static TextStyle? get titleMedium => const TextStyle(
    fontSize: 28,
    height: 1.3,
    fontWeight: FontWeight.w500,
  );

  static TextStyle? get titleSmall => const TextStyle(
    fontSize: 24,
    height: 1.3,
    fontWeight: FontWeight.w500,
  );

  static TextStyle? get bodyLarge => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.14,
  );

  static TextStyle? get bodyMedium => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.14,
  );

  static TextStyle? get bodySmall => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.14,
  );

  static TextStyle? get labelLarge => const TextStyle(
    fontSize: 16,
    height: 1.2,
    letterSpacing: 1,
  );

  static TextStyle? get labelMedium => const TextStyle(
    fontSize: 12,
    height: 1.2,
    letterSpacing: 1,
  );

  static TextStyle? get labelSmall => const TextStyle(
    fontSize: 8,
    height: 1.2,
    letterSpacing: 1,
  );
}
