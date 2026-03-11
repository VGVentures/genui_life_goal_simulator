import 'package:finance_app/app/presentation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _items = [
  PieChartItem(
    label: 'Groceries',
    value: 1420,
    amount: r'$1,420',
    color: Color(0xFFE98AD4),
  ),
  PieChartItem(
    label: 'Shopping',
    value: 1420,
    amount: r'$1,420',
    color: Color(0xFFF2C01C),
  ),
  PieChartItem(
    label: 'Dining Out',
    value: 1420,
    amount: r'$1,420',
    color: Color(0xFFFA912A),
  ),
];

Future<void> _pumpChart(
  WidgetTester tester, {
  List<PieChartItem> items = _items,
  int? selectedIndex,
  ValueChanged<int?>? onSelectedIndexChanged,
  bool withTheme = true,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: withTheme ? AppTheme(LightThemeColors()).themeData : null,
      home: Scaffold(
        body: PieChartComponent(
          items: items,
          totalLabel: 'Total',
          totalAmount: r'$4,260',
          selectedIndex: selectedIndex,
          onSelectedIndexChanged: onSelectedIndexChanged,
        ),
      ),
    ),
  );
}

/// Creates a mouse hover gesture at [position] and returns the [TestGesture].
Future<TestGesture> _hoverAt(WidgetTester tester, Offset position) async {
  final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await tester.pump();
  await gesture.moveTo(position);
  await tester.pump();
  return gesture;
}

void main() {
  group(PieChartComponent, () {
    group('renders', () {
      testWidgets('total label and amount in center', (tester) async {
        await _pumpChart(tester);

        expect(find.text('Total'), findsOneWidget);
        expect(find.text(r'$4,260'), findsOneWidget);
      });

      testWidgets('legend labels for each item', (tester) async {
        await _pumpChart(tester);

        expect(find.text('Groceries'), findsOneWidget);
        expect(find.text('Shopping'), findsOneWidget);
        expect(find.text('Dining Out'), findsOneWidget);
      });

      testWidgets('legend amounts for each item', (tester) async {
        await _pumpChart(tester);

        expect(find.text(r'$1,420'), findsNWidgets(3));
      });

      testWidgets('percentage for each item', (tester) async {
        await _pumpChart(tester);

        expect(find.text('33%'), findsNWidgets(3));
      });

      testWidgets('fl_chart $PieChart widget', (tester) async {
        await _pumpChart(tester);

        expect(find.byType(PieChart), findsOneWidget);
      });

      testWidgets('color indicators', (tester) async {
        await _pumpChart(tester);

        expect(find.byType(DecoratedBox), findsWidgets);
      });
    });

    group('legend hover', () {
      testWidgets('calls onSelectedIndexChanged with index', (tester) async {
        int? selectedIndex;
        await _pumpChart(
          tester,
          onSelectedIndexChanged: (index) => selectedIndex = index,
        );

        final groceriesCenter = tester.getCenter(find.text('Groceries'));
        await _hoverAt(tester, groceriesCenter);
        expect(selectedIndex, 0);
      });

      testWidgets('updates center text to selected item', (tester) async {
        await _pumpChart(tester, selectedIndex: 0);

        expect(find.text(r'$1,420'), findsWidgets);
        expect(find.text('Groceries'), findsNWidgets(2));
        expect(find.text('33%'), findsWidgets);
      });

      testWidgets('deselects when hover exits legend row', (tester) async {
        int? selectedIndex = 0;
        await _pumpChart(
          tester,
          onSelectedIndexChanged: (index) => selectedIndex = index,
        );

        final groceriesCenter = tester.getCenter(find.text('Groceries'));
        final gesture = await _hoverAt(tester, groceriesCenter);
        expect(selectedIndex, 0);

        // Move pointer away from legend row
        await gesture.moveTo(Offset.zero);
        await tester.pump();
        expect(selectedIndex, isNull);
      });

      testWidgets('selected legend row has highlight background', (
        tester,
      ) async {
        await _pumpChart(tester, selectedIndex: 0);

        final containers = tester.widgetList<Container>(
          find.byType(Container),
        );
        final hasHighlight = containers.any((c) {
          final decoration = c.decoration;
          if (decoration is BoxDecoration) {
            return decoration.color != null &&
                decoration.color != Colors.transparent;
          }
          return false;
        });
        expect(hasHighlight, isTrue);
      });
    });

    group('uncontrolled mode', () {
      testWidgets('manages selection internally', (tester) async {
        await _pumpChart(tester);

        expect(find.text('Total'), findsOneWidget);

        final groceriesCenter = tester.getCenter(find.text('Groceries'));
        await _hoverAt(tester, groceriesCenter);

        expect(find.text('Groceries'), findsNWidgets(2));
      });
    });

    group('controlled mode', () {
      testWidgets('reflects external selectedIndex', (tester) async {
        await _pumpChart(tester, selectedIndex: 1);

        expect(find.text('Shopping'), findsNWidgets(2));
      });

      testWidgets('transitions from controlled to uncontrolled', (
        tester,
      ) async {
        await _pumpChart(tester, selectedIndex: 0);

        await _pumpChart(tester);
        expect(find.text('Total'), findsOneWidget);
      });

      testWidgets('clears internal state when switching to controlled', (
        tester,
      ) async {
        // Start uncontrolled and select via legend hover
        await _pumpChart(tester);
        final groceriesCenter = tester.getCenter(find.text('Groceries'));
        await _hoverAt(tester, groceriesCenter);
        expect(find.text('Groceries'), findsNWidgets(2));

        // Switch to controlled mode — internal state should be cleared
        await _pumpChart(tester, selectedIndex: 1);
        expect(find.text('Shopping'), findsNWidgets(2));
      });
    });

    group('edge cases', () {
      testWidgets('single item renders without error', (tester) async {
        await _pumpChart(tester, items: [_items.first]);

        expect(find.byType(PieChartComponent), findsOneWidget);
        expect(find.text('Groceries'), findsOneWidget);
      });

      testWidgets('all zero values renders without error', (tester) async {
        await _pumpChart(
          tester,
          items: const [
            PieChartItem(
              label: 'Empty',
              value: 0,
              amount: r'$0',
              color: Color(0xFFE98AD4),
            ),
          ],
        );

        expect(find.byType(PieChartComponent), findsOneWidget);
        expect(find.text('0%'), findsOneWidget);
      });

      testWidgets('renders without $AppColors extension', (tester) async {
        await _pumpChart(tester, withTheme: false);

        expect(find.byType(PieChartComponent), findsOneWidget);
      });

      testWidgets('selectedIndex out of range shows total', (tester) async {
        await _pumpChart(tester, selectedIndex: 99);

        expect(find.text('Total'), findsOneWidget);
        expect(find.text(r'$4,260'), findsOneWidget);
      });
    });
  });
}
