import 'package:finance_app/l10n/l10n.dart';
import 'package:finance_app/onboarding/intro/view/intro_desktop_view.dart';
import 'package:finance_app/onboarding/intro/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester, {
  VoidCallback? onGetStarted,
}) {
  tester.view.physicalSize = const Size(1920, 1080);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: IntroDesktopView(onGetStarted: onGetStarted),
    ),
  );
}

void main() {
  group(IntroDesktopView, () {
    group('renders', () {
      testWidgets('title prefix text', (tester) async {
        await _pump(tester);
        await tester.pumpAndSettle();

        expect(find.text('Gen UI x '), findsOneWidget);
      });

      testWidgets('VGV gradient text', (tester) async {
        await _pump(tester);
        await tester.pumpAndSettle();

        expect(find.text('VGV'), findsOneWidget);
      });

      testWidgets('description text', (tester) async {
        await _pump(tester);
        await tester.pumpAndSettle();

        expect(
          find.text(
            'This demo shows how Generative UI transforms financial products '
            'from static dashboards into adaptive experiences. The UI reshapes '
            'itself based on goals, behavior, and context.',
          ),
          findsOneWidget,
        );
      });

      testWidgets('$IntroBadges', (tester) async {
        await _pump(tester);
        await tester.pumpAndSettle();

        expect(find.byType(IntroBadges), findsOneWidget);
      });

      testWidgets('$GetStartedButton with uppercased label', (tester) async {
        await _pump(tester);
        await tester.pumpAndSettle();

        expect(find.byType(GetStartedButton), findsOneWidget);
        expect(find.text('GET STARTED'), findsOneWidget);
      });
    });

    testWidgets('tapping $GetStartedButton calls onGetStarted', (
      tester,
    ) async {
      var called = false;
      await _pump(tester, onGetStarted: () => called = true);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(GetStartedButton));
      await tester.pump();

      expect(called, isTrue);
    });

    testWidgets('renders without onGetStarted', (tester) async {
      await _pump(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(GetStartedButton));
      await tester.pump();
    });
  });
}
