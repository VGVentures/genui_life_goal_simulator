import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/dev_menu/dev_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpPage(WidgetTester tester) {
  return tester.pumpWidget(
    const MaterialApp(home: RadioCardCatalogPage()),
  );
}

void main() {
  group('RadioCardCatalogPage', () {
    group('renders', () {
      testWidgets('RadioCard app bar title', (tester) async {
        await _pumpPage(tester);

        expect(find.text('RadioCard'), findsOneWidget);
      });

      testWidgets('Monthly and Yearly cards', (tester) async {
        await _pumpPage(tester);

        expect(find.text('Monthly'), findsOneWidget);
        expect(find.text('Yearly'), findsOneWidget);
      });

      testWidgets('Monthly selected by default', (tester) async {
        await _pumpPage(tester);

        final monthlyCard = tester.widget<RadioCard>(
          find.widgetWithText(RadioCard, 'Monthly'),
        );
        expect(monthlyCard.isSelected, isTrue);

        final yearlyCard = tester.widget<RadioCard>(
          find.widgetWithText(RadioCard, 'Yearly'),
        );
        expect(yearlyCard.isSelected, isFalse);
      });
    });

    testWidgets('tapping Yearly card updates selection', (tester) async {
      await _pumpPage(tester);

      await tester.tap(find.text('Yearly'));
      await tester.pump();

      final yearlyCard = tester.widget<RadioCard>(
        find.widgetWithText(RadioCard, 'Yearly'),
      );
      expect(yearlyCard.isSelected, isTrue);

      final monthlyCard = tester.widget<RadioCard>(
        find.widgetWithText(RadioCard, 'Monthly'),
      );
      expect(monthlyCard.isSelected, isFalse);
    });
  });
}
