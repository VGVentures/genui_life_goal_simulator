import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

final _schema = S.object(
  description:
      'A set of categorized options or highlights displayed as '
      'emoji-labelled cards in a responsive grid. '
      'The user can tap cards to toggle selection. Selected labels are '
      'written to the data model at /<componentId>/selectedLabels.',
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
            description: 'Whether the card starts in the selected state.',
          ),
        },
        required: ['emoji', 'label'],
      ),
    ),
  },
  required: ['cards'],
);

/// CatalogItem that renders an [EmojiCardLayout] with local selection state.
///
/// Selected labels are written to the data model at
/// `/<componentId>/selectedLabels`.
final emojiCardItem = CatalogItem(
  name: 'EmojiCard',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawCards = json['cards']! as List;
    final cards = rawCards.cast<Map<String, Object?>>();

    return _StatefulEmojiCards(
      cards: cards,
      dataContext: ctx.dataContext,
      componentId: ctx.id,
    );
  },
);

class _StatefulEmojiCards extends StatefulWidget {
  const _StatefulEmojiCards({
    required this.cards,
    required this.dataContext,
    required this.componentId,
  });

  final List<Map<String, Object?>> cards;
  final DataContext dataContext;
  final String componentId;

  @override
  State<_StatefulEmojiCards> createState() => _StatefulEmojiCardsState();
}

class _StatefulEmojiCardsState extends State<_StatefulEmojiCards> {
  late List<bool> _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.cards
        .map((c) => c['isSelected'] as bool? ?? false)
        .toList();
  }

  void _onTap(int index) {
    setState(() => _selected[index] = !_selected[index]);
    _writeToDataModel();
  }

  void _writeToDataModel() {
    final selectedLabels = [
      for (var i = 0; i < widget.cards.length; i++)
        if (_selected[i]) widget.cards[i]['label']?.toString() ?? '',
    ];
    widget.dataContext.update(
      DataPath('/${widget.componentId}/selectedLabels'),
      selectedLabels,
    );
  }

  @override
  Widget build(BuildContext context) {
    return EmojiCardLayout(
      cards: widget.cards.indexed.map((entry) {
        final (index, c) = entry;
        return _BoundEmojiCard(
          key: ValueKey('emoji_card_$index'),
          dataContext: widget.dataContext,
          cardData: c,
          isSelected: _selected[index],
          onTap: () => _onTap(index),
        );
      }).toList(),
    );
  }
}

class _BoundEmojiCard extends EmojiCard {
  const _BoundEmojiCard({
    required DataContext dataContext,
    required Map<String, Object?> cardData,
    required super.isSelected,
    required super.onTap,
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
              isSelected: isSelected,
              onTap: onTap,
            );
          },
        );
      },
    );
  }
}
