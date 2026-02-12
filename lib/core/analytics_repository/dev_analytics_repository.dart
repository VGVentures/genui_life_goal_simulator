import 'dart:developer';

import 'package:finance_app/core/analytics_repository/analytics_repository.dart.dart';
import 'package:flutter/widgets.dart';

/// {@template DevAnalyticsRepository}
/// Development implementation of [AnalyticsRepository].
/// Prints analytics events to the console for debugging.
/// {@endtemplate}
class DevAnalyticsRepository extends AnalyticsRepository {
  @override
  Future<void> init() async {
    log('DevAnalyticsRepository initialized');
  }

  @override
  Future<void> trackEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    log('Analytics Event: $name, parameters: $parameters');
  }

  @override
  Future<void> setUserId(String? userId) async {
    log('Analytics User ID set: $userId');
  }

  @override
  NavigatorObserver get navigationObserver => _NoOpNavigatorObserver();
}

class _NoOpNavigatorObserver extends NavigatorObserver {}
