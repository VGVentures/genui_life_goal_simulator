import 'package:finance_app/intro/intro.dart';
import 'package:finance_app/intro/view/intro_desktop_view.dart';
import 'package:finance_app/intro/view/intro_mobile_view.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester, {
  Size size = const Size(1920, 1080),
  VoidCallback? onGetStarted,
}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: IntroPage(onGetStarted: onGetStarted),
    ),
  );
}

void main() {
  group(IntroPage, () {
    testWidgets('renders $IntroDesktopView on wide screen', (tester) async {
      await _pump(tester);
      await tester.pumpAndSettle();

      expect(find.byType(IntroDesktopView), findsOneWidget);
      expect(find.byType(IntroMobileView), findsNothing);
    });

    testWidgets('renders $IntroMobileView on narrow screen', (tester) async {
      await _pump(tester, size: const Size(599, 900));
      await tester.pumpAndSettle();

      expect(find.byType(IntroMobileView), findsOneWidget);
      expect(find.byType(IntroDesktopView), findsNothing);
    });

    testWidgets('forwards onGetStarted to desktop view', (tester) async {
      var called = false;
      await _pump(tester, onGetStarted: () => called = true);
      await tester.pumpAndSettle();

      final view = tester.widget<IntroDesktopView>(
        find.byType(IntroDesktopView),
      );
      view.onGetStarted?.call();

      expect(called, isTrue);
    });

    testWidgets('forwards onGetStarted to mobile view', (tester) async {
      var called = false;
      await _pump(
        tester,
        size: const Size(599, 900),
        onGetStarted: () => called = true,
      );
      await tester.pumpAndSettle();

      final view = tester.widget<IntroMobileView>(
        find.byType(IntroMobileView),
      );
      view.onGetStarted?.call();

      expect(called, isTrue);
    });

    testWidgets('renders without onGetStarted', (tester) async {
      await _pump(tester);
      await tester.pumpAndSettle();

      expect(find.byType(IntroPage), findsOneWidget);
    });
  });
}
