import 'dart:async';

import 'package:finance_app/core/error_reporting_repository/error_reporting_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// {@template ProdErrorReportingRepository}
/// Production environment implementation of [ErrorReportingRepository].
/// {@endtemplate}
class ProdErrorReportingRepository extends ErrorReportingRepository {
  ProdErrorReportingRepository(this._sentryHub);

  final Hub _sentryHub;

  // Report error to crash service
  @override
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? extra,
  }) async {
    await _sentryHub.captureException(
      error,
      stackTrace: stackTrace,
      hint: Hint.withMap({
        'reason': ?reason,
        ...?extra,
      }),
    );
  }

  @override
  void handleFlutterError(FlutterErrorDetails details) {
    unawaited(
      recordError(
        details.exception,
        details.stack,
        reason: 'Flutter framework error',
        extra: {
          'library': details.library,
          'context': details.context?.toString(),
        },
      ),
    );
  }

  @override
  bool handlePlatformError(Object error, StackTrace stackTrace) {
    unawaited(
      recordError(
        error,
        stackTrace,
        reason: 'Unhandled platform error',
      ),
    );

    return true; // Indicates the error was handled
  }
}
