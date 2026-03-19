import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgv_genui_financial_advisor/l10n/l10n.dart';
import 'package:vgv_genui_financial_advisor/onboarding/intro/view/widgets/intro_badges.dart';

Future<void> _pump(WidgetTester tester) {
  return tester.pumpWidget(
    const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: Center(child: IntroBadges())),
    ),
  );
}

void main() {
  group(IntroBadges, () {
    testWidgets('shows year pill with 2026', (tester) async {
      await _pump(tester);
      await tester.pumpAndSettle();

      expect(find.text('2026'), findsOneWidget);
    });

    testWidgets('shows Gen UI pill with localized label', (tester) async {
      await _pump(tester);
      await tester.pumpAndSettle();

      expect(find.text('GenUI'), findsOneWidget);
    });
  });
}
