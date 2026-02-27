import 'package:finance_app/intro/view/widgets/intro_badge.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester) {
  return tester.pumpWidget(
    const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: Center(child: IntroBadge())),
    ),
  );
}

void main() {
  group(IntroBadge, () {
    testWidgets('shows year pill with 2026', (tester) async {
      await _pump(tester);
      await tester.pumpAndSettle();

      expect(find.text('2026'), findsOneWidget);
    });

    testWidgets('shows Gen UI pill with localized label', (tester) async {
      await _pump(tester);
      await tester.pumpAndSettle();

      expect(find.text('Gen UI'), findsOneWidget);
    });

    testWidgets('renders two overlapping pills', (tester) async {
      await _pump(tester);
      await tester.pumpAndSettle();

      // Year pill and Gen UI pill are both present.
      expect(find.text('2026'), findsOneWidget);
      expect(find.text('Gen UI'), findsOneWidget);
    });
  });
}
