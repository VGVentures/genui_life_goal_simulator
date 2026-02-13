import 'package:finance_app/core/error_reporting_repository/src/error_reporting_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// {@template ProdErrorReportingRepository}
/// Production environment implementation of [ErrorReportingRepository].
/// {@endtemplate}
class ProdErrorReportingRepository extends ErrorReportingRepository {
  final Hub _sentryHub;

  ProdErrorReportingRepository(this._sentryHub);

  @override
  Future<void> init() async {
    debugPrint('Sentry error reporting initialized');
  }

  /// Report error to crash service
  @override
  Future<void> recordError(
    dynamic error, 
    StackTrace? stackTrace, {
      String? reason,
      Map<String, dynamic>? extra,

  }) async {
    if (kDebugMode) {
      debugPrint('🔴 Error: $error');
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
      if (reason != null) {
        debugPrint('Reason: $reason');
      }
    }

    try {
      // Capture exception in Sentry
      await _sentryHub.captureException(
        error,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          if (reason != null) 'reason': reason,
          if (extra != null) ...extra,
        }),
      );
    } catch (e) {
      // Don't let error reporting crash the app
      debugPrint('Failed to report error to Sentry: $e');
    }
  }

  @override
  Future<void> setUserIdentifier(String? identifier) async {
    if (identifier == null || identifier.isEmpty) {
      // Clear user context
      try {
        _sentryHub.configureScope((scope) => scope.setUser(null));
      } catch (e) {
        debugPrint('Failed to clear user in Sentry: $e');
      }
      return;
    }

    try {
      _sentryHub.configureScope((scope) {
        scope.setUser(SentryUser(id: identifier));
      });
      
      if (kDebugMode) {
        debugPrint('👤 User identifier set: $identifier');
      }
    } catch (e) {
      debugPrint('Failed to set user identifier in Sentry: $e');
    }
  }
}
