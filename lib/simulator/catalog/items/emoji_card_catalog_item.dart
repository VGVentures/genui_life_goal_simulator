import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A set of categorized options or highlights displayed as '
      'emoji-labelled cards in a responsive grid. '
      'Always provide a callToAction so the user knows what to do with the '
      'cards (e.g. "Select all that apply" or "Choose one option"). '
      'Use selectionMode "single" when the options are mutually exclusive '
      '(e.g. Yes / No). '
      'Selected labels are written to the data model at '
      '/<componentId>/selectedLabels.',
  properties: {
    'callToAction': A2uiSchemas.stringReference(
      description:
          'Short instruction shown above the cards telling the user what '
          'action to take (e.g. "Select all that apply", '
          '"Choose one option"). '
          'Plain text only — no markdown formatting.',
    ),
    'selectionMode': S.string(
      description:
          'Controls how many cards can be selected at once. '
          '"multi" (default) lets the user toggle any number of cards. '
          '"single" allows only one card to be selected at a time — '
          'use this when the options are mutually exclusive.',
      enumValues: ['multi', 'single'],
    ),
    'cards': S.list(
      description: 'List of emoji cards to display in a responsive grid.',
      items: S.object(
        properties: {
          'emoji': A2uiSchemas.stringReference(
            description: 'A single emoji character.',
          ),
          'label': A2uiSchemas.stringReference(
            description:
                'Short label shown below the emoji. '
                'Plain text only — no markdown formatting.',
          ),
          'isSelected': S.boolean(
            description: 'Whether the card starts in the selected state.',
          ),
        },
        required: ['emoji', 'label'],
      ),
    ),
  },
  required: ['callToAction', 'cards'],
);

/// Whether emoji cards allow multiple selections or only one at a time.
enum EmojiCardSelectionMode {
  /// Any number of cards can be toggled independently.
  multi,

  /// Only one card can be selected at a time (mutually exclusive options).
  single,
}

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
    final callToAction = json['callToAction']?.toString() ?? '';
    final selectionMode = json['selectionMode']?.toString() == 'single'
        ? EmojiCardSelectionMode.single
        : EmojiCardSelectionMode.multi;

    return _StatefulEmojiCards(
      cards: cards,
      callToAction: callToAction,
      selectionMode: selectionMode,
      dataContext: ctx.dataContext,
      componentId: ctx.id,
    );
  },
);

class _StatefulEmojiCards extends StatefulWidget {
  const _StatefulEmojiCards({
    required this.cards,
    required this.callToAction,
    required this.selectionMode,
    required this.dataContext,
    required this.componentId,
  });

  final List<Map<String, Object?>> cards;
  final String callToAction;
  final EmojiCardSelectionMode selectionMode;
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
    setState(() {
      if (widget.selectionMode == EmojiCardSelectionMode.single) {
        final alreadySelected = _selected[index];
        for (var i = 0; i < _selected.length; i++) {
          _selected[i] = false;
        }
        _selected[index] = !alreadySelected;
      } else {
        _selected[index] = !_selected[index];
      }
    });
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
    final layout = EmojiCardLayout(
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

    if (widget.callToAction.isEmpty) return layout;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        MarkdownBody(
          data: widget.callToAction,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
            p: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        layout,
      ],
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
