import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/simulator/catalog/items/question_container_catalog_item.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataModel extends Mock implements DataModel {}

Map<String, Object?> _data({String child = 'child_1'}) => {'child': child};

CatalogItemContext _context(
  BuildContext context,
  Map<String, Object?> data, {
  Widget Function(String, [DataContext?])? buildChild,
}) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'QuestionContainer',
    buildChild: buildChild ?? (id, [dataContext]) => const SizedBox.shrink(),
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
  Map<String, Object?> data, {
  Widget Function(String, [DataContext?])? buildChild,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => questionContainerItem.widgetBuilder(
            _context(context, data, buildChild: buildChild),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group(questionContainerItem, () {
    test('has correct name and schema keys', () {
      expect(questionContainerItem.name, 'QuestionContainer');

      final schema = questionContainerItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(props, containsAll(['child']));

      final required = schema.value['required']! as List;
      expect(required, containsAll(['child']));
    });

    testWidgets('renders with 650px max width constraint', (tester) async {
      await _pump(tester, _data());

      final finder = find.byWidgetPredicate(
        (widget) =>
            widget is ConstrainedBox && widget.constraints.maxWidth == 650,
      );
      expect(finder, findsOneWidget);
    });

    testWidgets('child component is built', (tester) async {
      final childKey = UniqueKey();
      await _pump(
        tester,
        _data(child: 'my_child'),
        buildChild: (id, [dataContext]) => SizedBox(key: childKey),
      );

      expect(find.byKey(childKey), findsOneWidget);
    });
  });
}
