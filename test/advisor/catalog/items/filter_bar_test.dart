import 'package:finance_app/advisor/catalog/items/filter_bar.dart';
import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';

Map<String, Object?> _data({
  List<Map<String, Object?>>? categories,
}) => {
  'categories': categories ?? [
    {'label': 'Food', 'color': 'orange', 'isSelected': true},
    {'label': 'Shopping', 'color': 'lightBlue', 'isSelected': false},
  ],
};

CatalogItemContext _context(BuildContext context, Map<String, Object?> data) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    buildChild: (id, [dataContext]) => const SizedBox.shrink(),
    dispatchEvent: (_) {},
    buildContext: context,
    dataContext: DataContext(DataModel(), '/'),
    getComponent: (_) => null,
    surfaceId: 'surface',
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
      final props =
          (schema.value['properties']! as Map<String, Object?>).keys.toList();
      expect(props, contains('categories'));

      final required = schema.value['required']! as List;
      expect(required, ['categories']);
    });

    testWidgets('renders category chips', (tester) async {
      await _pump(tester, _data());

      expect(find.text('Food'), findsOneWidget);
      expect(find.text('Shopping'), findsOneWidget);
      // "All" chip is always rendered
      expect(find.text('All'), findsOneWidget);
    });

    testWidgets('renders selection summary', (tester) async {
      await _pump(tester, _data());

      // 1 of 2 selected (Food is selected, Shopping is not)
      expect(find.text('1 of 2 categories selected'), findsOneWidget);
    });

    testWidgets('renders with empty categories', (tester) async {
      await _pump(tester, _data(categories: []));

      expect(find.text('All'), findsOneWidget);
      expect(find.text('0 of 0 categories selected'), findsOneWidget);
    });

    testWidgets('renders FilterBar widget', (tester) async {
      await _pump(tester, _data());

      expect(find.byType(FilterBar), findsOneWidget);
    });
  });
}
