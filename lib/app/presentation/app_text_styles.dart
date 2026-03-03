import 'package:finance_app/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

/// Typography system based on Figma specs.
/// Provides both desktop and mobile text styles.
abstract class AppTextStyles {
  // ============ DESKTOP TEXT STYLES ============

  /// Display Large - Desktop: 48px, Bold, lineHeight: 56, letterSpacing: -2
  static const TextStyle displayLargeDesktop = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 56 / 48,
    letterSpacing: -2,
  );

  /// Display Medium - Desktop: 40px, Bold, lineHeight: 48, letterSpacing: -1.5
  static const TextStyle displayMediumDesktop = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 48 / 40,
    letterSpacing: -1.5,
  );

  /// Display Small - Desktop: 36px, Bold, lineHeight: 44, letterSpacing: -1.5
  static const TextStyle displaySmallDesktop = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 44 / 36,
    letterSpacing: -1.5,
  );

  /// Headline Large - Desktop: 32px, SemiBold, lineHeight: 40, spacing: -1.5
  static const TextStyle headlineLargeDesktop = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 40 / 32,
    letterSpacing: -1.5,
  );

  /// Headline Medium - Desktop: 24px, SemiBold, lineHeight: 32, spacing: -1
  static const TextStyle headlineMediumDesktop = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    letterSpacing: -1,
  );

  /// Headline Small - Desktop: 20px, SemiBold, lineHeight: 28, spacing: -0.75
  static const TextStyle headlineSmallDesktop = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    letterSpacing: -0.75,
  );

  /// Title Large - Desktop: 24px, Medium, lineHeight: 32, letterSpacing: -0.5
  static const TextStyle titleLargeDesktop = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 32 / 24,
    letterSpacing: -0.5,
  );

  /// Title Medium - Desktop: 20px, Medium, lineHeight: 28, letterSpacing: -0.5
  static const TextStyle titleMediumDesktop = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 28 / 20,
    letterSpacing: -0.5,
  );

  /// Title Small - Desktop: 16px, Medium, lineHeight: 24, letterSpacing: -0.25
  static const TextStyle titleSmallDesktop = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
    letterSpacing: -0.25,
  );

  /// Label Large - Desktop: 16px, Medium, lineHeight: 20, letterSpacing: -0.15
  static const TextStyle labelLargeDesktop = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 20 / 16,
    letterSpacing: -0.15,
  );

  /// Label Medium - Desktop: 12px, Medium, lineHeight: 16, letterSpacing: -0.15
  static const TextStyle labelMediumDesktop = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: -0.15,
  );

  /// Label Small - Desktop: 11px, Medium, lineHeight: 16, letterSpacing: -0.15
  static const TextStyle labelSmallDesktop = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 16 / 11,
    letterSpacing: -0.15,
  );

  /// Body Large - Desktop: 16px, Medium, lineHeight: 24, letterSpacing: -0.15
  static const TextStyle bodyLargeDesktop = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
    letterSpacing: -0.15,
  );

  /// Body Medium - Desktop: 14px, Medium, lineHeight: 20, letterSpacing: -0.15
  static const TextStyle bodyMediumDesktop = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: -0.15,
  );

  /// Body Small - Desktop: 12px, Medium, lineHeight: 16, letterSpacing: -0.15
  static const TextStyle bodySmallDesktop = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: -0.15,
  );

  // ============ MOBILE TEXT STYLES ============

  /// Display Large - Mobile: 36px, Bold, lineHeight: 44, letterSpacing: -1.5
  static const TextStyle displayLargeMobile = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 44 / 36,
    letterSpacing: -1.5,
  );

  /// Display Medium - Mobile: 32px, Bold, lineHeight: 40, letterSpacing: -1
  static const TextStyle displayMediumMobile = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    letterSpacing: -1,
  );

  /// Display Small - Mobile: 28px, Bold, lineHeight: 36, letterSpacing: -1
  static const TextStyle displaySmallMobile = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 36 / 28,
    letterSpacing: -1,
  );

  /// Headline Large - Mobile: 28px, SemiBold, lineHeight: 36, spacing: -1
  static const TextStyle headlineLargeMobile = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 36 / 28,
    letterSpacing: -1,
  );

  /// Headline Medium - Mobile: 22px, SemiBold, lineHeight: 28, spacing: -0.75
  static const TextStyle headlineMediumMobile = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 28 / 22,
    letterSpacing: -0.75,
  );

  /// Headline Small - Mobile: 18px, SemiBold, lineHeight: 24, spacing: -0.5
  static const TextStyle headlineSmallMobile = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
    letterSpacing: -0.5,
  );

  /// Title Large - Mobile: 20px, Medium, lineHeight: 28, letterSpacing: -0.25
  static const TextStyle titleLargeMobile = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 28 / 20,
    letterSpacing: -0.25,
  );

  /// Title Medium - Mobile: 18px, Medium, lineHeight: 24, letterSpacing: -0.25
  static const TextStyle titleMediumMobile = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 24 / 18,
    letterSpacing: -0.25,
  );

  /// Title Small - Mobile: 14px, Medium, lineHeight: 20, letterSpacing: -0.15
  static const TextStyle titleSmallMobile = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: -0.15,
  );

  /// Label Large - Mobile: 16px, Medium, lineHeight: 20, letterSpacing: -0.15
  static const TextStyle labelLargeMobile = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 20 / 16,
    letterSpacing: -0.15,
  );

  /// Label Medium - Mobile: 12px, Medium, lineHeight: 16, letterSpacing: -0.15
  static const TextStyle labelMediumMobile = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: -0.15,
  );

  /// Label Small - Mobile: 11px, Medium, lineHeight: 16, letterSpacing: -0.15
  static const TextStyle labelSmallMobile = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 16 / 11,
    letterSpacing: -0.15,
  );

  /// Body Large - Mobile: 14px, Medium, lineHeight: 20, letterSpacing: -0.15
  static const TextStyle bodyLargeMobile = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: -0.15,
  );

  /// Body Medium - Mobile: 14px, Medium, lineHeight: 20, letterSpacing: -0.15
  static const TextStyle bodyMediumMobile = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: -0.15,
  );

  /// Body Small - Mobile: 12px, Medium, lineHeight: 16, letterSpacing: -0.15
  static const TextStyle bodySmallMobile = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: -0.15,
  );

  // ============ HELPER METHODS ============

  /// Returns the desktop TextTheme
  static TextTheme get desktopTextTheme => const TextTheme(
    displayLarge: displayLargeDesktop,
    displayMedium: displayMediumDesktop,
    displaySmall: displaySmallDesktop,
    headlineLarge: headlineLargeDesktop,
    headlineMedium: headlineMediumDesktop,
    headlineSmall: headlineSmallDesktop,
    titleLarge: titleLargeDesktop,
    titleMedium: titleMediumDesktop,
    titleSmall: titleSmallDesktop,
    labelLarge: labelLargeDesktop,
    labelMedium: labelMediumDesktop,
    labelSmall: labelSmallDesktop,
    bodyLarge: bodyLargeDesktop,
    bodyMedium: bodyMediumDesktop,
    bodySmall: bodySmallDesktop,
  );

  /// Returns the mobile TextTheme
  static TextTheme get mobileTextTheme => const TextTheme(
    displayLarge: displayLargeMobile,
    displayMedium: displayMediumMobile,
    displaySmall: displaySmallMobile,
    headlineLarge: headlineLargeMobile,
    headlineMedium: headlineMediumMobile,
    headlineSmall: headlineSmallMobile,
    titleLarge: titleLargeMobile,
    titleMedium: titleMediumMobile,
    titleSmall: titleSmallMobile,
    labelLarge: labelLargeMobile,
    labelMedium: labelMediumMobile,
    labelSmall: labelSmallMobile,
    bodyLarge: bodyLargeMobile,
    bodyMedium: bodyMediumMobile,
    bodySmall: bodySmallMobile,
  );

  /// Returns the appropriate TextTheme based on screen width.
  /// Uses 600px as the breakpoint (same as ResponsiveScaffold).
  static TextTheme getResponsiveTextTheme(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= 600 ? desktopTextTheme : mobileTextTheme;
  }
}
