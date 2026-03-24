import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/widgets/accordion.dart';
import 'package:genui_life_goal_simulator/simulator/catalog/items/accordion_catalog_item.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataModel extends Mock implements DataModel {}

const _item = {
  'title': 'Restaurant',
  'subtitle': 'Dining • Feb 18',
  'amount': r'$450',
};

Map<String, Object?> _data({
  String title = 'Tips',
  List<Object?> items = const [_item],
  bool? isExpanded,
}) => {
  'title': title,
  'items': items,
  'isExpanded': ?isExpanded,
};

CatalogItemContext _context(BuildContext context, Map<String, Object?> data) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'AppAccordion',
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
              accordionItem.widgetBuilder(_context(context, data)),
        ),
      ),
    ),
  );
}

void main() {
  group(accordionItem, () {
    test('has correct name and schema keys', () {
      expect(accordionItem.name, 'AppAccordion');

      final schema = accordionItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(props, containsAll(['title', 'items', 'isExpanded']));

      final required = schema.value['required']! as List;
      expect(required, containsAll(['title', 'items']));
      expect(required, isNot(contains('isExpanded')));
    });

    testWidgets('renders title and items', (tester) async {
      await _pump(tester, _data(title: 'My Section'));

      expect(find.text('My Section'), findsOneWidget);
      expect(find.byType(AppAccordion), findsOneWidget);
    });

    testWidgets('defaults to collapsed when isExpanded is omitted', (
      tester,
    ) async {
      await _pump(tester, _data());
      await tester.pump();

      final accordion = tester.widget<AppAccordion>(find.byType(AppAccordion));
      expect(accordion.isExpanded, isFalse);
    });

    testWidgets('passes isExpanded true to widget', (tester) async {
      await _pump(tester, _data(isExpanded: true));
      await tester.pumpAndSettle();

      final accordion = tester.widget<AppAccordion>(find.byType(AppAccordion));
      expect(accordion.isExpanded, isTrue);
    });
  });
}
