import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/gen/assets.gen.dart';

/// The direction of the trend, used to determine sparkline color.
enum TrendType {
  negative,
  stable,
  positive,
}

/// {@template sparkline_card}
/// A card that displays a category [label], a formatted [amount].
///
/// The sparkline color is determined by [trend]:
/// * [TrendType.negative] — error (red).
/// * [TrendType.stable]   — primary (blue).
/// * [TrendType.positive] — success (green).
/// {@endtemplate}
class SparklineCard extends StatelessWidget {
  /// {@macro sparkline_card}
  const SparklineCard({
    required this.label,
    required this.amount,
    required this.trend,
    super.key,
  });

  /// The category name displayed at the top-left of the card.
  final String label;

  /// The formatted amount displayed at the bottom-left of the card.
  final String amount;

  /// Determines the sparkline color.
  final TrendType trend;

  @override
  Widget build(BuildContext context) {
    final themeOf = Theme.of(context);
    final colors = themeOf.extension<AppColors>();
    final textTheme = themeOf.textTheme;

    final trendLine = switch (trend) {
      TrendType.negative => Assets.images.sparklineCards.negativeLine.svg(),
      TrendType.stable => Assets.images.sparklineCards.stableLine.svg(),
      TrendType.positive => Assets.images.sparklineCards.positiveLine.svg(),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors?.surface,
        borderRadius: BorderRadius.circular(Spacing.xs),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors?.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    amount,
                    style: textTheme.headlineSmall?.copyWith(
                      color: colors?.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  trendLine,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// {@template sparkline_cards_layout}
/// A responsive layout for a collection of [SparklineCard] widgets.
///
/// - **Desktop** (screen width ≥ 600 px): cards in a single horizontal row,
///   each taking equal width via [Expanded].
/// - **Mobile** (screen width < 600 px): cards stacked vertically, each
///   stretching to full width.
/// {@endtemplate}
class SparklineCardsLayout extends StatelessWidget {
  /// {@macro sparkline_cards_layout}
  const SparklineCardsLayout({required this.cards, super.key});

  /// The cards to display.
  final List<SparklineCard> cards;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      mobile: _MobileSparklineCardsLayout(cards: cards),
      desktop: _DesktopSparklineCardsLayout(cards: cards),
    );
  }
}

class _DesktopSparklineCardsLayout extends StatelessWidget {
  const _DesktopSparklineCardsLayout({required this.cards});

  final List<SparklineCard> cards;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < cards.length; i++) ...[
          Expanded(child: cards[i]),
          if (i < cards.length - 1) const SizedBox(width: Spacing.sm),
        ],
      ],
    );
  }
}

class _MobileSparklineCardsLayout extends StatelessWidget {
  const _MobileSparklineCardsLayout({required this.cards});

  final List<SparklineCard> cards;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:
          cards.expand((c) => [c, const SizedBox(height: Spacing.sm)]).toList()
            ..removeLast(),
    );
  }
}
