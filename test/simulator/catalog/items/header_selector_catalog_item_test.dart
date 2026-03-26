import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/simulator/catalog/items/header_selector_catalog_item.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataModel extends Mock implements DataModel {}

Map<String, Object?> _data({
  List<String> options = const ['1M', '3M', '6M'],
  int selectedIndex = 0,
}) => {'options': options, 'selectedIndex': selectedIndex};

CatalogItemContext _context(BuildContext context, Map<String, Object?> data) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'HeaderSelector',
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
              headerSelectorItem.widgetBuilder(_context(context, data)),
        ),
      ),
    ),
  );
}

void main() {
  group(headerSelectorItem, () {
    test('has correct name and schema keys', () {
      expect(headerSelectorItem.name, 'HeaderSelector');

      final schema = headerSelectorItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(props, containsAll(['options', 'selectedIndex']));

      final required = schema.value['required']! as List;
      expect(required, containsAll(['options', 'selectedIndex']));
    });

    testWidgets('renders HeaderSelector with options', (tester) async {
      await _pump(tester, _data());

      expect(find.byType(HeaderSelector), findsOneWidget);
      expect(find.text('1M'), findsOneWidget);
      expect(find.text('3M'), findsOneWidget);
      expect(find.text('6M'), findsOneWidget);
    });

    testWidgets('passes correct selectedIndex', (tester) async {
      await _pump(tester, _data(selectedIndex: 1));

      final widget = tester.widget<HeaderSelector>(
        find.byType(HeaderSelector),
      );
      expect(widget.selectedIndex, 1);
    });

    testWidgets('renders all provided options', (tester) async {
      await _pump(
        tester,
        _data(options: ['Week', 'Month', 'Year'], selectedIndex: 2),
      );

      expect(find.text('Week'), findsOneWidget);
      expect(find.text('Month'), findsOneWidget);
      expect(find.text('Year'), findsOneWidget);
    });
  });
}
