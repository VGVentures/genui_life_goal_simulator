import 'dart:math';

import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

/// A single data point on the [LineChart].
@immutable
class LineChartPoint {
  /// Creates a [LineChartPoint].
  const LineChartPoint({
    required this.xLabel,
    required this.value,
    required this.tooltipLabel,
    required this.tooltipValue,
  });

  /// Label displayed on the x-axis (e.g. "Sep", "Oct").
  final String xLabel;

  /// Numeric y-axis value used for positioning the point.
  final double value;

  /// Header text shown in the tooltip (e.g. "Oct").
  final String tooltipLabel;

  /// Body text shown in the tooltip (e.g. "Spend: \$1580").
  final String tooltipValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LineChartPoint &&
          other.xLabel == xLabel &&
          other.value == value &&
          other.tooltipLabel == tooltipLabel &&
          other.tooltipValue == tooltipValue;

  @override
  int get hashCode => Object.hash(xLabel, value, tooltipLabel, tooltipValue);
}

/// A line chart that renders trend data over time with axis labels and an
/// interactive tooltip.
///
/// Displays a connected line through [points], dashed horizontal grid lines
/// aligned to [yAxisLabels], and x-axis labels beneath the chart area.
/// Tapping a data point selects it and shows a tooltip with
/// [LineChartPoint.tooltipLabel] and [LineChartPoint.tooltipValue].
/// Tapping the same point again dismisses the tooltip.
class LineChart extends StatefulWidget {
  /// Creates a [LineChart].
  const LineChart({
    required this.points,
    required this.yAxisLabels,
    required this.minValue,
    required this.maxValue,
    super.key,
  });

  /// Data points defining the line path, axis labels, and tooltip content.
  final List<LineChartPoint> points;

  /// Pre-formatted y-axis labels ordered from bottom to top
  /// (e.g. `['\$0.0k', '\$1.5k', ..., '\$6.0k']`).
  final List<String> yAxisLabels;

  /// Minimum y value used for vertical scaling.
  final double minValue;

  /// Maximum y value used for vertical scaling.
  final double maxValue;

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  // Reserved pixel sizes matching fl_chart's AxisTitles reservedSize values.
  static const double _leftReserved = 48;
  static const double _bottomReserved = 44;

  int? _selectedIndex;

