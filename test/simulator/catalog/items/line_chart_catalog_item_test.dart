import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/simulator/catalog/items/line_chart_catalog_item.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataModel extends Mock implements DataModel {}

Map<String, Object?> _data({
  List<Map<String, Object?>>? points,
  List<String>? yAxisLabels,
}) => {
  'points':
      points ??
      [
        {
          'xLabel': 'Jan',
          'value': 1000,
          'tooltipLabel': 'January',
          'tooltipValue': r'Spend: $1,000',
        },
        {
          'xLabel': 'Feb',
          'value': 1500,
          'tooltipLabel': 'February',
          'tooltipValue': r'Spend: $1,500',
        },
        {
          'xLabel': 'Mar',
          'value': 1200,
          'tooltipLabel': 'March',
          'tooltipValue': r'Spend: $1,200',
        },
      ],
  'yAxisLabels': yAxisLabels ?? [r'$0k', r'$1k', r'$2k'],
};

CatalogItemContext _context(BuildContext context, Map<String, Object?> data) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'LineChart',
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
              lineChartItem.widgetBuilder(_context(context, data)),
        ),
      ),
    ),
  );
}

void main() {
  group(lineChartItem, () {
    test('has correct name and schema keys', () {
      expect(lineChartItem.name, 'LineChart');

      final schema = lineChartItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(props, containsAll(['points', 'yAxisLabels']));

      final required = schema.value['required']! as List;
      expect(required, containsAll(['points', 'yAxisLabels']));
    });

    group('renders', () {
      testWidgets('LineChart widget', (tester) async {
        await _pump(tester, _data());

        expect(find.byType(LineChart), findsOneWidget);
      });

      testWidgets('x-axis labels', (tester) async {
        await _pump(tester, _data());

        expect(find.text('Jan'), findsOneWidget);
        expect(find.text('Feb'), findsOneWidget);
        expect(find.text('Mar'), findsOneWidget);
      });

      testWidgets('chart in a SizedBox for height', (tester) async {
        await _pump(tester, _data());

        final sizedBox = tester.widget<SizedBox>(
          find.ancestor(
            of: find.byType(LineChart),
            matching: find.byType(SizedBox),
          ),
        );
        expect(sizedBox.height, 300);
      });
    });
  });
}
