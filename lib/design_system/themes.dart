import 'package:genui_life_goal_simulator/design_system/design_system.dart';

class AppThemes {
  static AppThemeMode get light => LightTheme();

  static AppThemeMode get dark => DarkTheme();

  static AppThemeMode getAppTheme(ThemeType themeType) {
    return switch (themeType) {
      ThemeType.light => light,
      ThemeType.dark => dark,
    };
  }
}

class LightTheme extends AppThemeMode {
  LightTheme()
    : super(
        themeData: AppTheme(LightThemeColors()),
      );
}

class DarkTheme extends AppThemeMode {
  DarkTheme()
    : super(
        themeData: AppTheme(DarkThemeColors()),
      );
}
