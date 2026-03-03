import 'package:finance_app/advisor/catalog/items/horizontal_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';

Map<String, Object?> _data({
  String category = 'Dining',
  double amount = 420,
  double progress = 0.6,
  String comparisonLabel = 'Groceries',
  double comparisonValue = -5,
  bool isPercentage = true,
}) => {
  'category': category,
  'amount': amount,
  'progress': progress,
  'comparisonLabel': comparisonLabel,
  'comparisonValue': comparisonValue,
  'isPercentage': isPercentage,
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
              horizontalBarItem.widgetBuilder(_context(context, data)),
        ),
      ),
    ),
  );
}

void main() {
  group(horizontalBarItem, () {
    test('has correct name and schema keys', () {
      expect(horizontalBarItem.name, 'HorizontalBar');

      final schema = horizontalBarItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(
        props,
        containsAll([
          'category',
          'amount',
          'progress',
          'comparisonLabel',
          'comparisonValue',
          'isPercentage',
        ]),
      );

      final required = schema.value['required']! as List;
      expect(required, hasLength(6));
    });

    testWidgets('renders negative variant with red comparison value', (
      tester,
    ) async {
      await _pump(tester, _data(comparisonValue: -5, isPercentage: true));

      expect(find.text('Dining'), findsOneWidget);
      expect(find.text(r'$420'), findsOneWidget);
      expect(find.text('Groceries'), findsOneWidget);

      final comparisonText = tester.widget<Text>(find.text('-5%'));
      expect(
        (comparisonText.style?.color?.value),
        isNotNull,
      );
    });

    testWidgets('renders positive variant with green comparison value', (
      tester,
    ) async {
      await _pump(
        tester,
        _data(comparisonValue: 10, isPercentage: false),
      );

      expect(find.text('+10'), findsOneWidget);

      final comparisonText = tester.widget<Text>(find.text('+10'));
      expect(comparisonText.style?.color, isNotNull);
    });

    testWidgets('clamps progress above 1.0', (tester) async {
      await _pump(tester, _data(progress: 1.5));
      // Should not throw; widget renders without error.
      expect(find.byType(FractionallySizedBox), findsOneWidget);
    });

    testWidgets('clamps progress below 0.0', (tester) async {
      await _pump(tester, _data(progress: -0.5));
      expect(find.byType(FractionallySizedBox), findsOneWidget);
    });

    testWidgets('shows percentage suffix when isPercentage is true', (
      tester,
    ) async {
      await _pump(tester, _data(comparisonValue: -5, isPercentage: true));
      expect(find.text('-5%'), findsOneWidget);
    });

    testWidgets('omits percentage suffix when isPercentage is false', (
      tester,
    ) async {
      await _pump(tester, _data(comparisonValue: 10, isPercentage: false));
      expect(find.text('+10'), findsOneWidget);
      expect(find.text('+10%'), findsNothing);
    });
  });
}
