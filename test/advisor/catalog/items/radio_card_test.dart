import 'package:finance_app/advisor/catalog/items/radio_card.dart';
import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';

Map<String, Object?> _data({
  List<Map<String, Object?>>? options,
}) => {
  'options': options ?? [
    {'label': 'Beginner', 'isSelected': true},
    {'label': 'Optimizer', 'isSelected': false},
  ],
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
      theme: AppTheme(LightThemeColors()).themeData,
      home: Scaffold(
        body: Builder(
          builder: (context) =>
              radioCardItem.widgetBuilder(_context(context, data)),
        ),
      ),
    ),
  );
}

void main() {
  group(radioCardItem, () {
    test('has correct name and schema keys', () {
      expect(radioCardItem.name, 'RadioCard');

      final schema = radioCardItem.dataSchema;
      final props =
          (schema.value['properties']! as Map<String, Object?>).keys.toList();
      expect(props, contains('options'));

      final required = schema.value['required']! as List;
      expect(required, ['options']);
    });

    testWidgets('renders radio card labels', (tester) async {
      await _pump(tester, _data());

      expect(find.text('Beginner'), findsOneWidget);
      expect(find.text('Optimizer'), findsOneWidget);
    });

    testWidgets('renders RadioCard widgets', (tester) async {
      await _pump(tester, _data());

      expect(find.byType(RadioCard), findsNWidgets(2));
    });

    testWidgets('renders single option', (tester) async {
      await _pump(
        tester,
        _data(options: [
          {'label': 'Solo', 'isSelected': true},
        ]),
      );

      expect(find.text('Solo'), findsOneWidget);
      expect(find.byType(RadioCard), findsOneWidget);
    });
  });
}
