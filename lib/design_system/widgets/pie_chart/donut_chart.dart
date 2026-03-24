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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>();

    return SizedBox(
      width: _Dimensions.donutSize,
      height: _Dimensions.donutSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sections: _buildSections(),
              centerSpaceRadius: _Dimensions.centerSpaceRadius,
              sectionsSpace: _Dimensions.sectionsSpace,
              startDegreeOffset: _Dimensions.startDegreeOffset,
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
                    color: colors?.onSurfaceVariant,
                  ),
                ),
              Text(
                amount,
                style: textTheme.headlineMedium?.copyWith(
                  color: colors?.onSurface,
                ),
              ),
              Text(
                percentage ?? label,
                style: textTheme.bodySmall?.copyWith(
                  color: colors?.onSurfaceVariant,
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
              ? items[i].color?.withValues(alpha: _Dimensions.dimmedOpacity)
              : items[i].color,
          radius: i == selectedIndex
              ? _Dimensions.strokeWidth + _Dimensions.selectedStrokeExtra
              : _Dimensions.strokeWidth,
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

abstract final class _Dimensions {
  static const double dimmedOpacity = 0.4;
  static const double donutSize = 210;
  static const double strokeWidth = 41;
  static const double selectedStrokeExtra = 8;
  static const double sectionsSpace = 2;
  static const double startDegreeOffset = 270;
  static const double centerSpaceRadius = donutSize / 2 - strokeWidth;
}
