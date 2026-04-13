import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/simulator/catalog/items/gcn_slider_catalog_item.dart';

Map<String, Object?> _data({
  String title = 'Budget',
  String subtitle = 'Dining • Feb 18',
  Object value = 450.0,
  double min = 0,
  double max = 1000,
  String? formatter,
  String? minLabel,
  String? maxLabel,
  int? divisions,
  List<String>? splitLabels,
}) => {
  'title': title,
  'subtitle': subtitle,
  'value': value,
  'min': min,
  'max': max,
  'formatter': formatter,
  'minLabel': minLabel,
  'maxLabel': maxLabel,
  'divisions': divisions,
  'splitLabels': splitLabels,
};

CatalogItemContext _context(
  BuildContext context,
  Map<String, Object?> data, {
  DataModel? dataModel,
  void Function(UiEvent)? dispatchEvent,
}) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'GCNSlider',
    buildChild: (id, [dataContext]) => const SizedBox.shrink(),
    dispatchEvent: dispatchEvent ?? (_) {},
    buildContext: context,
    dataContext: DataContext(dataModel ?? InMemoryDataModel(), DataPath.root),
    getComponent: (_) => null,
    getCatalogItem: (_) => null,
    surfaceId: 'surface',
    reportError: (_, _) {},
  );
}

Future<void> _pump(
  WidgetTester tester,
  Map<String, Object?> data, {
  DataModel? dataModel,
  void Function(UiEvent)? dispatchEvent,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: Scaffold(
        body: Builder(
          builder: (context) => gcnSliderItem.widgetBuilder(
            _context(
              context,
              data,
              dataModel: dataModel,
              dispatchEvent: dispatchEvent,
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group(gcnSliderItem, () {
    test('has correct name and schema keys', () {
      expect(gcnSliderItem.name, 'GCNSlider');

      final schema = gcnSliderItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(
        props,
        containsAll(<String>[
          'title',
          'subtitle',
          'value',
          'min',
          'max',
          'formatter',
          'minLabel',
          'maxLabel',
          'divisions',
          'splitLabels',
        ]),
      );

      final required = schema.value['required']! as List;
      expect(
        required,
        containsAll(['title', 'subtitle', 'value', 'min', 'max']),
      );
    });

    group('renders', () {
      testWidgets('GCNSlider widget with title and subtitle', (tester) async {
        await _pump(tester, _data());

        expect(find.byType(GCNSlider), findsOneWidget);
        expect(find.text('Budget'), findsOneWidget);
        expect(find.text('Dining • Feb 18'), findsOneWidget);
      });

      testWidgets('formats value as usd', (tester) async {
        await _pump(
          tester,
          _data(formatter: 'usd', value: 72000.0, max: 100000),
        );

        expect(find.text(r'$72,000'), findsOneWidget);
      });

      testWidgets('formats value as percentage', (tester) async {
        await _pump(
          tester,
          _data(formatter: 'percentage', value: 10.1, max: 100),
        );

        expect(find.text('10.1%'), findsOneWidget);
      });

      testWidgets('formats whole percentage without decimal', (tester) async {
        await _pump(
          tester,
          _data(formatter: 'percentage', value: 50.0, max: 100),
        );

        expect(find.text('50%'), findsOneWidget);
      });

      testWidgets('formats value as integer', (tester) async {
        await _pump(
          tester,
          _data(formatter: 'integer', value: 42.0),
        );

        expect(find.text('42'), findsOneWidget);
      });

      testWidgets('hides value label when formatter is omitted', (
        tester,
      ) async {
        await _pump(tester, _data());

        final slider = tester.widget<GCNSlider>(find.byType(GCNSlider));
        expect(slider.valueLabel, isNull);
      });

      testWidgets('with min and max labels', (tester) async {
        await _pump(
          tester,
          _data(minLabel: r'$0', maxLabel: r'$1000'),
        );

        expect(find.text(r'$0'), findsOneWidget);
        expect(find.text(r'$1000'), findsOneWidget);
      });

      testWidgets('splits variant with divisions', (tester) async {
        await _pump(
          tester,
          _data(
            divisions: 3,
            splitLabels: ['Low', 'Med', 'High', 'Max'],
          ),
        );

        expect(find.text('Low'), findsWidgets);
        expect(find.text('Med'), findsWidgets);
        expect(find.text('High'), findsWidgets);
        expect(find.text('Max'), findsWidgets);
      });

      testWidgets('updates bound data model value on drag', (tester) async {
        final dataModel = InMemoryDataModel();
        await _pump(
          tester,
          _data(value: 0, max: 100),
          dataModel: dataModel,
        );

        await tester.drag(find.byType(Slider), const Offset(100, 0));
        await tester.pump();

        final stored = dataModel.getValue<num>(DataPath('/test/value'));
        expect(stored, isNotNull);
        expect(stored! > 0, isTrue);
      });

      testWidgets('reads initial value from explicit path binding', (
        tester,
      ) async {
        final dataModel = InMemoryDataModel()
          ..update(DataPath('/shared/budget'), 250.0);

        await _pump(
          tester,
          _data(
            value: {'path': '/shared/budget'},
          ),
          dataModel: dataModel,
        );

        final sliderWidget = tester.widget<GCNSlider>(find.byType(GCNSlider));
        expect(sliderWidget.value, 250.0);
      });
    });
  });
}
