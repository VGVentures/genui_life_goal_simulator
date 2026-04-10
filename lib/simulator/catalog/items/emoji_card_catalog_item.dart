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

void _toggleEmojiSelection({
  required DataContext dataContext,
  required String componentId,
  required EmojiCardSelectionMode mode,
  required List<String> currentList,
  required String toggledLabel,
}) {
  if (toggledLabel.isEmpty) return;
  final path = DataPath('/$componentId/selectedLabels');
  if (mode == EmojiCardSelectionMode.single) {
    final already = currentList.contains(toggledLabel);
    dataContext.update(
      path,
      already ? <String>[] : <String>[toggledLabel],
    );
    return;
  }
  final next = List<String>.from(currentList);
  if (next.contains(toggledLabel)) {
    next.remove(toggledLabel);
  } else {
    next.add(toggledLabel);
  }
  dataContext.update(path, next);
}

List<String> _selectedLabelsFromRaw(List<Object?>? raw) {
  return [
    for (final e in raw ?? const <Object?>[])
      if (e != null) e.toString(),
  ];
}

/// CatalogItem that renders an [EmojiCardLayout].
///
/// Selection is bound to `/<componentId>/selectedLabels` via [BoundList].
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

    return _EmojiCardSurface(
      cards: cards,
      callToAction: callToAction,
      selectionMode: selectionMode,
      dataContext: ctx.dataContext,
      componentId: ctx.id,
    );
  },
);

class _EmojiCardSurface extends StatefulWidget {
  const _EmojiCardSurface({
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
  State<_EmojiCardSurface> createState() => _EmojiCardSurfaceState();
}

class _EmojiCardSurfaceState extends State<_EmojiCardSurface> {
  @override
  void initState() {
    super.initState();
    _seedIfNeeded();
  }

  void _seedIfNeeded() {
    final path = DataPath('/${widget.componentId}/selectedLabels');
    if (widget.dataContext.getValue<Object?>(path) != null) return;
    final initial = <String>[
      for (final c in widget.cards)
        if (c['isSelected'] == true && c['label'] is String)
          c['label']! as String,
    ];
    widget.dataContext.update(path, initial);
  }

  @override
  Widget build(BuildContext context) {
    final path = '/${widget.componentId}/selectedLabels';

    final layout = BoundList(
      dataContext: widget.dataContext,
      value: {'path': path},
      builder: (context, rawSelected) {
        final currentList = _selectedLabelsFromRaw(rawSelected);
        return EmojiCardLayout(
          cards: widget.cards.indexed.map((entry) {
            final (index, c) = entry;
            return _BoundEmojiCard(
              key: ValueKey('emoji_card_$index'),
              dataContext: widget.dataContext,
              cardData: c,
              selectedLabels: currentList,
              selectionMode: widget.selectionMode,
              componentId: widget.componentId,
            );
          }).toList(),
        );
      },
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

class _BoundEmojiCard extends StatelessWidget {
  const _BoundEmojiCard({
    required this.dataContext,
    required this.cardData,
    required this.selectedLabels,
    required this.selectionMode,
    required this.componentId,
    super.key,
  });

  final DataContext dataContext;
  final Map<String, Object?> cardData;
  final List<String> selectedLabels;
  final EmojiCardSelectionMode selectionMode;
  final String componentId;

  @override
  Widget build(BuildContext context) {
    return BoundString(
      dataContext: dataContext,
      value: cardData['emoji'],
      builder: (context, emoji) {
        return BoundString(
          dataContext: dataContext,
          value: cardData['label'],
          builder: (context, labelStr) {
            final label = labelStr ?? '';
            final isSelected =
                label.isNotEmpty && selectedLabels.contains(label);
            return EmojiCard(
              emoji: emoji ?? '',
              label: label,
              isSelected: isSelected,
              onTap: label.isEmpty
                  ? null
                  : () {
                      _toggleEmojiSelection(
                        dataContext: dataContext,
                        componentId: componentId,
                        mode: selectionMode,
                        currentList: selectedLabels,
                        toggledLabel: label,
                      );
                    },
            );
          },
        );
      },
    );
  }
}
