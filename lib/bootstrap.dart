import 'dart:async';
import 'dart:developer';

import 'package:feature_flags_repository/feature_flags_repository.dart';
import 'package:finance_app/app/view/app.dart';
import 'package:finance_app/app_check_debug.dart';
import 'package:finance_app/core/analytics_repository/analytics_repository.dart';
import 'package:finance_app/core/error_reporting_repository/error_reporting_repository.dart';
import 'package:finance_app/feature_flag/active_feature_flags.dart';
import 'package:finance_app/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
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
  required AnalyticsRepository Function() analyticsRepositoryFactory,
}) async {
  final binding = WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    const debugToken = String.fromEnvironment('APP_CHECK_DEBUG_TOKEN');
    if (debugToken.isNotEmpty) {
      setAppCheckDebugToken(debugToken);
    }
  }

  await FirebaseAppCheck.instance.activate(
    providerWeb: ReCaptchaV3Provider(
      '6LcnMIgsAAAAAKTLZHdxUYRLTtOjr0fWa6RNezlI',
    ),
  );

  final analyticsRepository = analyticsRepositoryFactory();

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
        Provider<AnalyticsRepository>.value(
          value: analyticsRepository,
        ),
        Provider<FeatureFlagsRepository>.value(
          value: featureFlagsRepository,
        ),
      ],
      child: App(
        navigatorObservers: [analyticsRepository.navigatorObserver],
      ),
    ),
  );
}
