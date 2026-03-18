// Allow print for CLI output
// ignore_for_file: avoid_print

// Sets up local development by symlinking configuration files from a shared
// location into the current worktree.
//
// This allows multiple worktrees to share the same Firebase config and
// environment variables without committing secrets to the repo.
//
// Usage:
//   dart run tool/setup_local.dart
//
// One-time machine setup (only needed once, not per worktree):
//
//   1. Generate Firebase options into the shared config directory:
//      flutterfire configure --out=$HOME/.config/vgv_genui_financial_advisor/firebase_options.dart
//
//   2. Create the shared .env file with real values:
//      cp .env.example $HOME/.config/vgv_genui_financial_advisor/.env
//      # Then edit ~/.config/vgv_genui_financial_advisor/.env with real values.
//
// Per-worktree setup:
//   dart run tool/setup_local.dart
import 'dart:io';

final String home = Platform.environment['HOME']!;
final configDir = '$home/.config/vgv_genui_financial_advisor';

/// Source path in the shared config directory → target path relative to the
/// project root.
final links = <String, String>{
  '$configDir/firebase_options.dart': 'lib/firebase_options.dart',
  '$configDir/.env': '.env',
};

void main() {
  final projectRoot = _findProjectRoot();

  print('Setting up local development...');
  print('Config directory: $configDir');
  print('');

  final dir = Directory(configDir);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
    print('Created $configDir/');
    print('');
  }

  var allReady = true;

  for (final MapEntry(:key, :value) in links.entries) {
    final source = key;
    final target = '$projectRoot/$value';

    if (!File(source).existsSync()) {
      allReady = false;
      _printMissing(source, value, projectRoot);
      continue;
    }

    _createSymlink(source: source, target: target, label: value);
  }

  print('');
  if (allReady) {
    print('Done! Launch the app from VSCode or run:');
    print(
      '  fvm flutter run '
      '--target lib/main_development.dart '
      '--dart-define-from-file=.env',
    );
  } else {
    print('Some source files are missing — see instructions above.');
    print('Then re-run: dart run tool/setup_local.dart');
  }
}

void _createSymlink({
  required String source,
  required String target,
  required String label,
}) {
  if (FileSystemEntity.isLinkSync(target)) {
    if (Link(target).targetSync() == source) {
      print('  ✓ $label (already linked)');
      return;
    }
    Link(target).deleteSync();
  } else if (FileSystemEntity.isFileSync(target)) {
    File(target).deleteSync();
  }

  Link(target).createSync(source);
  print('  ✓ $label → $source');
}

void _printMissing(String source, String label, String projectRoot) {
  print('  ✗ $label — source not found: $source');
  if (label.contains('firebase_options')) {
    print('    Run: flutterfire configure --out=$source');
  } else if (label == '.env') {
    print('    Run: cp $projectRoot/.env.example $source');
    print('    Then edit $source with real values.');
  }
  print('');
}

String _findProjectRoot() {
  var dir = Directory.current;
  while (true) {
    if (File('${dir.path}/pubspec.yaml').existsSync()) {
      return dir.path;
    }
    final parent = dir.parent;
    if (parent.path == dir.path) {
      stderr.writeln('Could not find pubspec.yaml in any parent directory.');
      exit(1);
    }
    dir = parent;
  }
}
