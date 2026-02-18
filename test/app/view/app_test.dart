import 'package:finance_app/app/app.dart';
import 'package:finance_app/core/analytics_repository/analytics_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('renders Scaffold', (tester) async {
      final analyticsRepository = DevAnalyticsRepository();
      await tester.pumpWidget(
        App(
          navigatorObservers: [analyticsRepository.navigatorObserver],
        ),
      );
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
