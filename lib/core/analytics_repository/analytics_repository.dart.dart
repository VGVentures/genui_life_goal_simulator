import 'package:flutter/material.dart';

abstract class AnalyticsRepository {
  Future<void> init();
  Future<void> trackEvent(String name, {Map<String, Object>? parameters});
  Future<void> setUserId(String? userId);
  NavigatorObserver get navigationObserver;
}
