import 'package:finance_app/app/presentation.dart';
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
          'emoji': S.string(description: 'A single emoji character.'),
          'label': S.string(
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

    final cards = rawCards.cast<Map<String, Object?>>().map((c) {
      return EmojiCard(
        emoji: c['emoji']! as String,
        label: c['label']! as String,
        isSelected: c['isSelected'] as bool? ?? false,
      );
    }).toList();

    return EmojiCardLayout(cards: cards);
  },
);
