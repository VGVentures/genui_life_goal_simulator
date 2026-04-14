import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/simulator/catalog/items/emoji_card_catalog_item.dart';

Map<String, Object?> _data({
  List<Map<String, Object?>>? cards,
  String callToAction = 'Select all that apply',
  String? selectionMode,
}) => {
  'callToAction': callToAction,
  'selectionMode': selectionMode,
  'cards':
      cards ??
      [
        {'emoji': '💰', 'label': 'Savings', 'isSelected': true},
        {'emoji': '🏠', 'label': 'Housing', 'isSelected': false},
      ],
};

CatalogItemContext _context(
  BuildContext context,
  Map<String, Object?> data, {
  DataModel? dataModel,
}) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'EmojiCard',
    buildChild: (id, [dataContext]) => const SizedBox.shrink(),
    dispatchEvent: (_) {},
    buildContext: context,
    dataContext: DataContext(dataModel ?? InMemoryDataModel(), DataPath.root),
    getComponent: (_) => null,
    getCatalogItem: (_) => null,
    surfaceId: 'surface',
    reportError: (_, _) {},
  );
}

Future<void> _pump(
  WidgetTester tester,
  Map<String, Object?> data, {
  DataModel? dataModel,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: Scaffold(
        body: Builder(
          builder: (context) => emojiCardItem.widgetBuilder(
            _context(context, data, dataModel: dataModel),
          ),
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
      expect(props, containsAll(['callToAction', 'selectionMode', 'cards']));

      final required = schema.value['required']! as List;
      expect(required, containsAll(['callToAction', 'cards']));
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

      testWidgets('call-to-action text', (tester) async {
        await _pump(
          tester,
          _data(),
        );

        expect(find.text('Select all that apply'), findsOneWidget);
      });

      testWidgets('no call-to-action text when empty', (tester) async {
        await _pump(tester, _data(callToAction: ''));

        expect(find.text('Select all that apply'), findsNothing);
      });
    });

    group('single selection mode', () {
      testWidgets('selecting a card deselects others', (tester) async {
        await _pump(
          tester,
          _data(
            selectionMode: 'single',
            cards: [
              {'emoji': '👍', 'label': 'Yes'},
              {'emoji': '👎', 'label': 'No'},
            ],
          ),
        );

        await tester.tap(find.text('Yes'));
        await tester.pump();
        await tester.tap(find.text('No'));
        await tester.pump();

        final yesCard = tester.widget<EmojiCard>(
          find.ancestor(
            of: find.text('Yes'),
            matching: find.byType(EmojiCard),
          ),
        );
        final noCard = tester.widget<EmojiCard>(
          find.ancestor(
            of: find.text('No'),
            matching: find.byType(EmojiCard),
          ),
        );

        expect(yesCard.isSelected, isFalse);
        expect(noCard.isSelected, isTrue);
      });

      testWidgets('tapping selected card deselects it', (tester) async {
        await _pump(
          tester,
          _data(
            selectionMode: 'single',
            cards: [
              {'emoji': '👍', 'label': 'Yes', 'isSelected': true},
            ],
          ),
        );

        await tester.tap(find.text('Yes'));
        await tester.pump();

        final card = tester.widget<EmojiCard>(
          find.ancestor(
            of: find.text('Yes'),
            matching: find.byType(EmojiCard),
          ),
        );
        expect(card.isSelected, isFalse);
      });
    });
  });
}
