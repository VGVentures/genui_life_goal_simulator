import 'package:finance_app/advisor/catalog/items/user_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataModel extends Mock implements DataModel {}

Map<String, Object?> _data({
  String name = 'Alice',
  String healthScore = 'Good',
  double totalAssets = 50000,
  double totalDebt = 10000,
  double netWorth = 40000,
  double monthlyIncome = 5000,
  double monthlyExpenses = 3000,
  String recommendation = 'Save more.',
}) => {
  'name': name,
  'financialHealthScore': healthScore,
  'totalAssets': totalAssets,
  'totalDebt': totalDebt,
  'netWorth': netWorth,
  'monthlyIncome': monthlyIncome,
  'monthlyExpenses': monthlyExpenses,
  'recommendation': recommendation,
};

CatalogItemContext _context(BuildContext context, Map<String, Object?> data) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'UserSummaryCard',
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
                userSummaryCardItem.widgetBuilder(_context(context, data)),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group(userSummaryCardItem, () {
    test('has correct name and schema keys', () {
      expect(userSummaryCardItem.name, 'UserSummaryCard');

      final schema = userSummaryCardItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(
        props,
        containsAll([
          'name',
          'financialHealthScore',
          'totalAssets',
          'totalDebt',
          'netWorth',
          'monthlyIncome',
          'monthlyExpenses',
          'recommendation',
        ]),
      );

      final required = schema.value['required']! as List;
      expect(required, hasLength(9));
    });

    testWidgets('renders sections with valid data', (tester) async {
      await _pump(tester, _data());

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Good'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('unknown health score falls back to grey', (tester) async {
      await _pump(tester, _data(healthScore: 'Unknown'));

      final chip = tester.widget<Container>(
        find.ancestor(
          of: find.text('Unknown'),
          matching: find.byType(Container),
        ),
      );
      final decoration = chip.decoration! as BoxDecoration;
      expect((decoration.border! as Border).top.color, Colors.grey);
    });
  });
}
