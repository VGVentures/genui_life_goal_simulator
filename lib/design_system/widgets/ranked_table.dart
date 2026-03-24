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
    super.key,
  });

  /// The items to display, ranked in order.
  final List<RankedTableItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
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
          ),
          Divider(
            height: 1,
            color: colors?.outlineVariant ?? Colors.transparent,
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
  });

  final int rank;
  final RankedTableItem item;
  final AppColors? colors;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final isNegative = item.delta.startsWith('-');
    final deltaColor = isNegative
        ? (colors?.error ?? Colors.transparent)
        : (colors?.success ?? Colors.transparent);

    return Row(
      spacing: Spacing.md,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: _Dimensions.verticalRankItemRowPadding,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors?.surfaceContainer ?? Colors.transparent,
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
                    color: colors?.onSurface ?? Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: _Dimensions.verticalTextItemRowPadding,
            ),
            child: Text(
              item.title,
              style: textTheme.titleSmall?.copyWith(
                color: colors?.onSurface ?? Colors.transparent,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: _Dimensions.verticalTextItemRowPadding,
          ),
          child: Text(
            item.amount,
            textAlign: TextAlign.end,
            style: textTheme.bodyLarge?.copyWith(
              color: colors?.onSurface ?? Colors.transparent,
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

abstract final class _Dimensions {
  static const double verticalRankItemRowPadding = 6;
  static const double verticalTextItemRowPadding = 10;
}
