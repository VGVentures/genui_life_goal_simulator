import 'dart:developer' as developer;

import 'package:finance_app/core/analytics_repository/src/analytics_repository.dart';
import 'package:flutter/widgets.dart';

/// Signature for a logging function.
typedef LogFunction = void Function(String message);

/// {@template DevAnalyticsRepository}
/// Development implementation of [AnalyticsRepository].
/// Prints analytics events to the console for debugging.
/// {@endtemplate}
class DevAnalyticsRepository extends AnalyticsRepository {
  /// {@macro DevAnalyticsRepository}
  DevAnalyticsRepository({LogFunction? log}) : _log = log ?? developer.log;

  final LogFunction _log;

  static const trackEventLogMessage = 'Analytics Event:';

  @override
  Future<void> trackEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    _log('$trackEventLogMessage $name, parameters: $parameters');
  }

  @override
  NavigatorObserver get navigatorObserver => _NoOpNavigatorObserver();
}

class _NoOpNavigatorObserver extends NavigatorObserver {}
