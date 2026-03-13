import 'package:finance_app/advisor/catalog/items/metric_cards_catalog_item.dart';
import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataModel extends Mock implements DataModel {}

Map<String, Object?> _data({
  List<Map<String, Object?>>? cards,
}) => {
  'cards':
      cards ??
      [
        {
          'label': 'Total Spending',
          'value': r'$4,319',
          'delta': '+1.2%',
          'deltaDirection': 'negative',
          'subtitle': 'vs last month',
        },
        {
          'label': 'Savings',
          'value': r'$1,200',
          'delta': '+5%',
          'deltaDirection': 'positive',
        },
      ],
};

CatalogItemContext _context(BuildContext context, Map<String, Object?> data) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'MetricCard',
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
              metricCardsItem.widgetBuilder(_context(context, data)),
        ),
      ),
    ),
  );
}

void main() {
  group(metricCardsItem, () {
    test('has correct name and schema keys', () {
      expect(metricCardsItem.name, 'MetricCard');

      final schema = metricCardsItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(props, contains('cards'));

      final required = schema.value['required']! as List;
      expect(required, contains('cards'));
    });

    group('renders', () {
      testWidgets('metric card labels and values', (tester) async {
        await _pump(tester, _data());

        expect(find.text('Total Spending'), findsOneWidget);
        expect(find.text(r'$4,319'), findsOneWidget);
        expect(find.text('Savings'), findsOneWidget);
        expect(find.text(r'$1,200'), findsOneWidget);
      });

      testWidgets('delta and subtitle', (tester) async {
        await _pump(tester, _data());

        expect(find.text('+1.2%'), findsOneWidget);
        expect(find.text('vs last month'), findsOneWidget);
      });

      testWidgets('MetricCardsLayout', (tester) async {
        await _pump(tester, _data());

        expect(find.byType(MetricCardsLayout), findsOneWidget);
      });

      testWidgets('plain card without delta', (tester) async {
        await _pump(
          tester,
          _data(
            cards: [
              {'label': 'Net Worth', 'value': r'$50,000'},
            ],
          ),
        );

        expect(find.text('Net Worth'), findsOneWidget);
        expect(find.text(r'$50,000'), findsOneWidget);
      });
    });
  });
}
