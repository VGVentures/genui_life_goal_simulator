import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:finance_app/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestableWidget({required Widget child}) {
    return MaterialApp(
      theme: AppThemes.light.themeData.themeData,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );
  }

  Future<void> setLargeScreenSize(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());
  }

  group(KickOffPage, () {
    group('renders', () {
      testWidgets('without errors', (tester) async {
        await setLargeScreenSize(tester);
        await tester.pumpWidget(
          buildTestableWidget(child: const KickOffPage()),
        );

        expect(find.byType(KickOffPage), findsOneWidget);
      });

      testWidgets('two TrustBadge widgets', (tester) async {
        await setLargeScreenSize(tester);
        await tester.pumpWidget(
          buildTestableWidget(child: const KickOffPage()),
        );

        expect(find.byType(TrustBadge), findsNWidgets(2));
      });

      testWidgets('trust badge text', (tester) async {
        await setLargeScreenSize(tester);
        await tester.pumpWidget(
          buildTestableWidget(child: const KickOffPage()),
        );

        final context = tester.element(find.byType(KickOffPage));
        final l10n = AppLocalizations.of(context);

        expect(find.text(l10n.trustBadgeText), findsOneWidget);
      });

      testWidgets('not hardcoded badge text', (tester) async {
        await setLargeScreenSize(tester);
        await tester.pumpWidget(
          buildTestableWidget(child: const KickOffPage()),
        );

        final context = tester.element(find.byType(KickOffPage));
        final l10n = AppLocalizations.of(context);

        expect(find.text(l10n.notHardcodedBadgeText), findsOneWidget);
      });

      testWidgets('title text', (tester) async {
        await setLargeScreenSize(tester);
        await tester.pumpWidget(
          buildTestableWidget(child: const KickOffPage()),
        );

        final context = tester.element(find.byType(KickOffPage));
        final l10n = AppLocalizations.of(context);

        expect(find.text(l10n.kickOffTitle), findsOneWidget);
      });

      testWidgets('description text on desktop', (tester) async {
        await setLargeScreenSize(tester);
        await tester.pumpWidget(
          buildTestableWidget(child: const KickOffPage()),
        );

        final context = tester.element(find.byType(KickOffPage));
        final l10n = AppLocalizations.of(context);

        expect(find.text(l10n.kickOffDescription), findsOneWidget);
      });

      testWidgets('next button with arrow icon', (tester) async {
        await setLargeScreenSize(tester);
        await tester.pumpWidget(
          buildTestableWidget(child: const KickOffPage()),
        );

        expect(find.byType(OutlinedButton), findsOneWidget);
        expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      });

      testWidgets('ResponsiveScaffold', (tester) async {
        await setLargeScreenSize(tester);
        await tester.pumpWidget(
          buildTestableWidget(child: const KickOffPage()),
        );

        expect(find.byType(ResponsiveScaffold), findsOneWidget);
      });

      testWidgets('Scaffold with correct background color', (tester) async {
        await setLargeScreenSize(tester);
        await tester.pumpWidget(
          buildTestableWidget(child: const KickOffPage()),
        );

        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
        final appColors = LightThemeColors();

        expect(scaffold.backgroundColor, equals(appColors.primary));
      });
    });

    group('interactions', () {
      testWidgets('next button is tappable', (tester) async {
        await setLargeScreenSize(tester);
        await tester.pumpWidget(
          buildTestableWidget(child: const KickOffPage()),
        );

        final button = find.byType(OutlinedButton);
        expect(button, findsOneWidget);

        await tester.tap(button);
        await tester.pump();
      });
    });
  });
}