  void _handleTouch(
    fl.FlTouchEvent event,
    fl.LineTouchResponse? response,
  ) {
    if (widget.points.isEmpty) return;

    final touchedIndex = response?.lineBarSpots?.isNotEmpty == true
        ? response!.lineBarSpots!.first.spotIndex
        : null;

    final isDesktop =
        kIsWeb ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux;

    if (event is fl.FlPointerHoverEvent) {
      setState(() => _selectedIndex = touchedIndex);
    } else if (event is fl.FlPointerExitEvent) {
      setState(() => _selectedIndex = null);
    } else if (event is fl.FlTapUpEvent && !isDesktop) {
      setState(() {
        _selectedIndex = _selectedIndex == touchedIndex ? null : touchedIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();

    final yLabelStyle = theme.textTheme.labelSmall?.copyWith(
      color: colors?.onSurfaceMuted ?? _LineChartColors.label,
    );
    final xLabelStyle = theme.textTheme.labelSmall?.copyWith(
      color: colors?.onSurfaceMuted ?? _LineChartColors.label,
    );

    final gradient = colors?.geniusGradient ?? _LineChartColors.lineGradient;
    final gridColor = colors?.outlineVariant ?? _LineChartColors.grid;
    final indicatorColor =
        colors?.onSurfaceVariant ?? _LineChartColors.indicator;

    final spots = widget.points
        .asMap()
        .entries
        .map((e) => fl.FlSpot(e.key.toDouble(), e.value.value))
        .toList();

    final lineBarData = fl.LineChartBarData(
      spots: spots,
      isCurved: true,
      gradient: gradient,
      dotData: fl.FlDotData(
        getDotPainter: (spot, percent, barData, index) => _GradientDotPainter(
          gradient: gradient,
          radius: _LineChartDimensions.dotRadius,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(
        left: Spacing.xs,
        right: Spacing.sm,
        top: Spacing.xs,
        bottom: Spacing.xs,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final chartWidth = constraints.maxWidth - _leftReserved;
          final chartHeight = constraints.maxHeight - _bottomReserved;
          final n = widget.points.length;

          double spotX(int i) =>
              _leftReserved + (n <= 1 ? 0.0 : (i / (n - 1)) * chartWidth);

          double spotY(int i) {
            final range = widget.maxValue - widget.minValue;
            final normalized = range == 0
                ? 0.5
                : (widget.points[i].value - widget.minValue) / range;
            return (1 - normalized) * chartHeight;
          }

          return Stack(
            clipBehavior: Clip.none,
            children: [
              if (_selectedIndex != null)
                Positioned(
                  left: spotX(_selectedIndex!) - 0.5,
                  top: 0,
                  width: 1,
                  height: chartHeight,
                  child: IgnorePointer(
                    child: ColoredBox(color: indicatorColor),
                  ),
                ),
              fl.LineChart(
                fl.LineChartData(
                  minX: 0,
                  maxX: max<double>(1, (n - 1).toDouble()),
                  minY: widget.minValue,
                  maxY: widget.maxValue,
                  lineBarsData: [lineBarData],
                  gridData: _buildGridData(gridColor),
                  extraLinesData: fl.ExtraLinesData(
                    extraLinesOnTop: false,
                    horizontalLines: [
                      fl.HorizontalLine(
                        y: widget.minValue,
                        color: gridColor,
                        strokeWidth: 1,
                        dashArray: [4, 4],
                      ),
                    ],
                  ),
                  titlesData: _buildTitlesData(xLabelStyle, yLabelStyle),
                  borderData: fl.FlBorderData(show: false),
                  lineTouchData: fl.LineTouchData(
                    handleBuiltInTouches: false,
                    touchSpotThreshold: 100,
                    touchCallback: _handleTouch,
                  ),
                ),
              ),
              if (_selectedIndex != null)
                _TooltipCard(
                  point: widget.points[_selectedIndex!],
                  selectedX: spotX(_selectedIndex!),
                  selectedY: spotY(_selectedIndex!),
                  chartWidth: constraints.maxWidth,
                  chartHeight: chartHeight,
                  colors: colors,
                  textTheme: theme.textTheme,
                ),
            ],
          );
        },
      ),
    );
  }

  fl.FlGridData _buildGridData(Color gridColor) {
    final showGrid = widget.yAxisLabels.length >= 2;
    final interval = showGrid
        ? (widget.maxValue - widget.minValue) / (widget.yAxisLabels.length - 1)
        : null;
    return fl.FlGridData(
      show: showGrid,
      drawVerticalLine: false,
      horizontalInterval: interval,
      getDrawingHorizontalLine: (_) => fl.FlLine(
        color: gridColor,
        strokeWidth: 1,
        dashArray: [4, 4],
      ),
    );
  }

  fl.FlTitlesData _buildTitlesData(
    TextStyle? xStyle,
    TextStyle? yStyle,
  ) {
    final yInterval = widget.yAxisLabels.length >= 2
        ? (widget.maxValue - widget.minValue) / (widget.yAxisLabels.length - 1)
        : null;

    return fl.FlTitlesData(
      topTitles: const fl.AxisTitles(),
      rightTitles: const fl.AxisTitles(),
      bottomTitles: fl.AxisTitles(
        sideTitles: fl.SideTitles(
          showTitles: widget.points.isNotEmpty,
          reservedSize: _bottomReserved,
          interval: 1,
          getTitlesWidget: (value, meta) {
            final i = value.round();
            if (i < 0 || i >= widget.points.length || value != i.toDouble()) {
              return const SizedBox.shrink();
            }
            final isFirst = i == 0;
            final isLast = i == widget.points.length - 1;
            // Shift first label right so it starts at the point,
            // shift last label left so it ends at the point.
            final offset = isFirst
                ? const Offset(0.5, 0)
                : isLast
                ? const Offset(-0.5, 0)
                : Offset.zero;
            return fl.SideTitleWidget(
              meta: meta,
              space: Spacing.sm,
              child: FractionalTranslation(
                translation: offset,
                child: Text(widget.points[i].xLabel, style: xStyle),
              ),
            );
          },
        ),
      ),
      leftTitles: fl.AxisTitles(
        sideTitles: fl.SideTitles(
          showTitles: widget.yAxisLabels.isNotEmpty,
          reservedSize: _leftReserved,
          interval: yInterval,
          getTitlesWidget: (value, meta) {
            if (widget.yAxisLabels.length < 2 || yInterval == null) {
              return const SizedBox.shrink();
            }
            final i = ((value - widget.minValue) / yInterval).round();
            if (i < 0 || i >= widget.yAxisLabels.length) {
              return const SizedBox.shrink();
            }
            final expectedValue = widget.minValue + i * yInterval;
            if ((value - expectedValue).abs() > yInterval * 0.01) {
              return const SizedBox.shrink();
            }
            return fl.SideTitleWidget(
              meta: meta,
              space: Spacing.sm,
              child: Text(widget.yAxisLabels[i], style: yStyle),
            );
          },
        ),
      ),
    );
  }
}

class _TooltipCard extends StatelessWidget {
  const _TooltipCard({
    required this.point,
    required this.selectedX,
    required this.selectedY,
    required this.chartWidth,
    required this.chartHeight,
    required this.colors,
    required this.textTheme,
  });

  final LineChartPoint point;
  final double selectedX;
  final double selectedY;
  final double chartWidth;
  final double chartHeight;
  final AppColors? colors;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    const tooltipWidth = _LineChartDimensions.tooltipWidth;
    const offsetX = _LineChartDimensions.tooltipOffsetX;
    const offsetY = _LineChartDimensions.tooltipOffsetY;

    final left = selectedX + offsetX + tooltipWidth > chartWidth
        ? selectedX - tooltipWidth - offsetX
        : selectedX + offsetX;
    final top = (selectedY - offsetY).clamp(
      0.0,
      max<double>(0, chartHeight - _LineChartDimensions.tooltipHeight),
    );

    final monthStyle = textTheme.bodySmall?.copyWith(
      color: colors?.onSurfaceVariant ?? _LineChartColors.indicator,
    );
    final spendStyle = textTheme.bodySmall?.copyWith(
      color: colors?.onSurface ?? _LineChartColors.tooltipText,
    );

    return Positioned(
      left: left,
      top: top,
      child: IgnorePointer(
        child: Container(
          width: tooltipWidth,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.sm,
            vertical: Spacing.xs,
          ),
          decoration: BoxDecoration(
            color: colors?.surfaceContainer ?? _LineChartColors.tooltipBg,
            borderRadius: BorderRadius.circular(
              _LineChartDimensions.tooltipRadius,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(point.tooltipLabel, style: monthStyle),
              Text(point.tooltipValue, style: spendStyle),
            ],
          ),
        ),
      ),
    );
  }
}

abstract final class _LineChartDimensions {
  static const double dotRadius = 4;
  static const double tooltipWidth = 130;
  static const double tooltipHeight = 44;
  static const double tooltipRadius = 8;
  static const double tooltipOffsetX = Spacing.xs;
  static const double tooltipOffsetY = Spacing.xs;
}

abstract final class _LineChartColors {
  static const LinearGradient lineGradient = LinearGradient(
    colors: [Color(0xFF2461EB), Color(0xFFD4C6FB)],
  );
  static const Color grid = Color(0xFFE2E2E2);
  static const Color indicator = Color(0xFF5D5F5F);
  static const Color tooltipBg = Color(0xFFF0F1F1);
  static const Color tooltipText = Color(0xFF1A1C1C);
  static const Color label = Color(0xFF909191);
}

class _GradientDotPainter extends fl.FlDotPainter {
  const _GradientDotPainter({
    required this.gradient,
    required this.radius,
  });

  final LinearGradient gradient;
  final double radius;

  @override
  void draw(Canvas canvas, fl.FlSpot spot, Offset offsetInCanvas) {
    final rect = Rect.fromCircle(center: offsetInCanvas, radius: radius);
    canvas.drawCircle(
      offsetInCanvas,
      radius,
      Paint()..shader = gradient.createShader(rect),
    );
  }

  @override
  Size getSize(fl.FlSpot spot) => Size(radius * 2, radius * 2);

  @override
  Color get mainColor => gradient.colors.first;

  @override
  fl.FlDotPainter lerp(fl.FlDotPainter a, fl.FlDotPainter b, double t) => b;

  @override
  List<Object?> get props => [gradient, radius];
}
