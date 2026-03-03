import 'package:finance_app/app/presentation.dart';

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
  // TODO(dev): Replace LightThemeColors with DarkThemeColors when available.
  DarkTheme()
    : super(
        themeData: AppTheme(LightThemeColors()),
      );
}
