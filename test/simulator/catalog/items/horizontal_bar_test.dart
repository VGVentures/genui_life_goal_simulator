import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/widgets/horizontal_bar.dart';
import 'package:genui_life_goal_simulator/simulator/catalog/items/horizontal_bar_catalog_item.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataModel extends Mock implements DataModel {}

List<Map<String, Object?>> _items({int count = 2}) => [
  for (int i = 0; i < count; i++)
    {
      'category': 'Category $i',
      'amount': r'$420',
      'progress': 0.5 + i * 0.1,
      'comparisonLabel': 'vs last month',
      'comparisonValue': i.isEven ? '-5%' : '+3%',
    },
];

Map<String, Object?> _data({int count = 2}) => {'items': _items(count: count)};

CatalogItemContext _context(BuildContext context, Map<String, Object?> data) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'HorizontalBar',
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
        body: SingleChildScrollView(
          child: Builder(
            builder: (context) =>
                horizontalBarItem.widgetBuilder(_context(context, data)),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group(horizontalBarItem, () {
    test('has correct name and schema keys', () {
      expect(horizontalBarItem.name, 'HorizontalBar');

      final schema = horizontalBarItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(props, containsAll(['items']));

      final required = schema.value['required']! as List;
      expect(required, contains('items'));
    });

    group('renders', () {
      testWidgets('one HorizontalBar per item', (tester) async {
        await _pump(tester, _data(count: 3));

        expect(find.byType(HorizontalBar), findsNWidgets(3));
        expect(find.text('Category 0'), findsOneWidget);
        expect(find.text('Category 1'), findsOneWidget);
        expect(find.text('Category 2'), findsOneWidget);
      });

      testWidgets('single item without error', (tester) async {
        await _pump(tester, _data(count: 1));

        expect(find.byType(HorizontalBar), findsOneWidget);
      });

      testWidgets('many items without error', (tester) async {
        await _pump(tester, _data(count: 10));

        expect(find.byType(HorizontalBar), findsNWidgets(10));
      });
    });
  });
}
