import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

class DonutChart extends StatelessWidget {
  const DonutChart({
    required this.items,
    required this.selectedIndex,
    required this.onSegmentHover,
    required this.onHoverExit,
    required this.onSegmentTap,
    required this.amount,
    required this.label,
    required this.percentage,
    this.donutSize = 210,
    this.strokeWidth = 41,
    this.selectedStrokeExtra = Spacing.xs,
    this.sectionsSpace = 2,
    this.startDegreeOffset = 270,
    this.dimmedOpacity = 0.4,
    super.key,
  });

  final List<PieChartItem> items;
  final int? selectedIndex;
  final ValueChanged<int> onSegmentHover;
  final VoidCallback onHoverExit;
  final ValueChanged<int> onSegmentTap;
  final String amount;
  final String label;
  final String? percentage;

  /// Outer diameter of the donut chart.
  final double donutSize;

  /// Radial thickness of each segment.
  final double strokeWidth;

  /// Extra radial thickness added to the currently selected segment.
  final double selectedStrokeExtra;

  /// Gap between adjacent segments.
  final double sectionsSpace;

  /// Angle (degrees) at which the first segment starts.
  final double startDegreeOffset;

  /// Alpha multiplier applied to unselected segments when a selection exists.
  final double dimmedOpacity;

  double get _centerSpaceRadius => donutSize / 2 - strokeWidth;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;

    return SizedBox(
      width: donutSize,
      height: donutSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sections: _buildSections(),
              centerSpaceRadius: _centerSpaceRadius,
              sectionsSpace: sectionsSpace,
              startDegreeOffset: startDegreeOffset,
              pieTouchData: PieTouchData(
                enabled: true,
                touchCallback: _handleTouch,
              ),
            ),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (percentage != null)
                Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              Text(
                amount,
                style: textTheme.headlineMedium?.copyWith(
                  color: colors.onSurface,
                ),
              ),
              Text(
                percentage ?? label,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    final hasSelection = selectedIndex != null;
    return [
      for (var i = 0; i < items.length; i++)
        PieChartSectionData(
          value: items[i].value,
          color: hasSelection && i != selectedIndex
              ? items[i].color?.withValues(alpha: dimmedOpacity)
              : items[i].color,
          radius: i == selectedIndex
              ? strokeWidth + selectedStrokeExtra
              : strokeWidth,
          showTitle: false,
        ),
    ];
  }

  void _handleTouch(FlTouchEvent event, PieTouchResponse? response) {
    if (event is FlPointerExitEvent) {
      onHoverExit();
      return;
    }

    final touchedIndex = response?.touchedSection?.touchedSectionIndex ?? -1;
    if (touchedIndex >= 0 && touchedIndex < items.length) {
      if (event is FlTapUpEvent) {
        onSegmentTap(touchedIndex);
      } else {
        onSegmentHover(touchedIndex);
      }
    } else if (event is! FlTapUpEvent) {
      onHoverExit();
    }
  }
}
