import 'package:flutter/material.dart';

export 'dev_error_reporting_repository.dart';

/// {@template ErrorReportingRepository}
/// Abstract class defining the contract for crash reporting managers.
/// {@endtemplate}
abstract class ErrorReportingRepository {
  /// Record errors to crash reporting service
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? extra,
  });

  // Handles Flutter errors from [FlutterError.onError]
  void handleFlutterError(FlutterErrorDetails details);

  // Handles platform errors from [PlatformDispatcher.onError]
  bool handlePlatformError(Object error, StackTrace stackTrace);
}
