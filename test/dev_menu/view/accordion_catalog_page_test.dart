import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/dev_menu/dev_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpPage(WidgetTester tester) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: const AccordionCatalogPage(),
    ),
  );
}

void main() {
  group('AccordionCatalogPage', () {
    group('renders', () {
      testWidgets('Accordion app bar title', (tester) async {
        await _pumpPage(tester);

        expect(find.text('Accordion'), findsOneWidget);
      });

      testWidgets('AppAccordion widget', (tester) async {
        await _pumpPage(tester);

        expect(find.byType(AppAccordion), findsOneWidget);
      });

      testWidgets('section label', (tester) async {
        await _pumpPage(tester);

        expect(
          find.text('Collapsed state (tap to expand)'),
          findsOneWidget,
        );
      });
    });
  });
}
