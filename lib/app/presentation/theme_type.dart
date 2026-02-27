enum ThemeType {
  light,
  dark;

  String toName() => name;

  static ThemeType fromName(String name) => values.byName(name);
}
