import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// Visual variants for [InsightCard].
enum InsightCardVariant {
  /// Neutral/default style using surface colours.
  neutral,

  /// Success style using success colour tokens.
  success,

  /// Warning style using warning colour tokens.
  warning,

  /// Error style using error colour tokens.
  error,
}

/// A card that surfaces a contextual insight with an emoji badge, title, and
/// description.
///
/// Use [InsightCardVariant] to communicate sentiment:
///
/// - [InsightCardVariant.neutral] – informational default on a surface
///   background with no border.
/// - [InsightCardVariant.success] – positive outcome; green container and
///   border.
/// - [InsightCardVariant.warning] – cautionary message; orange container and
///   border.
/// - [InsightCardVariant.error] – critical or negative outcome; red container
///   and border.
class InsightCard extends StatelessWidget {
  /// Creates an [InsightCard].
  const InsightCard({
    required this.title,
    required this.description,
    this.emoji,
    this.variant = InsightCardVariant.neutral,
    this.cardBorderRadius = 12,
    this.badgeBorderRadius = 8,
    this.borderWidth = 1.5,
    this.emojiSize = 20,
    super.key,
  });

  /// Primary headline text.
  final String title;

  /// Supporting body text.
  final String description;

  /// Emoji shown in the badge for the [InsightCardVariant.neutral] variant.
  /// Ignored for all other variants, which use a fixed emoji.
  final String? emoji;

  /// Visual variant controlling colours and border.
  final InsightCardVariant variant;

  /// Corner radius of the card container.
  final double cardBorderRadius;

  /// Corner radius of the emoji badge.
  final double badgeBorderRadius;

  /// Thickness of the card's border.
  final double borderWidth;

  /// Font size applied to the emoji glyph.
  final double emojiSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final backgroundColor = switch (variant) {
      InsightCardVariant.neutral => colors.surfaceVariant,
      InsightCardVariant.success => colors.successContainer,
      InsightCardVariant.warning => colors.warningContainer,
      InsightCardVariant.error => colors.errorContainer,
    };

    final borderColor = switch (variant) {
      InsightCardVariant.neutral => Colors.transparent,
      InsightCardVariant.success => colors.success,
      InsightCardVariant.warning => colors.warning,
      InsightCardVariant.error => colors.error,
    };

    final badgeColor = colors.surfaceVariant;

    final badgeBorderColor = variant == InsightCardVariant.neutral
        ? colors.outline
        : Colors.transparent;

    final resolvedEmoji = switch (variant) {
      InsightCardVariant.neutral => emoji ?? '💡',
      InsightCardVariant.success => '✅',
      InsightCardVariant.warning => '⚠️',
      InsightCardVariant.error => '🚨',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.xs),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(badgeBorderRadius),
              border: Border.all(color: badgeBorderColor),
            ),
            child: Text(
              resolvedEmoji,
              style: TextStyle(
                fontSize: emojiSize,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            title,
            style: textTheme.headlineSmall?.copyWith(
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            description,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
