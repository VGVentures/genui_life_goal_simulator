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
  void onError(
    BlocBase<dynamic> bloc,
    Object error,
    StackTrace stackTrace,
  ) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    errorReportingRepository.recordError(error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap({
  required ErrorReportingRepository errorReportingRepository,
  required AnalyticsRepository analyticsRepository,
}) async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  await errorReportingRepository.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
      ],
      child: App(navigatorObservers: [analyticsRepository.navigatorObserver]),
    ),
  );
}
