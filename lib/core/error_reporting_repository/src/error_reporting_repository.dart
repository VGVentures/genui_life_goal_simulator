import 'dart:async';

/// {@template ErrorReportingRepository}
/// Abstract class defining the contract for crash reporting managers.
/// {@endtemplate}
abstract class ErrorReportingRepository {
  /// Initializes the crash manager
  Future<void> init();

  /// Record errors to crash reporting service
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? extra,
  });

  //Sets the user identifier for crash reports
  Future<void> setUserIdentifier(String? identifier);

  // // Handles Flutter errors from [FlutterError.onError]
  // void handleFlutterError(FlutterErrorDetails details) {
  //   recordError(
  //      details.exception,
  //      stackTrace: details.stack,
  //      fatal: true,
  //   );
  // }

  // // Handles platform errors from [PlatformDispatcher.onError]
  // bool handlePlatformError(Object error, StackTrace stackTrace) {
  //    recordError(error, stackTrace: stackTrace, fatal: true);
  //    return true;
  // }
}
