# Claude Code Guidelines

## Flutter & Dart

- Always use `fvm flutter` and `fvm dart` instead of `flutter` and `dart` directly.
- After editing Dart files, format them: `fvm dart format <changed files>`
- After editing Dart files, analyze them: `fvm flutter analyze <changed files>`
- After editing Dart files, run tests for affected files: `fvm flutter test <affected test files>`
