import 'package:flutter/material.dart';

abstract class AnalyticsRepository {
  Future<void> trackEvent(String name, {Map<String, Object>? parameters});
  NavigatorObserver get navigatorObserver;
}
