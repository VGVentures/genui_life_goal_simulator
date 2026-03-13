import 'package:finance_app/advisor/catalog/items/comparison_table_catalog_item.dart';
import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataModel extends Mock implements DataModel {}

Map<String, Object?> _data({
  List<Map<String, Object?>>? items,
}) => {
  'items':
      items ??
      [
        {
          'label': 'Groceries',
          'lastMonthAmount': 500,
          'actualMonthAmount': 550,
        },
        {
          'label': 'Dining',
          'lastMonthAmount': 300,
          'actualMonthAmount': 250,
        },
      ],
};

CatalogItemContext _context(BuildContext context, Map<String, Object?> data) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'ComparisonTable',
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
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme(LightThemeColors()).themeData,
      home: Scaffold(
        body: Builder(
          builder: (context) =>
              comparisonTableItem.widgetBuilder(_context(context, data)),
        ),
      ),
    ),
  );
}

void main() {
  group(comparisonTableItem, () {
    test('has correct name and schema keys', () {
      expect(comparisonTableItem.name, 'ComparisonTable');

      final schema = comparisonTableItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(props, contains('items'));

      final required = schema.value['required']! as List;
      expect(required, contains('items'));
    });

    group('renders', () {
      testWidgets('ComparisonTable widget', (tester) async {
        await _pump(tester, _data());

        expect(find.byType(ComparisonTable), findsOneWidget);
      });

      testWidgets('category labels', (tester) async {
        await _pump(tester, _data());

        expect(find.text('Groceries'), findsOneWidget);
        expect(find.text('Dining'), findsOneWidget);
      });

      testWidgets('single item', (tester) async {
        await _pump(
          tester,
          _data(
            items: [
              {
                'label': 'Rent',
                'lastMonthAmount': 1200,
                'actualMonthAmount': 1200,
              },
            ],
          ),
        );

        expect(find.text('Rent'), findsOneWidget);
      });
    });
  });
}
