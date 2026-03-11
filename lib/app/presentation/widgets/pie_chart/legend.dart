import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';

class Legend extends StatelessWidget {
  const Legend({
    required this.items,
    required this.totalValue,
    required this.selectedIndex,
    required this.onItemHover,
    required this.onHoverExit,
    super.key,
  });

  final List<PieChartItem> items;
  final double totalValue;
  final int? selectedIndex;
  final ValueChanged<int> onItemHover;
  final VoidCallback onHoverExit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < items.length; i++)
          _LegendRow(
            item: items[i],
            percentage: totalValue == 0
                ? '0%'
                : '${(items[i].value / totalValue * 100).round()}%',
            isSelected: i == selectedIndex,
            onHover: () => onItemHover(i),
            onHoverExit: onHoverExit,
          ),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.item,
    required this.percentage,
    required this.isSelected,
    required this.onHover,
    required this.onHoverExit,
  });

  final PieChartItem item;
  final String percentage;
  final bool isSelected;
  final VoidCallback onHover;
  final VoidCallback onHoverExit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>();

    return MouseRegion(
      onEnter: (_) => onHover(),
      onExit: (_) => onHoverExit(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: _Dimensions.containerVerticalPadding,
          horizontal: Spacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colors?.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(Spacing.xs),
        ),
        child: Row(
          spacing: Spacing.md,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(
                  _Dimensions.indicatorRadius,
                ),
              ),
              child: const SizedBox(
                width: _Dimensions.indicatorSize,
                height: _Dimensions.indicatorSize,
              ),
            ),
            Expanded(
              child: Text(
                item.label,
                style: textTheme.bodyMedium?.copyWith(
                  color: colors?.onSurfaceVariant,
                ),
              ),
            ),
            Text(
              item.amount,
              style: textTheme.bodyMedium?.copyWith(
                color: colors?.onSurface,
              ),
            ),
            Text(
              percentage,
              style: textTheme.labelMedium?.copyWith(
                color: colors?.onSurfaceMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

abstract final class _Dimensions {
  static const double indicatorSize = 12;
  static const double indicatorRadius = 2;
  static const double containerVerticalPadding = 6;
}
