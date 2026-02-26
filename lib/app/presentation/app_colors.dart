import 'package:flutter/material.dart';

/// Base app colors definition.
/// Subclass and override getters to define light/dark theme palettes.
///
/// MaterialColor shades use standard increments (50–900) where
/// 50 is the lightest tint and 900 is the darkest shade.
/// The primary swatch value is always at shade 500.
///
/// Access from widgets via:
/// ```dart
/// Theme.of(context).extension<AppColors>()?.primary.shade100
/// ```
abstract class AppColors extends ThemeExtension<AppColors> {
  Brightness get brightness;

  /// The surface / background color for this theme.
  Color get surface;

  /// The on-surface / foreground color for this theme.
  Color get onSurface;

  /// 500: primary
  /// 900: onPrimary
  /// 50: primaryContainer
  /// 800: onPrimaryContainer
  MaterialColor get primary;

  /// 500: secondary
  /// 900: onSecondary
  /// 50: secondaryContainer
  /// 800: onSecondaryContainer
  MaterialColor get secondary;

  /// 500: tertiary
  /// 900: onTertiary
  /// 50: tertiaryContainer
  /// 800: onTertiaryContainer
  MaterialColor get tertiary;

  /// 500: error
  /// 900: onError
  /// 50: errorContainer
  /// 800: onErrorContainer
  MaterialColor get error;

  /// 50: shadow
  /// 900: background / surface
  /// 100: onBackground / onSurface
  MaterialColor get neutral;

  /// 50: surfaceVariant
  /// 500: onSurfaceVariant
  /// 400: outline
  /// 200: outlineVariant
  MaterialColor get neutralVariant;
}

class LightThemeColors extends AppColors {
  @override
  AppColors copyWith() => LightThemeColors();

  @override
  AppColors lerp(AppColors? other, double t) => t < 0.5 ? this : other ?? this;

  @override
  Brightness get brightness => Brightness.light;

  @override
  Color get surface => const Color(0xFFFFFFFF);

  @override
  Color get onSurface => const Color(0xFFFFFFFF);

  @override
  MaterialColor get primary => const MaterialColor(0xFF4714E0, {
    50: Color(0xB2F0F0F0),
    100: Color(0xFFF0524D),
    200: Color(0xFFF0524D),
    300: Color(0xFFF0524D),
    400: Color(0xFFF0524D),
    500: Color(0xCC000000),
    600: Color(0xFFF0524D),
    700: Color(0xFFF0524D),
    800: Color(0xFF21005D),
    900: Color(0xFF000000),
  });

  @override
  MaterialColor get secondary => const MaterialColor(0xFF625B71, {
    50: Color(0xFFD2D5DD),
    100: Color(0xFFF0524D),
    200: Color(0xFFE2E8F9),
    300: Color(0x1A6D92F5),
    400: Color(0xFFD4C6FB),
    500: Color(0xFF2461EB),
    600: Color(0xFF6D92F5),
    700: Color(0xFF2C64F1),
    800: Color(0xFF1D192B),
    900: Color(0xFF000000),
  });

  @override
  MaterialColor get tertiary => const MaterialColor(0xFFB3261E, {
    50: Color(0xFFF9DEDC),
    100: Color(0xFFF0524D),
    200: Color(0xFFF0524D),
    300: Color(0xFFF0524D),
    400: Color(0xFFF0524D),
    500: Color(0xFFB3261E),
    600: Color(0xFFF0524D),
    700: Color(0xFFF0524D),
    800: Color(0xFF410E0B),
    900: Color(0xFF000000),
  });

  @override
  MaterialColor get error => const MaterialColor(0xFFB3261E, {
    50: Color(0xFFF9DEDC),
    100: Color(0xFFF0524D),
    200: Color(0xFFF0524D),
    300: Color(0xFFF0524D),
    400: Color(0xFFF0524D),
    500: Color(0xFFB3261E),
    600: Color(0xFFF0524D),
    700: Color(0xFFF0524D),
    800: Color(0xFF410E0B),
    900: Color(0xFF000000),
  });

