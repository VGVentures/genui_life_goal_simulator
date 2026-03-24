import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// Data for a single segment in a [PieChartComponent].
class PieChartItem {
  /// Creates a [PieChartItem].
  const PieChartItem({
    required this.label,
    required this.value,
    required this.amount,
    required this.color,
  });

  /// Category name (e.g. "Groceries").
  final String label;

  /// Numeric value used to compute the segment's arc proportion.
  final double value;

  /// Pre-formatted display string (e.g. "\$1,420").
  final String amount;

  /// Segment color from the extended palette.
  final Color? color;
}

/// {@template pie_chart}
/// An interactive donut chart with a color-coded legend.
///
/// Hovering over a segment or legend row selects it, showing its details
/// in the donut center. Moving the pointer away deselects.
/// {@endtemplate}
class PieChartComponent extends StatefulWidget {
  /// {@macro pie_chart}
  const PieChartComponent({
    required this.items,
    required this.totalLabel,
    required this.totalAmount,
    this.selectedIndex,
    this.onSelectedIndexChanged,
    super.key,
  });

  /// Segments to display.
  final List<PieChartItem> items;

  /// Label shown in the donut center when no segment is selected (e.g.
  /// "Total").
  final String totalLabel;

  /// Formatted total shown in the donut center when no segment is selected
  /// (e.g. "\$4,225").
  final String totalAmount;

  /// Externally controlled selected segment index.
  ///
  /// When provided, the widget uses this instead of internal state.
  final int? selectedIndex;

  /// Called when selection changes.
  final ValueChanged<int?>? onSelectedIndexChanged;

  @override
  State<PieChartComponent> createState() => _PieChartComponentState();
}

class _PieChartComponentState extends State<PieChartComponent> {
  int? _selectedIndex;

  int? get _effectiveSelectedIndex => widget.selectedIndex ?? _selectedIndex;

  double get _totalValue =>
      widget.items.fold(0, (sum, item) => sum + item.value);

  String _percentage(double value) {
    final total = _totalValue;
    if (total == 0) return '0%';
    return '${(value / total * 100).round()}%';
  }

  void _handleHover(int index) {
    if (widget.selectedIndex == null) {
      setState(() => _selectedIndex = index);
    }
    widget.onSelectedIndexChanged?.call(index);
  }

  void _handleHoverExit() {
    if (widget.selectedIndex == null) {
      setState(() => _selectedIndex = null);
    }
    widget.onSelectedIndexChanged?.call(null);
  }

  void _handleTap(int index) {
    if (_effectiveSelectedIndex == index) {
      _handleHoverExit();
    } else {
      _handleHover(index);
    }
  }

  @override
  void didUpdateWidget(PieChartComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != null && oldWidget.selectedIndex == null) {
      _selectedIndex = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = _effectiveSelectedIndex;
    final String amount;
    final String label;
    final String? percentage;

    if (selected != null && selected < widget.items.length) {
      final item = widget.items[selected];
      amount = item.amount;
      label = item.label;
      percentage = _percentage(item.value);
    } else {
      amount = widget.totalAmount;
      label = widget.totalLabel;
      percentage = null;
    }

    final donut = DonutChart(
      items: widget.items,
      selectedIndex: _effectiveSelectedIndex,
      onSegmentHover: _handleHover,
      onHoverExit: _handleHoverExit,
      onSegmentTap: _handleTap,
      amount: amount,
      label: label,
      percentage: percentage,
    );

    final legend = Legend(
      items: widget.items,
      totalValue: _totalValue,
      selectedIndex: _effectiveSelectedIndex,
      onItemHover: _handleHover,
      onHoverExit: _handleHoverExit,
      onItemTap: _handleTap,
    );

    return ResponsiveScaffold(
      mobile: Column(
        spacing: _Dimensions.columnSpacing,
        mainAxisSize: MainAxisSize.min,
        children: [
          donut,
          legend,
        ],
      ),
      desktop: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: _Dimensions.rowSpacing,
        children: [
          donut,
          Expanded(child: legend),
        ],
      ),
    );
  }
}

abstract final class _Dimensions {
  static const double columnSpacing = 46;
  static const double rowSpacing = 40;
}
