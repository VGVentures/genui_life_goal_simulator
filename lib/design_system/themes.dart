import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// Predefined app themes.
enum AppThemes {
  light,
  dark
  ;

  /// The [AppColors] for this theme.
  AppColors get colors => switch (this) {
    AppThemes.light => LightThemeColors(),
    AppThemes.dark => DarkThemeColors(),
  };

  /// The [AppTheme] for this theme.
  AppTheme get themeData => AppTheme(colors);
}
