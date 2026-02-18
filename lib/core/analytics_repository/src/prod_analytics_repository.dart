import 'package:finance_app/core/analytics_repository/src/analytics_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:wiredash/wiredash.dart';

/// {@template ProdAnalyticsRepository}
/// Production implementation of [AnalyticsRepository].
/// Delegates analytics events to Firebase Analytics and Wiredash.
/// {@endtemplate}
class ProdAnalyticsRepository extends AnalyticsRepository {
  /// {@macro ProdAnalyticsRepository}
  ProdAnalyticsRepository({
    required FirebaseAnalytics firebaseAnalytics,
    required WiredashAnalytics wiredashAnalytics,
  }) : _firebaseAnalytics = firebaseAnalytics,
       _wiredashAnalytics = wiredashAnalytics,
       _navigatorObserver = FirebaseAnalyticsObserver(
         analytics: firebaseAnalytics,
       );
  final FirebaseAnalytics _firebaseAnalytics;
  final WiredashAnalytics _wiredashAnalytics;
  final FirebaseAnalyticsObserver _navigatorObserver;

  @override
  Future<void> trackEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    await _firebaseAnalytics.logEvent(
      name: name,
      parameters: parameters,
    );
    await _wiredashAnalytics.trackEvent(name, data: parameters);
  }

  @override
  NavigatorObserver get navigatorObserver => _navigatorObserver;
}
