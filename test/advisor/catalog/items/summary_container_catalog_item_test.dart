import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv_genui_financial_advisor/advisor/catalog/items/summary_container_catalog_item.dart';

class _MockDataModel extends Mock implements DataModel {}

Map<String, Object?> _data({
  String child = 'child_1',
  String? bottomBar,
}) => {
  'child': child,
  'bottomBar': ?bottomBar,
};

CatalogItemContext _context(
  BuildContext context,
  Map<String, Object?> data, {
  Widget Function(String, [DataContext?])? buildChild,
}) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'SummaryContainer',
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
          builder: (context) => summaryContainerItem.widgetBuilder(
            _context(context, data, buildChild: buildChild),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group(summaryContainerItem, () {
    test('has correct name and schema keys', () {
      expect(summaryContainerItem.name, 'SummaryContainer');

      final schema = summaryContainerItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(props, containsAll(['child', 'bottomBar']));

      final required = schema.value['required']! as List;
      expect(required, containsAll(['child']));
      expect(required, isNot(contains('bottomBar')));
    });

    testWidgets('renders with 1000px max width constraint', (tester) async {
      await _pump(tester, _data());

      final finder = find.byWidgetPredicate(
        (widget) =>
            widget is ConstrainedBox && widget.constraints.maxWidth == 1000,
      );
      expect(finder, findsOneWidget);
    });

    testWidgets('child component is built', (tester) async {
      final childKey = UniqueKey();
      await _pump(
        tester,
        _data(child: 'my_child'),
        buildChild: (id, [dataContext]) {
          if (id == 'my_child') return SizedBox(key: childKey);
          return const SizedBox.shrink();
        },
      );

      expect(find.byKey(childKey), findsOneWidget);
    });

    testWidgets('bottomBar component is built when provided', (tester) async {
      final childKey = UniqueKey();
      final bottomBarKey = UniqueKey();
      await _pump(
        tester,
        _data(child: 'my_child', bottomBar: 'my_bar'),
        buildChild: (id, [dataContext]) {
          if (id == 'my_child') return SizedBox(key: childKey);
          if (id == 'my_bar') return SizedBox(key: bottomBarKey);
          return const SizedBox.shrink();
        },
      );

      expect(find.byKey(childKey), findsOneWidget);
      expect(find.byKey(bottomBarKey), findsOneWidget);
    });
  });
}
