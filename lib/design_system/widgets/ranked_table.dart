import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// Data for a single row in a [RankedTable].
class RankedTableItem {
  /// Creates a [RankedTableItem].
  const RankedTableItem({
    required this.title,
    required this.amount,
    required this.delta,
  });

  /// The name displayed in the row (e.g. "The French Laundry").
  final String title;

  /// Formatted amount string (e.g. "\$350").
  final String amount;

  /// Formatted delta with sign and % (e.g. "+15%", "-5%").
  final String delta;
}

/// {@template ranked_table}
/// A table that displays a list of [RankedTableItem]s with their
/// rank position, title, amount, and percentage delta.
///
/// Positive deltas are shown in green and negative deltas in red.
/// {@endtemplate}
class RankedTable extends StatelessWidget {
  /// {@macro ranked_table}
  const RankedTable({
    required this.items,
    this.rankBadgeVerticalPadding = 6,
    this.textRowVerticalPadding = 10,
    super.key,
  });

  /// The items to display, ranked in order.
  final List<RankedTableItem> items;

  /// Vertical padding around the rank badge on each row.
  final double rankBadgeVerticalPadding;

  /// Vertical padding around the text cells (title, amount) on each row.
  final double textRowVerticalPadding;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: Spacing.md,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _RankedTableRow(
            rank: i + 1,
            item: items[i],
            colors: colors,
            textTheme: textTheme,
            rankBadgeVerticalPadding: rankBadgeVerticalPadding,
            textRowVerticalPadding: textRowVerticalPadding,
          ),
          Divider(
            height: 1,
            color: colors.outlineVariant,
          ),
        ],
      ],
    );
  }
}

class _RankedTableRow extends StatelessWidget {
  const _RankedTableRow({
    required this.rank,
    required this.item,
    required this.colors,
    required this.textTheme,
    required this.rankBadgeVerticalPadding,
    required this.textRowVerticalPadding,
  });

  final int rank;
  final RankedTableItem item;
  final AppColors colors;
  final TextTheme textTheme;
  final double rankBadgeVerticalPadding;
  final double textRowVerticalPadding;

  @override
  Widget build(BuildContext context) {
    final isNegative = item.delta.startsWith('-');
    final deltaColor = isNegative ? colors.error : colors.success;

    return Row(
      spacing: Spacing.md,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: rankBadgeVerticalPadding),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surfaceContainer,
              borderRadius: BorderRadius.circular(Spacing.xs),
            ),
            child: SizedBox(
              width: Spacing.xxxl,
              height: Spacing.xxxl,
              child: Align(
                child: Text(
                  '$rank',
                  textAlign: TextAlign.center,
                  style: textTheme.labelLarge?.copyWith(
                    color: colors.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: textRowVerticalPadding),
            child: Text(
              item.title,
              style: textTheme.titleSmall?.copyWith(
                color: colors.onSurface,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: textRowVerticalPadding),
          child: Text(
            item.amount,
            textAlign: TextAlign.end,
            style: textTheme.bodyLarge?.copyWith(
              color: colors.onSurface,
            ),
          ),
        ),
        Text(
          item.delta,
          textAlign: TextAlign.end,
          style: textTheme.bodyLarge?.copyWith(color: deltaColor),
        ),
      ],
    );
  }
}
