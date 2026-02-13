import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';

abstract class AppThemeMode {
  AppThemeMode({required this.themeData}) {
    colors = themeData.colorScheme;
  }

  final AppTheme themeData;
  late ColorScheme colors;
}

/// App theme configuration
class AppTheme {
  const AppTheme(this.colors);

  final AppColors colors;

  ColorScheme get colorScheme => ColorScheme(
    brightness: colors.brightness,
    primary: colors.primary.shade500,
    onPrimary: colors.primary.shade900,
    secondary: colors.secondary.shade500,
    onSecondary: colors.secondary.shade900,
    tertiary: colors.tertiary.shade500,
    onTertiary: colors.tertiary.shade900,
    error: colors.error.shade500,
    onError: colors.error.shade900,
    surface: colors.surface,
    onSurface: colors.onSurface,
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
        extensions: [colors],
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData()
            .copyWith(
              backgroundColor: colorScheme.primary,
            ),
      );
}
