import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/dev_menu/view/horizontal_bar_catalog_page.dart';

Future<void> _pump(WidgetTester tester) {
  return tester.pumpWidget(
    const MaterialApp(
      home: HorizontalBarCatalogPage(),
    ),
  );
}

void main() {
  group(HorizontalBarCatalogPage, () {
    testWidgets('renders app bar with correct title', (tester) async {
      await _pump(tester);

      expect(find.text('HorizontalBar'), findsOneWidget);
    });

    testWidgets('renders two HorizontalBar widgets', (tester) async {
      await _pump(tester);

      expect(find.byType(HorizontalBar), findsNWidgets(2));
    });

    testWidgets('negative variant shows -5%', (tester) async {
      await _pump(tester);

      expect(find.text('-5%'), findsOneWidget);
    });

    testWidgets('positive variant shows +10%', (tester) async {
      await _pump(tester);

      expect(find.text('+10%'), findsOneWidget);
    });

    testWidgets('renders category and amount for both bars', (tester) async {
      await _pump(tester);

      expect(find.text('Dining'), findsNWidgets(2));
      expect(find.text(r'$420'), findsNWidgets(2));
      expect(find.text('Groceries'), findsNWidgets(2));
    });
  });
}
