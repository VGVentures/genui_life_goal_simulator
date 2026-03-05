import 'dart:math' show max;

import 'package:finance_app/app/presentation.dart';
import 'package:flutter/foundation.dart' show immutable, listEquals;
import 'package:flutter/material.dart';

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
  int? _selectedIndex;

  List<double> get _normalizedValues {
    final range = widget.maxValue - widget.minValue;
    return widget.points.map((p) {
      if (range == 0) return 0.5;
      return (p.value - widget.minValue) / range;
    }).toList();
  }

  int _nearestIndex(double dx, double chartWidth) {
    if (widget.points.length == 1) return 0;
    var nearest = 0;
    var minDist = double.infinity;
    for (var i = 0; i < widget.points.length; i++) {
      final x = (i / (widget.points.length - 1)) * chartWidth;
      final dist = (dx - x).abs();
      if (dist < minDist) {
        minDist = dist;
        nearest = i;
      }
    }
    return nearest;
  }

  void _onTapDown(Offset position, double chartWidth) {
    if (widget.points.isEmpty) return;
    final index = _nearestIndex(position.dx, chartWidth);
    setState(() {
      _selectedIndex = _selectedIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final yLabelStyle = theme.textTheme.labelSmall?.copyWith(
      color: colors?.onSurfaceMuted ?? _LineChartColors.label,
    );
    final xLabelStyle = theme.textTheme.labelMedium?.copyWith(
      color: colors?.onSurfaceMuted ?? _LineChartColors.label,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _YAxisLabels(labels: widget.yAxisLabels, style: yLabelStyle),
        const SizedBox(width: Spacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final chartWidth = constraints.maxWidth;
                    final chartHeight = constraints.maxHeight;
                    final normalized = _normalizedValues;

                    double pointX(int i) => widget.points.length <= 1
                        ? chartWidth / 2
                        : (i / (widget.points.length - 1)) * chartWidth;

                    double pointY(int i) => (1 - normalized[i]) * chartHeight;

                    return GestureDetector(
                      onTapDown: (d) => _onTapDown(d.localPosition, chartWidth),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CustomPaint(
                            painter: _LineChartPainter(
                              normalizedValues: normalized,
                              gridLineCount: widget.yAxisLabels.length,
                              lineGradient:
                                  colors?.geniusGradient ??
                                  _LineChartColors.lineGradient,
                              gridColor:
                                  colors?.outlineVariant ??
                                  _LineChartColors.grid,
                              indicatorColor:
                                  colors?.onSurfaceVariant ??
                                  _LineChartColors.indicator,
                              selectedIndex: _selectedIndex,
                            ),
                            size: Size(chartWidth, chartHeight),
                          ),
                          if (_selectedIndex != null)
                            _TooltipCard(
                              point: widget.points[_selectedIndex!],
                              selectedX: pointX(_selectedIndex!),
                              selectedY: pointY(_selectedIndex!),
                              chartWidth: chartWidth,
                              colors: colors,
                              textTheme: theme.textTheme,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: Spacing.xxs),
              _XAxisLabels(
                labels: widget.points.map((p) => p.xLabel).toList(),
                style: xLabelStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _YAxisLabels extends StatelessWidget {
  const _YAxisLabels({required this.labels, required this.style});

  final List<String> labels;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: labels.reversed.map((l) => Text(l, style: style)).toList(),
    );
  }
}

class _XAxisLabels extends StatelessWidget {
  const _XAxisLabels({required this.labels, required this.style});

  final List<String> labels;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels.map((l) => Text(l, style: style)).toList(),
    );
  }
}

class _TooltipCard extends StatelessWidget {
  const _TooltipCard({
    required this.point,
    required this.selectedX,
    required this.selectedY,
    required this.chartWidth,
    required this.colors,
    required this.textTheme,
  });

  final LineChartPoint point;
  final double selectedX;
  final double selectedY;
  final double chartWidth;
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
    final top = max(0.0, selectedY - offsetY);

    final monthStyle = textTheme.bodySmall?.copyWith(
      color: colors?.onSurfaceVariant ?? _LineChartColors.indicator,
    );
    final spendStyle = textTheme.bodySmall?.copyWith(
      color: colors?.onSurface ?? _LineChartColors.tooltipText,
    );

    return Positioned(
      left: left,
      top: top,
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
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({
    required this.normalizedValues,
    required this.gridLineCount,
    required this.lineGradient,
    required this.gridColor,
    required this.indicatorColor,
    required this.selectedIndex,
  });

  final List<double> normalizedValues;
  final int gridLineCount;
  final LinearGradient lineGradient;
  final Color gridColor;
  final Color indicatorColor;
  final int? selectedIndex;

  Offset _pointAt(int index, Size size) {
    final x = normalizedValues.length <= 1
        ? size.width / 2
        : (index / (normalizedValues.length - 1)) * size.width;
    final y = (1 - normalizedValues[index]) * size.height;
    return Offset(x, y);
  }

  void _drawGridLines(Canvas canvas, Size size) {
    if (gridLineCount < 2) return;
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    const dashWidth = 4.0;
    const dashGap = 4.0;
    for (var i = 0; i < gridLineCount; i++) {
      final y = (i / (gridLineCount - 1)) * size.height;
      var x = 0.0;
      while (x < size.width) {
        canvas.drawLine(
          Offset(x, y),
          Offset((x + dashWidth).clamp(0, size.width), y),
          paint,
        );
        x += dashWidth + dashGap;
      }
    }
  }

  void _drawIndicatorLine(Canvas canvas, Size size) {
    final x = _pointAt(selectedIndex!, size).dx.roundToDouble();
    final paint = Paint()
      ..color = indicatorColor
      ..strokeWidth = 1;
    canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
  }

  void _drawLine(Canvas canvas, Size size) {
    if (normalizedValues.length < 2) return;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = lineGradient.createShader(rect)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final pts = List.generate(
      normalizedValues.length,
      (i) => _pointAt(i, size),
    );
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (var i = 0; i < pts.length - 1; i++) {
      final midX = (pts[i].dx + pts[i + 1].dx) / 2;
      path.cubicTo(
        midX,
        pts[i].dy,
        midX,
        pts[i + 1].dy,
        pts[i + 1].dx,
        pts[i + 1].dy,
      );
    }
    canvas.drawPath(path, paint);
  }

  void _drawDots(Canvas canvas, Size size) {
    for (var i = 0; i < normalizedValues.length; i++) {
      final point = _pointAt(i, size);
      final dotRect = Rect.fromCircle(
        center: point,
        radius: _LineChartDimensions.dotRadius,
      );
      final paint = Paint()
        ..shader = lineGradient.createShader(dotRect)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(point, _LineChartDimensions.dotRadius, paint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawGridLines(canvas, size);
    if (selectedIndex != null) _drawIndicatorLine(canvas, size);
    _drawLine(canvas, size);
    _drawDots(canvas, size);
  }

  @override
  bool shouldRepaint(_LineChartPainter old) =>
      !listEquals(old.normalizedValues, normalizedValues) ||
      old.selectedIndex != selectedIndex ||
      old.lineGradient != lineGradient ||
      old.gridColor != gridColor ||
      old.indicatorColor != indicatorColor;
}

abstract final class _LineChartDimensions {
  static const double dotRadius = 4;
  static const double tooltipWidth = 130;
  static const double tooltipRadius = 8;
  static const double tooltipOffsetX = 8;
  static const double tooltipOffsetY = 8;
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
