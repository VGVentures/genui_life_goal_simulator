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

  @override
  Widget build(BuildContext context) {
    final content = _EmojiCardContent(
      emoji: emoji,
      label: label,
      isSelected: isSelected,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(_Dimensions.borderRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_Dimensions.borderRadius),
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
  });

  final String emoji;
  final String label;
  final bool isSelected;

  @override
  State<_EmojiCardContent> createState() => _EmojiCardContentState();
}

class _EmojiCardContentState extends State<_EmojiCardContent> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
    final textTheme = Theme.of(context).textTheme;

    final backgroundColor = widget.isSelected
        ? (colors?.primaryContainer ?? _EmojiCardColors.selectedBackground)
        : _isHovered
        ? Color.alphaBlend(
            colors?.primary.withValues(alpha: 0.05) ?? Colors.transparent,
            colors?.surfaceVariant ?? Colors.white,
          )
        : (colors?.surfaceVariant ?? _EmojiCardColors.background);

    final borderColor = widget.isSelected
        ? (colors?.primary ?? _EmojiCardColors.selectedBorder)
        : _isHovered
        ? (colors?.outlineVariant ?? _EmojiCardColors.border)
        : _EmojiCardColors.border;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(_Dimensions.borderRadius),
          border: Border.all(
            color: borderColor,
            width: _Dimensions.borderWidth,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.emoji,
              style: const TextStyle(fontSize: _Dimensions.emojiSize),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              widget.label,
              style: textTheme.labelLarge?.copyWith(
                color: colors?.onSurface ?? _EmojiCardColors.label,
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
  final List<EmojiCard> cards;

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

  final List<EmojiCard> cards;

  @override
  Widget build(BuildContext context) {
    // Split cards into rows of max 4.
    final rows = <List<EmojiCard>>[];
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

  final List<EmojiCard> cards;

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

abstract final class _Dimensions {
  static const double borderRadius = 8;
  static const double borderWidth = 2;
  static const double emojiSize = 32;
}

abstract final class _EmojiCardColors {
  static const Color background = Color(0xFFF7F6F7);
  static const Color border = Colors.transparent;
  static const Color selectedBackground = Color(0xFFF3F6FF);
  static const Color selectedBorder = Color(0xFF6D92F5);
  static const Color label = Color(0xFF1A1C1C);
}
