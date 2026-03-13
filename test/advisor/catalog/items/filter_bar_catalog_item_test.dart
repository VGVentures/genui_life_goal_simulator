import 'package:finance_app/advisor/catalog/items/filter_bar_catalog_item.dart';
import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataModel extends Mock implements DataModel {}

Map<String, Object?> _data({
  List<Map<String, Object?>>? categories,
}) => {
  'categories':
      categories ??
      [
        {'label': 'Food', 'color': 'orange', 'isSelected': true},
        {'label': 'Shopping', 'color': 'lightBlue', 'isSelected': false},
      ],
};

CatalogItemContext _context(BuildContext context, Map<String, Object?> data) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'FilterBar',
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
      theme: AppTheme(LightThemeColors()).themeData,
      home: Scaffold(
        body: Builder(
          builder: (context) =>
              filterBarItem.widgetBuilder(_context(context, data)),
        ),
      ),
    ),
  );
}

void main() {
  group(filterBarItem, () {
    test('has correct name and schema keys', () {
      expect(filterBarItem.name, 'FilterBar');

      final schema = filterBarItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(props, contains('categories'));

      final required = schema.value['required']! as List;
      expect(required, contains('categories'));
    });

    group('renders', () {
      testWidgets('category chips', (tester) async {
        await _pump(tester, _data());

        expect(find.text('Food'), findsOneWidget);
        expect(find.text('Shopping'), findsOneWidget);
        // "All" chip is always rendered
        expect(find.text('All'), findsOneWidget);
      });

      testWidgets('selection summary', (tester) async {
        await _pump(tester, _data());

        // 1 of 2 selected (Food is selected, Shopping is not)
        expect(find.text('1 of 2 categories selected'), findsOneWidget);
      });

      testWidgets('with empty categories', (tester) async {
        await _pump(tester, _data(categories: []));

        expect(find.text('All'), findsOneWidget);
        expect(find.text('0 of 0 categories selected'), findsOneWidget);
      });

      testWidgets('FilterBar widget', (tester) async {
        await _pump(tester, _data());

        expect(find.byType(FilterBar), findsOneWidget);
      });
    });
  });
}
