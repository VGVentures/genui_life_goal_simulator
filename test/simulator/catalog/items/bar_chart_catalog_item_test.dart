import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/simulator/catalog/items/bar_chart_catalog_item.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataModel extends Mock implements DataModel {}

Map<String, Object?> _data({
  List<Map<String, Object?>>? series,
  List<String>? yAxisLabels,
}) => {
  'series':
      series ??
      [
        {
          'label': 'Reference 1',
          'color': 'lightBlue',
          'points': [
            {
              'xLabel': 'Jan',
              'value': 1000,
              'tooltipLabel': 'Jan',
              'tooltipValue': r'Spend: $1,000',
            },
            {
              'xLabel': 'Feb',
              'value': 1500,
              'tooltipLabel': 'Feb',
              'tooltipValue': r'Spend: $1,500',
            },
          ],
        },
        {
          'label': 'Reference 2',
          'color': 'pink',
          'points': [
            {
              'xLabel': 'Jan',
              'value': 800,
              'tooltipLabel': 'Jan',
              'tooltipValue': r'Spend: $800',
            },
            {
              'xLabel': 'Feb',
              'value': 1200,
              'tooltipLabel': 'Feb',
              'tooltipValue': r'Spend: $1,200',
            },
          ],
        },
      ],
  'yAxisLabels': yAxisLabels ?? [r'$0k', r'$1k', r'$2k'],
};

CatalogItemContext _context(BuildContext context, Map<String, Object?> data) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'BarChart',
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
              barChartItem.widgetBuilder(_context(context, data)),
        ),
      ),
    ),
  );
}

void main() {
  group(barChartItem, () {
    test('has correct name and schema keys', () {
      expect(barChartItem.name, 'BarChart');

      final schema = barChartItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(props, containsAll(['series', 'yAxisLabels']));

      final required = schema.value['required']! as List;
      expect(required, containsAll(['series', 'yAxisLabels']));
    });

    group('renders', () {
      testWidgets('BarChart widget', (tester) async {
        await _pump(tester, _data());

        expect(find.byType(AppBarChart), findsOneWidget);
      });

      testWidgets('legend labels', (tester) async {
        await _pump(tester, _data());

        expect(find.text('Reference 1'), findsOneWidget);
        expect(find.text('Reference 2'), findsOneWidget);
      });

      testWidgets('x-axis labels', (tester) async {
        await _pump(tester, _data());

        expect(find.text('Jan'), findsOneWidget);
        expect(find.text('Feb'), findsOneWidget);
      });

      testWidgets('chart in a SizedBox with correct height', (tester) async {
        await _pump(tester, _data());

        final sizedBox = tester.widget<SizedBox>(
          find.ancestor(
            of: find.byType(AppBarChart),
            matching: find.byType(SizedBox),
          ),
        );
        expect(sizedBox.height, 291);
      });
    });

    group('color resolver', () {
      for (final color in [
        'pink',
        'mustard',
        'orange',
        'brightOrange',
        'deepRed',
        'plum',
        'aqua',
        'lightBlue',
        'lightOlive',
        'darkOlive',
        'emerald',
      ]) {
        testWidgets('renders with color $color', (tester) async {
          await _pump(
            tester,
            _data(
              series: [
                {
                  'label': 'Series',
                  'color': color,
                  'points': [
                    {
                      'xLabel': 'Jan',
                      'value': 1000,
                      'tooltipLabel': 'Jan',
                      'tooltipValue': r'Spend: $1,000',
                    },
                  ],
                },
              ],
            ),
          );

          expect(find.byType(AppBarChart), findsOneWidget);
        });
      }

      testWidgets('falls back to pink for unknown color', (tester) async {
        await _pump(
          tester,
          _data(
            series: [
              {
                'label': 'Series',
                'color': 'unknown',
                'points': [
                  {
                    'xLabel': 'Jan',
                    'value': 1000,
                    'tooltipLabel': 'Jan',
                    'tooltipValue': r'Spend: $1,000',
                  },
                ],
              },
            ],
          ),
        );

        expect(find.byType(AppBarChart), findsOneWidget);
      });
    });
  });
}
