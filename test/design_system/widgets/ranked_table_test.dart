import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

const _items = [
  RankedTableItem(
    title: 'The French Laundry',
    amount: r'$350',
    delta: '+15%',
  ),
  RankedTableItem(
    title: 'Osteria Francescana',
    amount: r'$310',
    delta: '+10%',
  ),
  RankedTableItem(
    title: 'Alinea',
    amount: r'$300',
    delta: '+30%',
  ),
];

Future<void> _pumpTable(WidgetTester tester, {bool withTheme = true}) {
  const widget = Scaffold(
    body: RankedTable(items: _items),
  );
  return tester.pumpWidget(
    MaterialApp(
      theme: withTheme ? AppTheme(LightThemeColors()).themeData : null,
      home: widget,
    ),
  );
}

void main() {
  group(RankedTable, () {
    group('renders', () {
      testWidgets('rank numbers for each item', (tester) async {
        await _pumpTable(tester);

        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
      });

      testWidgets('titles for each item', (tester) async {
        await _pumpTable(tester);

        expect(find.text('The French Laundry'), findsOneWidget);
        expect(find.text('Osteria Francescana'), findsOneWidget);
        expect(find.text('Alinea'), findsOneWidget);
      });

      testWidgets('amounts for each item', (tester) async {
        await _pumpTable(tester);

        expect(find.text(r'$350'), findsOneWidget);
        expect(find.text(r'$310'), findsOneWidget);
        expect(find.text(r'$300'), findsOneWidget);
      });

      testWidgets('deltas for each item', (tester) async {
        await _pumpTable(tester);

        expect(find.text('+15%'), findsOneWidget);
        expect(find.text('+10%'), findsOneWidget);
        expect(find.text('+30%'), findsOneWidget);
      });

      testWidgets('dividers between rows', (tester) async {
        await _pumpTable(tester);

        expect(find.byType(Divider), findsNWidgets(_items.length));
      });
    });

    testWidgets('positive delta renders in success color', (tester) async {
      await _pumpTable(tester);

      final text = tester.widget<Text>(find.text('+15%'));
      final expectedColor = LightThemeColors().success;
      expect(text.style?.color, expectedColor);
    });

    testWidgets('negative delta renders in error color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme(LightThemeColors()).themeData,
          home: const Scaffold(
            body: RankedTable(
              items: [
                RankedTableItem(
                  title: 'Test',
                  amount: r'$100',
                  delta: '-5%',
                ),
              ],
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('-5%'));
      final expectedColor = LightThemeColors().error;
      expect(text.style?.color, expectedColor);
    });

    testWidgets('without $AppColors extension', (tester) async {
      await _pumpTable(tester, withTheme: false);

      expect(find.byType(RankedTable), findsOneWidget);
    });

    testWidgets('empty list without error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme(LightThemeColors()).themeData,
          home: const Scaffold(
            body: RankedTable(items: []),
          ),
        ),
      );

      expect(find.byType(RankedTable), findsOneWidget);
      expect(find.byType(Divider), findsNothing);
    });
  });
}
