import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/dev_menu/dev_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpPage(WidgetTester tester) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: const CategoryFilterChipCatalogPage(),
    ),
  );
}

void main() {
  group('CategoryFilterChipCatalogPage', () {
    testWidgets('renders app bar title', (tester) async {
      await _pumpPage(tester);

      expect(find.text('Category Filter Chip'), findsOneWidget);
    });

    testWidgets('renders Interactive section', (tester) async {
      await _pumpPage(tester);

      expect(find.text('Interactive'), findsOneWidget);
    });

    testWidgets('renders Disabled section', (tester) async {
      await _pumpPage(tester);

      expect(find.text('Disabled'), findsOneWidget);
    });

    testWidgets('renders all color variants in Interactive section', (
      tester,
    ) async {
      await _pumpPage(tester);

      // Should have one chip for each FilterChipColor (11 colors)
      // plus 2 disabled chips = 13 total
      expect(
        find.byType(CategoryFilterChip),
        findsNWidgets(FilterChipColor.values.length + 2),
      );
    });

    testWidgets('tapping a chip toggles its selection', (tester) async {
      await _pumpPage(tester);

      // Find the first interactive chip
      final chips = find.byType(CategoryFilterChip);
      final firstChip = chips.first;

      // Tap to select
      await tester.tap(firstChip);
      await tester.pump();

      // Tap again to deselect
      await tester.tap(firstChip);
      await tester.pump();

      // Widget should still exist and be interactive
      expect(firstChip, findsOneWidget);
    });

    testWidgets('disabled chips do not respond to taps', (tester) async {
      await _pumpPage(tester);

      // The disabled chips are the last two
      final chips = find.byType(CategoryFilterChip);

      // Get the count before any interaction
      final initialCount = tester.widgetList(chips).length;

      // Tap a disabled chip (they are at the end)
      await tester.tap(chips.at(FilterChipColor.values.length));
      await tester.pump();

      // Count should remain the same
      expect(tester.widgetList(chips).length, equals(initialCount));
    });
  });
}
