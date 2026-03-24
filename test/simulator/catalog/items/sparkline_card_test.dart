import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/simulator/catalog/items/sparkline_card.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataModel extends Mock implements DataModel {}

Map<String, Object?> _data({
  String label = 'Savings',
  String amount = r'$12,500',
  String trend = 'positive',
}) => {
  'label': label,
  'amount': amount,
  'trend': trend,
};

CatalogItemContext _context(
  BuildContext context,
  Map<String, Object?> data,
) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'SparklineCard',
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
          builder: (context) => sparklineCardItem.widgetBuilder(
            _context(context, data),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group(sparklineCardItem, () {
    test('has correct name and schema keys', () {
      expect(sparklineCardItem.name, 'SparklineCard');

      final schema = sparklineCardItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(
        props,
        containsAll(['label', 'amount', 'trend']),
      );

      final required = schema.value['required']! as List;
      expect(
        required,
        containsAll(['label', 'amount', 'trend']),
      );
    });

    group('renders', () {
      testWidgets(
        'with positive trend',
        (tester) async {
          await _pump(tester, _data());

          expect(find.text('Savings'), findsOneWidget);
          expect(find.text(r'$12,500'), findsOneWidget);
          expect(
            find.byType(SparklineCard),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'with negative trend',
        (tester) async {
          await _pump(tester, _data(trend: 'negative'));

          expect(
            find.byType(SparklineCard),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'with stable trend',
        (tester) async {
          await _pump(tester, _data(trend: 'stable'));

          expect(
            find.byType(SparklineCard),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'falls back to stable for unknown trend',
        (tester) async {
          await _pump(tester, _data(trend: 'unknown'));

          expect(
            find.byType(SparklineCard),
            findsOneWidget,
          );
        },
      );
    });
  });
}
