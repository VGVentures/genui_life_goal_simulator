// Stub file for compilation. Real values are generated in CI via secrets.
// To run locally, generate with: flutterfire configure --out=lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return _stub;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _stub;
      case TargetPlatform.iOS:
        return _stub;
      case TargetPlatform.macOS:
        return _stub;
      case TargetPlatform.windows:
        return _stub;
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for this platform.',
        );
    }
  }

  static const _stub = FirebaseOptions(
    apiKey: 'stub',
    appId: 'stub',
    messagingSenderId: 'stub',
    projectId: 'stub',
  );
}
