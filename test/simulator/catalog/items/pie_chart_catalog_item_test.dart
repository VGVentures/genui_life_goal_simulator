import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/simulator/catalog/items/pie_chart_catalog_item.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataModel extends Mock implements DataModel {}

Map<String, Object?> _data({
  List<Map<String, Object?>>? items,
  String? totalLabel,
  String? totalAmount,
}) => {
  'items':
      items ??
      [
        {
          'label': 'Groceries',
          'value': 1420,
          'amount': r'$1,420',
          'color': 'pink',
        },
        {
          'label': 'Transport',
          'value': 800,
          'amount': r'$800',
          'color': 'aqua',
        },
        {
          'label': 'Dining',
          'value': 600,
          'amount': r'$600',
          'color': 'mustard',
        },
      ],
  'totalLabel': totalLabel ?? 'Total Spending',
  'totalAmount': totalAmount ?? r'$2,820',
};

CatalogItemContext _context(BuildContext context, Map<String, Object?> data) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'PieChart',
    buildChild: (id, [dataContext]) => const SizedBox.shrink(),
    dispatchEvent: (_) {},
    buildContext: context,
    dataContext: DataContext(_MockDataModel(), DataPath.root),
    getComponent: (_) => null,
    getCatalogItem: (_) => null,
    surfaceId: 'surface',
    reportError: (_, _) {},
  );
}

Future<void> _pump(
  WidgetTester tester,
  Map<String, Object?> data,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) =>
              pieChartItem.widgetBuilder(_context(context, data)),
        ),
      ),
    ),
  );
}

void main() {
  group(pieChartItem, () {
    test('has correct name and schema keys', () {
      expect(pieChartItem.name, 'PieChart');

      final schema = pieChartItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(props, containsAll(['items', 'totalLabel', 'totalAmount']));

      final required = schema.value['required']! as List;
      expect(required, containsAll(['items', 'totalLabel', 'totalAmount']));
    });

    group('renders', () {
      testWidgets('PieChartComponent widget', (tester) async {
        await _pump(tester, _data());

        expect(find.byType(PieChartComponent), findsOneWidget);
      });

      testWidgets('totalLabel in donut center', (tester) async {
        await _pump(tester, _data(totalLabel: 'Total Spending'));

        expect(find.text('Total Spending'), findsOneWidget);
      });

      testWidgets('totalAmount in donut center', (tester) async {
        await _pump(tester, _data(totalAmount: r'$2,820'));

        expect(find.text(r'$2,820'), findsOneWidget);
      });

      testWidgets('item labels in legend', (tester) async {
        await _pump(tester, _data());

        expect(find.text('Groceries'), findsOneWidget);
        expect(find.text('Transport'), findsOneWidget);
        expect(find.text('Dining'), findsOneWidget);
      });
    });
  });
}
