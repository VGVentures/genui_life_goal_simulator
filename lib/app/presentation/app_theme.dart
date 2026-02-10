import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';

/// App theme configuration
class AppTheme {
  const AppTheme(this.colors);
  final AppColors colors;

  ColorScheme get colorScheme => ColorScheme(
    brightness: Brightness.light,
    primary: colors.primary.v40,
    onPrimary: colors.primary.v100,
    secondary: colors.secondary.v40,
    onSecondary: colors.secondary.v100,
    tertiary: colors.tertiary.v40,
    onTertiary: colors.tertiary.v100,
    error: colors.error.v40,
    onError: colors.error.v100,
    surface: colors.neutral.v99,
    onSurface: colors.neutral.v10,
  );

  /// Default `ThemeData` for App UI.
  ThemeData get themeData =>
      ThemeData.from(
        colorScheme: colorScheme,
        useMaterial3: true,
        textTheme: TextTheme(
          displayLarge: AppTextStyles.titleLarge,
          displayMedium: AppTextStyles.titleMedium,
          displaySmall: AppTextStyles.titleSmall,
          bodyLarge: AppTextStyles.bodyLarge,
          bodyMedium: AppTextStyles.bodyMedium,
          bodySmall: AppTextStyles.bodySmall,
          labelLarge: AppTextStyles.titleLarge,
          labelMedium: AppTextStyles.titleMedium,
          labelSmall: AppTextStyles.titleSmall,
        ),
      ).copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary.v40,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary.v40,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData()
            .copyWith(
              backgroundColor: colorScheme.primary.v40,
            ),
      );
}

/// Extension on `Color` to get the different variants of a color,
/// if the color is a `MaterialColor`.
extension ColorShadow on Color {
  Color variant(int variant) {
    if (this is MaterialColor) {
      return (this as MaterialColor)[variant] ?? this;
    }
    return this;
  }

  Color get v0 => variant(0);

  Color get v10 => variant(10);

  Color get v20 => variant(20);

  Color get v30 => variant(30);

  Color get v40 => variant(40);

  Color get v50 => variant(50);

  Color get v60 => variant(60);

  Color get v70 => variant(70);

  Color get v80 => variant(80);

  Color get v90 => variant(90);

  Color get v95 => variant(95);

  Color get v99 => variant(99);

  Color get v100 => variant(100);
}
