import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/simulator/catalog/items/emoji_card_catalog_item.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataModel extends Mock implements DataModel {}

Map<String, Object?> _data({
  List<Map<String, Object?>>? cards,
}) => {
  'cards':
      cards ??
      [
        {'emoji': '💰', 'label': 'Savings', 'isSelected': true},
        {'emoji': '🏠', 'label': 'Housing', 'isSelected': false},
      ],
};

CatalogItemContext _context(BuildContext context, Map<String, Object?> data) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'EmojiCard',
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
              emojiCardItem.widgetBuilder(_context(context, data)),
        ),
      ),
    ),
  );
}

void main() {
  group(emojiCardItem, () {
    test('has correct name and schema keys', () {
      expect(emojiCardItem.name, 'EmojiCard');

      final schema = emojiCardItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(props, contains('cards'));

      final required = schema.value['required']! as List;
      expect(required, contains('cards'));
    });

    group('renders', () {
      testWidgets('emoji cards', (tester) async {
        await _pump(tester, _data());

        expect(find.text('💰'), findsOneWidget);
        expect(find.text('Savings'), findsOneWidget);
        expect(find.text('🏠'), findsOneWidget);
        expect(find.text('Housing'), findsOneWidget);
      });

      testWidgets('EmojiCardLayout', (tester) async {
        await _pump(tester, _data());

        expect(find.byType(EmojiCardLayout), findsOneWidget);
      });

      testWidgets('defaults isSelected to false when omitted', (tester) async {
        await _pump(
          tester,
          _data(
            cards: [
              {'emoji': '📊', 'label': 'Budget'},
            ],
          ),
        );

        expect(find.text('📊'), findsOneWidget);
        expect(find.text('Budget'), findsOneWidget);
      });
    });
  });
}
