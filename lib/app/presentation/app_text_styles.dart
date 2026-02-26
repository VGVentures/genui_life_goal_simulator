import 'package:finance_app/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

/// Text styles used in the app
//TODO(juanRodriguez17): Text styles will be changed to match the design
//system of the app, for now they are just placeholders.
abstract class AppTextStyles {
  static TextStyle? get titleLarge => const TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );

  static TextStyle? get titleMedium => const TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );

  static TextStyle? get titleSmall => const TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  static TextStyle? get bodyLarge => const TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static TextStyle? get bodyMedium => const TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle? get bodySmall => const TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle? get labelLarge => const TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 16,
  );

  static TextStyle? get labelMedium => const TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 12,
  );

  static TextStyle? get labelSmall => const TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 8,
    letterSpacing: 1,
  );
}
