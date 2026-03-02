import 'package:finance_app/app/app.dart';
import 'package:finance_app/core/analytics_repository/analytics_repository.dart';
import 'package:finance_app/core/error_reporting_repository/error_reporting_repository.dart';
import 'package:finance_app/intro/intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  group(App, () {
    testWidgets('renders $IntroPage as initial screen', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final analyticsRepository = DevAnalyticsRepository();
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<ErrorReportingRepository>.value(
              value: DevErrorReportingRepository(),
            ),
            Provider<AnalyticsRepository>.value(
              value: analyticsRepository,
            ),
          ],
          child: App(
            navigatorObservers: [analyticsRepository.navigatorObserver],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(IntroPage), findsOneWidget);
    });
  });
}
