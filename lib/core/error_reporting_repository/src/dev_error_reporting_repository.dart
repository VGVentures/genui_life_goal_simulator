import 'package:finance_app/core/error_reporting_repository/src/error_reporting_repository.dart';
import 'package:flutter/foundation.dart';

/// {@template DevErrorReportingRepository}
/// Development implementation of [ErrorReportingRepository].
/// {@endtemplate}
class DevErrorReportingRepository extends ErrorReportingRepository {
  String? _userIdentifier;

  @override
  Future<void> init() async {
    debugPrint('ErrorReportingRepository Initialized in development mode');
    debugPrint('   All errors will be logged to console only');
  }

  @override
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? extra,
  }) async {
        debugPrint('');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('ERROR Reported');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('Error: $error');
    
    if (reason != null) {
      debugPrint('Reason: $reason');
    }
    
    if (stackTrace != null) {
      debugPrint('');
      debugPrint('Stack Trace:');
      debugPrint('$stackTrace');
    }
    
    if (_userIdentifier != null) {
      debugPrint('');
      debugPrint('User Identifier: $_userIdentifier');
    }
    
    if (extra != null && extra.isNotEmpty) {
      debugPrint('');
      debugPrint('Extra Data:');
      extra.forEach((key, value) {
        debugPrint('  $key: $value');
      });
    }
    
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('');
  }


  @override
  Future<void> setUserIdentifier(String? identifier) async {
    _userIdentifier = identifier;
    debugPrint('User identifier set: $identifier');
  }
}
