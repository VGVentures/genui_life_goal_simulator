import 'package:finance_app/advisor/catalog/items/action_item_catalog_item.dart';
import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataModel extends Mock implements DataModel {}

Map<String, Object?> _action({String name = 'itemAction'}) => {
  'event': <String, Object?>{'name': name},
};

Map<String, Object?> _item({
  String title = 'Restaurant',
  String subtitle = 'Dining • Feb 18',
  String amount = r'$450',
  String? delta,
  String? buttonLabel,
  String? buttonVariant,
  Map<String, Object?>? action,
}) => {
  'title': title,
  'subtitle': subtitle,
  'amount': amount,
  'delta': ?delta,
  'buttonLabel': ?buttonLabel,
  'buttonVariant': ?buttonVariant,
  'action': ?action,
};

Map<String, Object?> _data({List<Map<String, Object?>>? items}) => {
  'items': items ?? [_item()],
};

CatalogItemContext _context(BuildContext context, Map<String, Object?> data) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'ActionItemsGroup',
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
        body: SingleChildScrollView(
          child: Builder(
            builder: (context) =>
                actionItemsGroupItem.widgetBuilder(_context(context, data)),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group(actionItemsGroupItem, () {
    test('has correct name and schema keys', () {
      expect(actionItemsGroupItem.name, 'ActionItemsGroup');

      final schema = actionItemsGroupItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(props, containsAll(['items']));

      final required = schema.value['required']! as List;
      expect(required, contains('items'));
    });

    testWidgets('renders ActionItemsGroup with valid data', (tester) async {
      await _pump(tester, _data());

      expect(find.byType(ActionItemsGroup), findsOneWidget);
      expect(find.byType(ActionItem), findsOneWidget);
      expect(find.text('Restaurant'), findsOneWidget);
      expect(find.text('Dining • Feb 18'), findsOneWidget);
      expect(find.text(r'$450'), findsOneWidget);
    });

    testWidgets('renders multiple items', (tester) async {
      await _pump(
        tester,
        _data(
          items: [
            _item(
              title: 'Groceries',
              subtitle: 'Food • Feb 20',
              amount: r'$120',
            ),
            _item(title: 'Rent', subtitle: 'Housing • Feb 1', amount: r'$1500'),
          ],
        ),
      );

      expect(find.byType(ActionItem), findsNWidgets(2));
      expect(find.text('Groceries'), findsOneWidget);
      expect(find.text('Rent'), findsOneWidget);
    });

    testWidgets('renders delta when provided', (tester) async {
      await _pump(tester, _data(items: [_item(delta: '+28%')]));

      expect(find.text('+28%'), findsOneWidget);
    });

    testWidgets('omits delta when not provided', (tester) async {
      await _pump(tester, _data());

      expect(find.text('+28%'), findsNothing);
    });

    testWidgets('renders primary button when buttonVariant is primary', (
      tester,
    ) async {
      await _pump(
        tester,
        _data(
          items: [
            _item(
              buttonVariant: 'primary',
              buttonLabel: 'Pay now',
              action: _action(),
            ),
          ],
        ),
      );

      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.text('Pay now'), findsOneWidget);
    });

    testWidgets('renders outlined button when buttonVariant is secondary', (
      tester,
    ) async {
      await _pump(
        tester,
        _data(
          items: [
            _item(
              buttonVariant: 'secondary',
              buttonLabel: 'Details',
              action: _action(),
            ),
          ],
        ),
      );

      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('defaults to no button when buttonVariant is omitted', (
      tester,
    ) async {
      await _pump(tester, _data());

      expect(find.byType(FilledButton), findsNothing);
      expect(find.byType(OutlinedButton), findsNothing);
    });

    testWidgets('defaults to no button for unknown buttonVariant', (
      tester,
    ) async {
      await _pump(
        tester,
        _data(
          items: [_item(buttonVariant: 'unknown', buttonLabel: 'Tap')],
        ),
      );

      expect(find.byType(FilledButton), findsNothing);
      expect(find.byType(OutlinedButton), findsNothing);
    });
  });
}
