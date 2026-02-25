import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:finance_app/app/view/app.dart';
import 'package:finance_app/core/analytics_repository/analytics_repository.dart';
import 'package:finance_app/core/error_reporting_repository/error_reporting_repository.dart';
import 'package:finance_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

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

  // Ensure the analytics repository is initialized after Firebase is
  // initialized, since it relies on Firebase Analytics.
  final analyticsRepository = analyticsRepositoryFactory();

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
        Provider<AnalyticsRepository>.value(value: analyticsRepository),
      ],
      child: App(navigatorObservers: [analyticsRepository.navigatorObserver]),
    ),
  );
}
