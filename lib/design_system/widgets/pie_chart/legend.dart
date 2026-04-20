import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

class Legend extends StatelessWidget {
  const Legend({
    required this.items,
    required this.totalValue,
    required this.selectedIndex,
    required this.onItemHover,
    required this.onHoverExit,
    required this.onItemTap,
    this.indicatorSize = 12,
    this.indicatorRadius = 2,
    this.rowVerticalPadding = 6,
    super.key,
  });

  final List<PieChartItem> items;
  final double totalValue;
  final int? selectedIndex;
  final ValueChanged<int> onItemHover;
  final VoidCallback onHoverExit;
  final ValueChanged<int> onItemTap;

  /// Side length of the colored square indicator in each row.
  final double indicatorSize;

  /// Corner radius of the colored indicator.
  final double indicatorRadius;

  /// Vertical padding around each legend row's content.
  final double rowVerticalPadding;

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedIndex != null;
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
            isDimmed: hasSelection && i != selectedIndex,
            onHover: () => onItemHover(i),
            onHoverExit: onHoverExit,
            onTap: () => onItemTap(i),
            indicatorSize: indicatorSize,
            indicatorRadius: indicatorRadius,
            verticalPadding: rowVerticalPadding,
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
    required this.isDimmed,
    required this.onHover,
    required this.onHoverExit,
    required this.onTap,
    required this.indicatorSize,
    required this.indicatorRadius,
    required this.verticalPadding,
  });

  final PieChartItem item;
  final String percentage;
  final bool isSelected;
  final bool isDimmed;
  final VoidCallback onHover;
  final VoidCallback onHoverExit;
  final VoidCallback onTap;
  final double indicatorSize;
  final double indicatorRadius;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;

    return InkWell(
      onTap: onTap,
      onHover: (hovering) => hovering ? onHover() : onHoverExit(),
      child: AnimatedOpacity(
        opacity: isDimmed ? 0.4 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: Spacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected ? colors.surfaceContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(Spacing.xs),
          ),
          child: Row(
            spacing: Spacing.md,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(indicatorRadius),
                ),
                child: SizedBox(
                  width: indicatorSize,
                  height: indicatorSize,
                ),
              ),
              Expanded(
                child: Text(
                  item.label,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                item.amount,
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.onSurface,
                ),
              ),
              Text(
                percentage,
                style: textTheme.labelMedium?.copyWith(
                  color: colors.onSurfaceMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
