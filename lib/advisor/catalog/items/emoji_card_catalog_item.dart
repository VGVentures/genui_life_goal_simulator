import 'package:finance_app/app/presentation.dart';
import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A set of categorized options or highlights displayed as '
      'emoji-labelled cards in a responsive grid.',
  properties: {
    'cards': S.list(
      description: 'List of emoji cards to display in a responsive grid.',
      items: S.object(
        properties: {
          'emoji': A2uiSchemas.stringReference(
            description: 'A single emoji character.',
          ),
          'label': A2uiSchemas.stringReference(
            description: 'Short label shown below the emoji.',
          ),
          'isSelected': S.boolean(
            description: 'Whether the card is in the selected state.',
          ),
        },
        required: ['emoji', 'label'],
      ),
    ),
  },
  required: ['cards'],
);

/// CatalogItem that renders an [EmojiCardLayout] of [EmojiCard] widgets.
final emojiCardItem = CatalogItem(
  name: 'EmojiCard',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawCards = json['cards']! as List;

    return EmojiCardLayout(
      cards: rawCards.cast<Map<String, Object?>>().indexed.map((entry) {
        final (index, c) = entry;
        return _BoundEmojiCard(
          key: ValueKey('emoji_card_$index'),
          dataContext: ctx.dataContext,
          cardData: c,
        );
      }).toList(),
    );
  },
);

class _BoundEmojiCard extends EmojiCard {
  const _BoundEmojiCard({
    required DataContext dataContext,
    required Map<String, Object?> cardData,
    super.key,
  }) : _dataContext = dataContext,
       _cardData = cardData,
       super(emoji: '', label: '');

  final DataContext _dataContext;
  final Map<String, Object?> _cardData;

  @override
  Widget build(BuildContext context) {
    return BoundString(
      dataContext: _dataContext,
      value: _cardData['emoji'],
      builder: (context, emoji) {
        return BoundString(
          dataContext: _dataContext,
          value: _cardData['label'],
          builder: (context, label) {
            return EmojiCard(
              emoji: emoji ?? '',
              label: label ?? '',
              isSelected: _cardData['isSelected'] as bool? ?? false,
            );
          },
        );
      },
    );
  }
}
