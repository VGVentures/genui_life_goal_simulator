import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// A card molecule that displays a category or item with an emoji identifier
/// and a text label.
///
/// Supports two visual variants:
///
/// - **Default** – [emoji] and [label] on a surface-coloured card.
/// - **Selected** – highlighted with a primary-container background and
///   primary border when [isSelected] is `true`.
///
/// Use [EmojiCardLayout] to display a collection of cards with a responsive
/// horizontal-row (desktop) or 1-column grid (mobile) arrangement.
class EmojiCard extends StatelessWidget {
  /// Creates an [EmojiCard].
  const EmojiCard({
    required this.emoji,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.borderRadius = 8,
    this.borderWidth = 2,
    this.emojiSize = 32,
    super.key,
  });

  /// The emoji character to display.
  final String emoji;

  /// Short label shown below the emoji (e.g. 'Fixed costs').
  final String label;

  /// Whether this card renders in the selected/active state.
  final bool isSelected;

  /// Optional tap callback.
  final VoidCallback? onTap;

  /// Corner radius of the card.
  final double borderRadius;

  /// Thickness of the card's border.
  final double borderWidth;

  /// Font size applied to the emoji glyph.
  final double emojiSize;

  @override
  Widget build(BuildContext context) {
    final content = _EmojiCardContent(
      emoji: emoji,
      label: label,
      isSelected: isSelected,
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      emojiSize: emojiSize,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: content,
      ),
    );
  }
}

class _EmojiCardContent extends StatefulWidget {
  const _EmojiCardContent({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.borderRadius,
    required this.borderWidth,
    required this.emojiSize,
  });

  final String emoji;
  final String label;
  final bool isSelected;
  final double borderRadius;
  final double borderWidth;
  final double emojiSize;

  @override
  State<_EmojiCardContent> createState() => _EmojiCardContentState();
}

class _EmojiCardContentState extends State<_EmojiCardContent> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final backgroundColor = widget.isSelected
        ? colors.primaryContainer
        : _isHovered
        ? Color.alphaBlend(
            colors.primary.withValues(alpha: 0.05),
            colors.surfaceVariant,
          )
        : colors.surfaceVariant;

    final borderColor = widget.isSelected
        ? colors.primary
        : _isHovered
        ? colors.outlineVariant
        : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: borderColor,
            width: widget.borderWidth,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.emoji,
              style: TextStyle(fontSize: widget.emojiSize),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              widget.label,
              style: textTheme.labelLarge?.copyWith(
                color: colors.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Responsive layout for a collection of [EmojiCard] widgets.
///
/// - **Desktop** (screen width ≥ 600 px): cards in a single horizontal row,
///   each taking equal width via [Expanded].
/// - **Mobile** (screen width < 600 px): cards in a 2-column grid.
class EmojiCardLayout extends StatelessWidget {
  /// Creates an [EmojiCardLayout].
  const EmojiCardLayout({required this.cards, super.key});

  /// Cards to display.
  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      mobile: _MobileEmojiCardLayout(cards: cards),
      desktop: _DesktopEmojiCardLayout(cards: cards),
    );
  }
}

class _DesktopEmojiCardLayout extends StatelessWidget {
  const _DesktopEmojiCardLayout({required this.cards});

  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    // Split cards into rows of max 4.
    final rows = <List<Widget>>[];
    for (var i = 0; i < cards.length; i += 4) {
      rows.add(
        cards.sublist(i, i + 4 > cards.length ? cards.length : i + 4),
      );
    }

    return Column(
      children: [
        for (var r = 0; r < rows.length; r++) ...[
          if (r > 0) const SizedBox(height: Spacing.md),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var c = 0; c < rows[r].length; c++) ...[
                  if (c > 0) const SizedBox(width: Spacing.md),
                  Expanded(child: rows[r][c]),
                ],
                // Fill remaining slots so cards keep equal width.
                for (var empty = rows[r].length; empty < 4; empty++) ...[
                  const SizedBox(width: Spacing.md),
                  const Expanded(child: SizedBox.shrink()),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _MobileEmojiCardLayout extends StatelessWidget {
  const _MobileEmojiCardLayout({required this.cards});

  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:
          cards.expand((c) => [c, const SizedBox(height: Spacing.md)]).toList()
            ..removeLast(),
    );
  }
}
