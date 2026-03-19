import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgv_genui_financial_advisor/l10n/l10n.dart';
import 'package:vgv_genui_financial_advisor/onboarding/intro/view/intro_mobile_view.dart';
import 'package:vgv_genui_financial_advisor/onboarding/intro/view/widgets/widgets.dart';

Future<void> _pump(
  WidgetTester tester, {
  VoidCallback? onGetStarted,
}) {
  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: IntroMobileView(onGetStarted: onGetStarted),
    ),
  );
}

void main() {
  group(IntroMobileView, () {
    group('renders', () {
      testWidgets('title prefix text', (tester) async {
        await _pump(tester);
        await tester.pumpAndSettle();

        expect(find.text('GenUI '), findsOneWidget);
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

      testWidgets('$GetStartedButton with localized label', (tester) async {
        await _pump(tester);
        await tester.pumpAndSettle();

        expect(find.byType(GetStartedButton), findsOneWidget);
        expect(find.text('Get Started'), findsOneWidget);
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
