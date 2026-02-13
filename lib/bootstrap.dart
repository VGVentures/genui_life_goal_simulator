import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:finance_app/core/app_initializer.dart';
import 'package:finance_app/core/error_reporting_repository/error_reporting_repository.dart';
import 'package:finance_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';


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
    errorReportingRepository.recordError(error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap({
  required FutureOr<Widget> Function() builder,
  required ErrorReportingRepository errorReportingRepository,
}) async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  
  final appInitializer = AppInitializer(errorReportingRepository);
  await appInitializer.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (details) {
    errorReportingRepository.recordError(
      details.exception,
      details.stack,
      reason: 'Flutter framework error',
      extra: {
        'library': details.library,
        'context': details.context?.toString(),
      },
    );
  };

  binding.platformDispatcher.onError = (error, stackTrace) {
    errorReportingRepository.recordError(
      error,
      stackTrace,
      reason: 'Unhandled platform error',
    );
    return true;
  };
  Bloc.observer = AppBlocObserver(
    errorReportingRepository: errorReportingRepository,
  );

  runApp(await builder());
}
