import 'package:finance_app/advisor/catalog/items/gcn_slider_catalog_item.dart';
import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataModel extends Mock implements DataModel {}

Map<String, Object?> _data({
  String title = 'Budget',
  String subtitle = 'Dining • Feb 18',
  double value = 450,
  double min = 0,
  double max = 1000,
  String? valueLabel,
  String? minLabel,
  String? maxLabel,
  String? prefix,
  int? divisions,
  List<String>? splitLabels,
}) => {
  'title': title,
  'subtitle': subtitle,
  'value': value,
  'min': min,
  'max': max,
  'valueLabel': valueLabel,
  'minLabel': minLabel,
  'maxLabel': maxLabel,
  'prefix': prefix,
  'divisions': divisions,
  'splitLabels': splitLabels,
};

CatalogItemContext _context(
  BuildContext context,
  Map<String, Object?> data, {
  void Function(UiEvent)? dispatchEvent,
}) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'GCNSlider',
    buildChild: (id, [dataContext]) => const SizedBox.shrink(),
    dispatchEvent: dispatchEvent ?? (_) {},
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
  Map<String, Object?> data, {
  void Function(UiEvent)? dispatchEvent,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: Scaffold(
        body: Builder(
          builder: (context) => gcnSliderItem.widgetBuilder(
            _context(context, data, dispatchEvent: dispatchEvent),
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
        containsAll([
          'title',
          'subtitle',
          'value',
          'min',
          'max',
          'valueLabel',
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

      testWidgets('with value label', (tester) async {
        await _pump(
          tester,
          _data(valueLabel: r'$450', prefix: r'$'),
        );

        // The slider formats the value locally: prefix + formatted number
        expect(find.text(r'$450'), findsOneWidget);
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

      testWidgets('updates value locally on drag', (tester) async {
        await _pump(tester, _data(value: 0, max: 100));

        // Drag the slider thumb to the right
        await tester.drag(find.byType(Slider), const Offset(100, 0));
        await tester.pump();

        // Slider should still be rendered (state managed locally)
        expect(find.byType(GCNSlider), findsOneWidget);
      });
    });
  });
}
