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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
    final textTheme = Theme.of(context).textTheme;

    final backgroundColor = switch (variant) {
      InsightCardVariant.neutral =>
        colors?.surfaceVariant ?? const Color(0xFFFFFFFF),
      InsightCardVariant.success =>
        colors?.successContainer ?? const Color(0xFFC2FFD1),
      InsightCardVariant.warning =>
        colors?.warningContainer ?? const Color(0xFFFFEEE1),
      InsightCardVariant.error =>
        colors?.errorContainer ?? const Color(0xFFFFDAD5),
    };

    final borderColor = switch (variant) {
      InsightCardVariant.neutral => Colors.transparent,
      InsightCardVariant.success => colors?.success ?? const Color(0xFF00A65F),
      InsightCardVariant.warning => colors?.warning ?? const Color(0xFFF69426),
      InsightCardVariant.error => colors?.error ?? const Color(0xFFFF5446),
    };

    const badgeColor = Colors.white;

    final badgeBorderColor = variant == InsightCardVariant.neutral
        ? colors?.outline ?? const Color(0xFFF0F1F1)
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
        borderRadius: BorderRadius.circular(_Dimensions.cardBorderRadius),
        border: Border.all(
          color: borderColor,
          width: _Dimensions.borderWidth,
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
              borderRadius: BorderRadius.circular(
                _Dimensions.badgeBorderRadius,
              ),
              border: Border.all(color: badgeBorderColor),
            ),
            child: Text(
              resolvedEmoji,
              style: const TextStyle(
                fontSize: _Dimensions.emojiSize,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            title,
            style: textTheme.headlineSmall?.copyWith(
              color: colors?.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            description,
            style: textTheme.bodyMedium?.copyWith(
              color: colors?.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

abstract final class _Dimensions {
  static const double cardBorderRadius = 12;
  static const double badgeBorderRadius = 8;
  static const double borderWidth = 1.5;
  static const double emojiSize = 20;
}
