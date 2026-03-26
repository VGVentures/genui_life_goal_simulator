import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/l10n/l10n.dart';

const _items = [
  ComparisonTableItem(
    label: 'Groceries',
    lastMonthAmount: 300,
    actualMonthAmount: 315,
  ),
  ComparisonTableItem(
    label: 'Dining',
    lastMonthAmount: 200,
    actualMonthAmount: 170,
  ),
];

Future<void> _pumpTable(
  WidgetTester tester, {
  List<ComparisonTableItem> items = _items,
  bool withTheme = true,
}) {
  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: withTheme ? AppTheme(LightThemeColors()).themeData : null,
      home: Scaffold(
        body: ComparisonTable(items: items),
      ),
    ),
  );
}

void main() {
  group(ComparisonTable, () {
    group('renders', () {
      testWidgets('labels for each item', (tester) async {
        await _pumpTable(tester);

        expect(find.text('Groceries'), findsOneWidget);
        expect(find.text('Dining'), findsOneWidget);
      });

      testWidgets('formatted last month amounts', (tester) async {
        await _pumpTable(tester);

        expect(find.text(r'$300'), findsOneWidget);
        expect(find.text(r'$200'), findsOneWidget);
      });

      testWidgets('formatted this month amounts', (tester) async {
        await _pumpTable(tester);

        expect(find.text(r'$315'), findsOneWidget);
        expect(find.text(r'$170'), findsOneWidget);
      });

      testWidgets('Last month and This month column labels', (tester) async {
        await _pumpTable(tester);

        expect(find.text('Last month'), findsNWidgets(_items.length));
        expect(find.text('This month'), findsNWidgets(_items.length));
      });

      testWidgets('calculated delta percentages', (tester) async {
        await _pumpTable(tester);

        expect(find.text('+5%'), findsOneWidget);
        expect(find.text('-15%'), findsOneWidget);
      });

      testWidgets('dividers for each row', (tester) async {
        await _pumpTable(tester);

        expect(find.byType(Divider), findsNWidgets(_items.length));
      });
    });

    testWidgets('positive delta renders in success color', (tester) async {
      await _pumpTable(tester);

      final text = tester.widget<Text>(find.text('+5%'));
      final expectedColor = LightThemeColors().success;
      expect(text.style?.color, expectedColor);
    });

    testWidgets('negative delta renders in error color', (tester) async {
      await _pumpTable(tester);

      final text = tester.widget<Text>(find.text('-15%'));
      final expectedColor = LightThemeColors().error;
      expect(text.style?.color, expectedColor);
    });

    testWidgets('zero delta renders +0% in success color', (tester) async {
      await _pumpTable(
        tester,
        items: const [
          ComparisonTableItem(
            label: 'Equal',
            lastMonthAmount: 100,
            actualMonthAmount: 100,
          ),
        ],
      );

      expect(find.text('+0%'), findsOneWidget);
      final text = tester.widget<Text>(find.text('+0%'));
      final expectedColor = LightThemeColors().success;
      expect(text.style?.color, expectedColor);
    });

    testWidgets('zero lastMonthAmount shows em dash', (tester) async {
      await _pumpTable(
        tester,
        items: const [
          ComparisonTableItem(
            label: 'New',
            lastMonthAmount: 0,
            actualMonthAmount: 50,
          ),
        ],
      );

      expect(find.text('\u2014'), findsOneWidget);
    });

    testWidgets('without $AppColors extension', (tester) async {
      await _pumpTable(tester, withTheme: false);

      expect(find.byType(ComparisonTable), findsOneWidget);
    });

    testWidgets('empty list without error', (tester) async {
      await _pumpTable(tester, items: const []);

      expect(find.byType(ComparisonTable), findsOneWidget);
      expect(find.byType(Divider), findsNothing);
    });
  });
}
