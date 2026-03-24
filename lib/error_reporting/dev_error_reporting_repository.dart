import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:genui_life_goal_simulator/error_reporting/error_reporting.dart';

/// {@template DevErrorReportingRepository}
/// Development implementation of [ErrorReportingRepository].
/// {@endtemplate}
class DevErrorReportingRepository extends ErrorReportingRepository {
  DevErrorReportingRepository({void Function(String message)? log})
    : _log = log ?? debugPrint;

  final void Function(String message) _log;

  @override
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? extra,
  }) async {
    _log('$error');
    _log('$stackTrace');
  }

  @override
  void handleFlutterError(FlutterErrorDetails details) {
    unawaited(recordError(details.exception, details.stack));
  }

  @override
  bool handlePlatformError(Object error, StackTrace stackTrace) {
    unawaited(recordError(error, stackTrace));
    return true; // Indicates the error was handled
  }
}
