import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv_genui_financial_advisor/advisor/catalog/items/category_filter_chip.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

class _MockDataModel extends Mock implements DataModel {}

Map<String, Object?> _data({
  String label = 'Dining',
  String color = 'aqua',
  bool? isSelected,
  bool? isEnabled,
}) => {
  'label': label,
  'color': color,
  'isSelected': ?isSelected,
  'isEnabled': ?isEnabled,
};

CatalogItemContext _context(BuildContext context, Map<String, Object?> data) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'CategoryFilterChip',
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
              categoryFilterChipItem.widgetBuilder(_context(context, data)),
        ),
      ),
    ),
  );
}

void main() {
  group(categoryFilterChipItem, () {
    test('has correct name and schema keys', () {
      expect(categoryFilterChipItem.name, 'CategoryFilterChip');

      final schema = categoryFilterChipItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(props, containsAll(['label', 'color', 'isSelected', 'isEnabled']));

      final required = schema.value['required']! as List;
      expect(required, containsAll(['label', 'color']));
      expect(required, isNot(contains('isSelected')));
    });

    test('schema color enum contains all FilterChipColor values', () {
      final schema = categoryFilterChipItem.dataSchema;
      final props = schema.value['properties']! as Map<String, Object?>;
      final colorSchema = props['color']! as Map<String, Object?>;
      final enumValues = colorSchema['enum']! as List;
      expect(
        enumValues,
        containsAll(FilterChipColor.values.map((e) => e.name)),
      );
    });

    testWidgets('renders CategoryFilterChip with label', (tester) async {
      await _pump(tester, _data());

      expect(find.byType(CategoryFilterChip), findsOneWidget);
      expect(find.text('Dining'), findsOneWidget);
    });

    testWidgets('renders with isSelected true', (tester) async {
      await _pump(tester, _data(isSelected: true));

      expect(find.byType(CategoryFilterChip), findsOneWidget);
    });

    testWidgets('defaults isSelected to false when omitted', (tester) async {
      await _pump(tester, _data());

      final chip = tester.widget<CategoryFilterChip>(
        find.byType(CategoryFilterChip),
      );
      expect(chip.isSelected, false);
    });

    testWidgets('defaults isEnabled to true when omitted', (tester) async {
      await _pump(tester, _data());

      final chip = tester.widget<CategoryFilterChip>(
        find.byType(CategoryFilterChip),
      );
      expect(chip.isEnabled, true);
    });

    testWidgets('passes isEnabled false to chip', (tester) async {
      await _pump(tester, _data(isEnabled: false));

      final chip = tester.widget<CategoryFilterChip>(
        find.byType(CategoryFilterChip),
      );
      expect(chip.isEnabled, false);
    });

    testWidgets('falls back to aqua for unknown color', (tester) async {
      await _pump(tester, _data(color: 'unknown'));

      expect(find.byType(CategoryFilterChip), findsOneWidget);
      final chip = tester.widget<CategoryFilterChip>(
        find.byType(CategoryFilterChip),
      );
      expect(chip.color, FilterChipColor.aqua);
    });
  });
}
