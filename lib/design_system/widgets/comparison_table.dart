import 'package:flutter/material.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';
import 'package:vgv_genui_financial_advisor/l10n/l10n.dart';

/// Data for a single row in a [ComparisonTable].
class ComparisonTableItem {
  /// Creates a [ComparisonTableItem].
  const ComparisonTableItem({
    required this.label,
    required this.lastMonthAmount,
    required this.actualMonthAmount,
  });

  /// Category name (e.g. "Groceries").
  final String label;

  /// Last month's spend as a numeric value.
  final double lastMonthAmount;

  /// This month's spend as a numeric value.
  final double actualMonthAmount;
}

/// {@template comparison_table}
/// A table comparing last month and this month spending by category.
///
/// Each row displays the category label, last month amount, a calculated
/// percentage delta (green for positive, red for negative), and this month
/// amount.
/// {@endtemplate}
class ComparisonTable extends StatelessWidget {
  /// {@macro comparison_table}
  const ComparisonTable({
    required this.items,
    super.key,
  });

  /// The items to display.
  final List<ComparisonTableItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: Spacing.lg,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _ComparisonTableRow(
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

class _ComparisonTableRow extends StatelessWidget {
  const _ComparisonTableRow({
    required this.item,
    required this.colors,
    required this.textTheme,
  });

  final ComparisonTableItem item;
  final AppColors? colors;
  final TextTheme textTheme;

  String _formatAmount(double value) =>
      r'$'
      '${value.toStringAsFixed(0)}';

  String _calculateVariation() {
    if (item.lastMonthAmount == 0) return '\u2014';
    final variation =
        ((item.actualMonthAmount - item.lastMonthAmount) /
                item.lastMonthAmount *
                100)
            .round();
    return '${variation >= 0 ? '+' : ''}$variation%';
  }

  bool get _isNegative => item.actualMonthAmount < item.lastMonthAmount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final variation = _calculateVariation();
    final variationColor = item.lastMonthAmount == 0
        ? colors?.onSurfaceMuted
        : _isNegative
        ? colors?.error
        : colors?.success;

    return Row(
      spacing: Spacing.md,
      children: [
        Expanded(
          child: Text(
            item.label,
            style: textTheme.bodyMedium?.copyWith(
              color: colors?.onSurface ?? Colors.transparent,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _AmountColumn(
          label: l10n.lastMonthLabel,
          amount: _formatAmount(item.lastMonthAmount),
          colors: colors,
          textTheme: textTheme,
        ),
        Expanded(
          child: Text(
            variation,
            style: textTheme.bodyLarge?.copyWith(color: variationColor),
            textAlign: TextAlign.center,
          ),
        ),
        _AmountColumn(
          label: l10n.thisMonthLabel,
          amount: _formatAmount(item.actualMonthAmount),
          colors: colors,
          textTheme: textTheme,
        ),
      ],
    );
  }
}

class _AmountColumn extends StatelessWidget {
  const _AmountColumn({
    required this.label,
    required this.amount,
    required this.colors,
    required this.textTheme,
  });

  final String label;
  final String amount;
  final AppColors? colors;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Spacing.xxs,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colors?.onSurfaceMuted ?? Colors.transparent,
          ),
        ),
        Text(
          amount,
          style: textTheme.bodyMedium?.copyWith(
            color: colors?.onSurface ?? Colors.transparent,
          ),
        ),
      ],
    );
  }
}
