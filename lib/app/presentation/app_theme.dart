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
    primary: colors.primary,
    onPrimary: colors.onPrimary,
    primaryContainer: colors.primaryContainer,
    onPrimaryContainer: colors.onPrimaryContainer,
    secondary: colors.primary,
    onSecondary: colors.onPrimary,
    tertiary: colors.success,
    onTertiary: colors.onSuccess,
    error: colors.error,
    onError: colors.onError,
    errorContainer: colors.errorContainer,
    onErrorContainer: colors.onErrorContainer,
    surface: colors.surface,
    onSurface: colors.onSurface,
    surfaceContainerHighest: colors.surfaceContainerHighest,
    outline: colors.outline,
    outlineVariant: colors.outlineVariant,
    inverseSurface: colors.inverseSurface,
    onInverseSurface: colors.onInverseSurface,
  );

  /// Default `ThemeData` for App UI.
  /// Uses desktop text theme. For responsive typography, use
  /// [getThemeData] with a [BuildContext].
  ThemeData get themeData => _buildThemeData(AppTextStyles.desktopTextTheme);

  /// Responsive `ThemeData` for App UI.
  /// Uses [AppTextStyles.getResponsiveTextTheme] to determine the appropriate
  /// text theme based on screen size.
  ThemeData getThemeData(BuildContext context) =>
      _buildThemeData(AppTextStyles.getResponsiveTextTheme(context));

  ThemeData _buildThemeData(TextTheme textTheme) =>
      ThemeData.from(
        colorScheme: colorScheme,
        useMaterial3: true,
        textTheme: textTheme,
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
