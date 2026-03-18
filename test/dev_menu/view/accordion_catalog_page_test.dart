import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';
import 'package:vgv_genui_financial_advisor/dev_menu/dev_menu.dart';

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