  @override
  MaterialColor get neutral => const MaterialColor(0xFFFFFFFF, {
    50: Color(0xFF4CAF50),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFFFFFFF),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  });

  @override
  MaterialColor get neutralVariant => const MaterialColor(0xFFF0524D, {
    50: Color(0xFFF0524D),
    100: Color(0xFFF0524D),
    200: Color(0xFFF0524D),
    300: Color(0xFFF0524D),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFF0524D),
    600: Color(0xFFF0524D),
    700: Color(0xFFF0524D),
    800: Color(0xFF49454F),
    900: Color(0xFF000000),
  });
}

class DarkThemeColors extends AppColors {
  @override
  AppColors copyWith() => DarkThemeColors();

  @override
  AppColors lerp(AppColors? other, double t) => t < 0.5 ? this : other ?? this;

  @override
  Brightness get brightness => Brightness.dark;

  @override
  Color get surface => const Color(0xFF1C1B1F);

  @override
  Color get onSurface => const Color(0xFFE6E1E5);

  @override
  MaterialColor get primary => const MaterialColor(0xFF4714E0, {
    50: Color(0xFFEADDFF),
    100: Color(0xFFD0BCFF),
    200: Color(0xFFB69DF8),
    300: Color(0xFF9A82DB),
    400: Color(0xFF7F67BE),
    500: Color(0xFF4714E0),
    600: Color(0xFF4F378B),
    700: Color(0xFF381E72),
    800: Color(0xFF21005D),
    900: Color(0xFF000000),
  });

  @override
  MaterialColor get secondary => const MaterialColor(0xFF625B71, {
    50: Color(0xFFE8DEF8),
    100: Color(0xFFCCC2DC),
    200: Color(0xFFB0A7C0),
    300: Color(0xFF958DA5),
    400: Color(0xFF7A7289),
    500: Color(0xFF625B71),
    600: Color(0xFF4A4458),
    700: Color(0xFF332D41),
    800: Color(0xFF1D192B),
    900: Color(0xFF000000),
  });

  @override
  MaterialColor get tertiary => const MaterialColor(0xFFB3261E, {
    50: Color(0xFFF9DEDC),
    100: Color(0xFFF2B8B5),
    200: Color(0xFFEC928E),
    300: Color(0xFFE46962),
    400: Color(0xFFDC362E),
    500: Color(0xFFB3261E),
    600: Color(0xFF8C1D18),
    700: Color(0xFF601410),
    800: Color(0xFF410E0B),
    900: Color(0xFF000000),
  });

  @override
  MaterialColor get error => const MaterialColor(0xFFB3261E, {
    50: Color(0xFFF9DEDC),
    100: Color(0xFFF2B8B5),
    200: Color(0xFFEC928E),
    300: Color(0xFFE46962),
    400: Color(0xFFDC362E),
    500: Color(0xFFB3261E),
    600: Color(0xFF8C1D18),
    700: Color(0xFF601410),
    800: Color(0xFF410E0B),
    900: Color(0xFF000000),
  });

  @override
  MaterialColor get neutral => const MaterialColor(0xFF605D62, {
    50: Color(0xFFE6E1E5),
    100: Color(0xFFCAC5CD),
    200: Color(0xFFAEAAAE),
    300: Color(0xFF939094),
    400: Color(0xFF787579),
    500: Color(0xFF605D62),
    600: Color(0xFF484649),
    700: Color(0xFF313033),
    800: Color(0xFF1C1B1F),
    900: Color(0xFF000000),
  });

  @override
  MaterialColor get neutralVariant => const MaterialColor(0xFF605D66, {
    50: Color(0xFFE7E0EC),
    100: Color(0xFFCAC4D0),
    200: Color(0xFFAEA9B4),
    300: Color(0xFF938F99),
    400: Color(0xFF79747E),
    500: Color(0xFF605D66),
    600: Color(0xFF49454F),
    700: Color(0xFF322F37),
    800: Color(0xFF1D1A22),
    900: Color(0xFF000000),
  });
}
