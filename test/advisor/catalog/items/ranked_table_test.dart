import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv_genui_financial_advisor/advisor/catalog/items/ranked_table.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

class _MockDataModel extends Mock implements DataModel {}

Map<String, Object?> _data() => {
  'items': <Map<String, Object?>>[
    {'title': 'The French Laundry', 'amount': r'$350', 'delta': '+15%'},
    {'title': 'Whole Foods', 'amount': r'$280', 'delta': '-5%'},
  ],
};

CatalogItemContext _context(
  BuildContext context,
  Map<String, Object?> data,
) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'RankedTable',
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
                rankedTableItem.widgetBuilder(_context(context, data)),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group(rankedTableItem, () {
    test('has correct name and schema keys', () {
      expect(rankedTableItem.name, 'RankedTable');

      final schema = rankedTableItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys;
      expect(props, contains('items'));
    });

    testWidgets('renders $RankedTable with provided items', (tester) async {
      await _pump(tester, _data());

      expect(find.byType(RankedTable), findsOneWidget);
      expect(find.text('The French Laundry'), findsOneWidget);
      expect(find.text(r'$350'), findsOneWidget);
      expect(find.text('+15%'), findsOneWidget);
      expect(find.text('Whole Foods'), findsOneWidget);
      expect(find.text(r'$280'), findsOneWidget);
      expect(find.text('-5%'), findsOneWidget);
    });
  });
}
