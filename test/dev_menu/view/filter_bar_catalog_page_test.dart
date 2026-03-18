import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';
import 'package:vgv_genui_financial_advisor/dev_menu/view/filter_bar_catalog_page.dart';

Future<void> _pumpPage(WidgetTester tester) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: const FilterBarCatalogPage(),
    ),
  );
}

void main() {
  group('$FilterBarCatalogPage', () {
    group('renders', () {
      testWidgets('app bar title', (tester) async {
        await _pumpPage(tester);

        expect(find.text('Filter Bar'), findsOneWidget);
      });

      testWidgets('Interactive section', (tester) async {
        await _pumpPage(tester);

        expect(find.text('Interactive'), findsOneWidget);
      });

      testWidgets('Disabled All Chip section', (tester) async {
        await _pumpPage(tester);

        expect(find.text('Disabled All Chip'), findsOneWidget);
      });

      testWidgets('FilterBar widgets', (tester) async {
        await _pumpPage(tester);

        expect(find.byType(FilterBar), findsNWidgets(2));
      });

      testWidgets('All chip in each FilterBar', (tester) async {
        await _pumpPage(tester);

        expect(find.text('All'), findsNWidgets(2));
      });
    });

    testWidgets('tapping a category chip toggles its selection', (
      tester,
    ) async {
      await _pumpPage(tester);

      // Find category chips (excluding All chips)
      final categoryChips = find.byWidgetPredicate(
        (widget) =>
            widget is CategoryFilterChip &&
            widget.color != FilterChipColor.pink,
      );

      // Tap the first category chip
      await tester.tap(categoryChips.first);
      await tester.pump();

      // Verify selection count updated
      expect(find.textContaining('1 of 9 categories selected'), findsWidgets);
    });

    testWidgets('tapping All chip toggles all categories', (tester) async {
      await _pumpPage(tester);

      // Find the first All chip (Interactive section)
      final allChips = find.text('All');
      await tester.tap(allChips.first);
      await tester.pump();

      // All categories should be selected
      expect(find.textContaining('9 of 9 categories selected'), findsWidgets);
    });
  });
}
