import 'package:finance_app/advisor/catalog/items/accordion.dart';
import 'package:finance_app/app/presentation/widgets/accordion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';

Map<String, Object?> _data({
  String title = 'Tips',
  String body = 'Some helpful content.',
  bool? isExpanded,
}) => {
  'title': title,
  'body': body,
  'isExpanded': ?isExpanded,
};

CatalogItemContext _context(BuildContext context, Map<String, Object?> data) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    buildChild: (id, [dataContext]) => const SizedBox.shrink(),
    dispatchEvent: (_) {},
    buildContext: context,
    dataContext: DataContext(DataModel(), '/'),
    getComponent: (_) => null,
    surfaceId: 'surface',
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
      expect(props, containsAll(['title', 'body', 'isExpanded']));

      final required = schema.value['required']! as List;
      expect(required, containsAll(['title', 'body']));
      expect(required, isNot(contains('isExpanded')));
    });

    testWidgets('renders title and body text', (tester) async {
      await _pump(tester, _data(title: 'My Section', body: 'Detail text.'));

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
      expect(find.text('Some helpful content.'), findsOneWidget);
    });
  });
}
