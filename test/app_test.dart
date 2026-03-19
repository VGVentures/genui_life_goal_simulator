import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vgv_genui_financial_advisor/app.dart';
import 'package:vgv_genui_financial_advisor/error_reporting/error_reporting.dart';
import 'package:vgv_genui_financial_advisor/onboarding/intro/intro.dart';

void main() {
  group(App, () {
    testWidgets('renders $IntroPage as initial screen', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<ErrorReportingRepository>.value(
              value: DevErrorReportingRepository(),
            ),
          ],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(IntroPage), findsOneWidget);
    });
  });
}
