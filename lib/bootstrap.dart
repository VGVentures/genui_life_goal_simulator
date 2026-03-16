import 'dart:async';
import 'dart:developer';

import 'package:finance_app/app.dart';
import 'package:finance_app/app_check/app_check_debug.dart';
import 'package:finance_app/error_reporting/error_reporting.dart';
import 'package:finance_app/feature_flags/active_feature_flags.dart';
import 'package:finance_app/feature_flags/repository/feature_flags_repository.dart';
// TODO(you): Uncomment this when the Firebase config is ready
// import 'package:finance_app/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' show RiveNative;
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver({required this.errorReportingRepository});

  final ErrorReportingRepository errorReportingRepository;

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  Future<void> onError(
    BlocBase<dynamic> bloc,
    Object error,
    StackTrace stackTrace,
  ) async {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    await errorReportingRepository.recordError(error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap({
  required ErrorReportingRepository errorReportingRepository,
}) async {
  final binding = WidgetsFlutterBinding.ensureInitialized();

  await RiveNative.init();

  await Firebase.initializeApp(
    // TODO(you): Uncomment this when the Firebase config is ready
    // options: DefaultFirebaseOptions.currentPlatform,
  );

  const debugToken = String.fromEnvironment('APP_CHECK_DEBUG_TOKEN');
  if (debugToken.isNotEmpty) {
    setAppCheckDebugToken(debugToken);
  }

  const recaptchaSiteKey = String.fromEnvironment('RECAPTCHA_SITE_KEY');
  if (recaptchaSiteKey.isNotEmpty) {
    await FirebaseAppCheck.instance.activate(
      providerWeb: ReCaptchaV3Provider(recaptchaSiteKey),
    );
  }

  final streamingPrefs = await StreamingSharedPreferences.instance;
  final featureFlagsRepository = FeatureFlagsRepository(
    streamingSharedPreferences: streamingPrefs,
    featureFlags: activeFeatureFlags,
  );

  FlutterError.onError = errorReportingRepository.handleFlutterError;
  binding.platformDispatcher.onError =
      errorReportingRepository.handlePlatformError;

  Bloc.observer = AppBlocObserver(
    errorReportingRepository: errorReportingRepository,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<ErrorReportingRepository>.value(
          value: errorReportingRepository,
        ),
        Provider<FeatureFlagsRepository>.value(
          value: featureFlagsRepository,
        ),
      ],
      child: const App(),
    ),
  );
}
