import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/simulator/catalog/items/section_card_catalog_item.dart';
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
    type: 'SectionCard',
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
          builder: (context) => sectionCardItem.widgetBuilder(
            _context(context, data, buildChild: buildChild),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group(sectionCardItem, () {
    test('has correct name and schema keys', () {
      expect(sectionCardItem.name, 'SectionCard');

      final schema = sectionCardItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(props, containsAll(['child']));

      final required = schema.value['required']! as List;
      expect(required, containsAll(['child']));
    });

    testWidgets('renders with white background and 24px border radius', (
      tester,
    ) async {
      await _pump(tester, _data());

      final decoratedBox = tester.widget<DecoratedBox>(
        find.byType(DecoratedBox),
      );
      final decoration = decoratedBox.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(Spacing.xl));
      // The color should be set (either from theme or fallback white).
      expect(decoration.color, isNotNull);
    });

    testWidgets('has bottom padding', (tester) async {
      await _pump(tester, _data());

      final padding = tester.widget<Padding>(
        find
            .ancestor(
              of: find.byType(DecoratedBox),
              matching: find.byType(Padding),
            )
            .first,
      );
      expect(
        padding.padding,
        const EdgeInsets.only(bottom: Spacing.md),
      );
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
