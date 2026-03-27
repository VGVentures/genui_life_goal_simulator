import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// A single data point in a [BarChartSeries].
@immutable
class BarChartPoint {
  /// Creates a [BarChartPoint].
  const BarChartPoint({
    required this.xLabel,
    required this.value,
    required this.tooltipLabel,
    required this.tooltipValue,
  });

  /// Label displayed on the x-axis (e.g. "Sep", "Oct").
  final String xLabel;

  /// Numeric y-axis value used for sizing the bar.
  final double value;

  /// Header text shown in the tooltip (e.g. "Oct").
  final String tooltipLabel;

  /// Body text shown in the tooltip (e.g. "Spend: \$1580").
  final String tooltipValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarChartPoint &&
          other.xLabel == xLabel &&
          other.value == value &&
          other.tooltipLabel == tooltipLabel &&
          other.tooltipValue == tooltipValue;

  @override
  int get hashCode => Object.hash(xLabel, value, tooltipLabel, tooltipValue);
}

/// A data series rendered as a set of bars in [AppBarChart].
@immutable
class BarChartSeries {
  /// Creates a [BarChartSeries].
  const BarChartSeries({
    required this.label,
    required this.color,
    required this.points,
  });

  /// Legend label for this series (e.g. "Reference 1").
  final String label;

  /// Color used to paint all bars in this series.
  final Color color;

  /// Ordered list of data points, one per x-axis group.
  final List<BarChartPoint> points;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarChartSeries &&
          other.label == label &&
          other.color == color &&
          listEquals(other.points, points);

  @override
  int get hashCode => Object.hash(label, color, Object.hashAll(points));
}

/// A grouped bar chart that renders multiple data series with a legend,
/// axis labels, and an interactive tooltip.
///
/// Displays grouped vertical bars for each x-axis category. Hovering
/// (desktop) or tapping (mobile) a bar shows a tooltip with
/// [BarChartPoint.tooltipLabel] and [BarChartPoint.tooltipValue].
/// The touched bar stays at full opacity; all other bars dim to 40%.
class AppBarChart extends StatefulWidget {
  /// Creates a [AppBarChart].
  const AppBarChart({
    required this.series,
    required this.yAxisLabels,
    required this.minValue,
    required this.maxValue,
    super.key,
  });

  /// Data series to render as grouped bars.
  final List<BarChartSeries> series;

  /// Pre-formatted y-axis labels ordered from bottom to top
  /// (e.g. `['\$0.0k', '\$2.0k', ..., '\$8.0k']`).
  final List<String> yAxisLabels;

  /// Minimum y value for vertical scaling.
  final double minValue;

  /// Maximum y value for vertical scaling.
  final double maxValue;

  @override
  State<AppBarChart> createState() => _BarChartState();
}

class _BarChartState extends State<AppBarChart> {
  int? _touchedGroupIndex;
  int? _touchedRodIndex;

  bool get _isMobile => Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

  int get _numGroups {
    if (widget.series.isEmpty) return 0;
    return widget.series.map((s) => s.points.length).reduce(max);
  }

  void _handleTouch(FlTouchEvent event, BarTouchResponse? response) {
    final spot = response?.spot;
    final groupIndex = spot?.touchedBarGroupIndex;
    final rodIndex = spot?.touchedRodDataIndex;

    if (event is FlPointerHoverEvent) {
      setState(() {
        _touchedGroupIndex = groupIndex;
        _touchedRodIndex = rodIndex;
      });
    } else if (event is FlPointerExitEvent) {
      setState(() {
        _touchedGroupIndex = null;
        _touchedRodIndex = null;
      });
    } else if (event is FlTapUpEvent && _isMobile) {
      setState(() {
        if (_touchedGroupIndex == groupIndex && _touchedRodIndex == rodIndex) {
          _touchedGroupIndex = null;
          _touchedRodIndex = null;
        } else {
          _touchedGroupIndex = groupIndex;
          _touchedRodIndex = rodIndex;
        }
      });
    }
  }

  List<BarChartGroupData> _buildGroups(
    double barWidth,
    BorderRadius borderRadius,
  ) {
    final numGroups = _numGroups;
    final hasSelection = _touchedGroupIndex != null && _touchedRodIndex != null;

    return List.generate(numGroups, (groupIndex) {
      return BarChartGroupData(
        x: groupIndex,
        barRods: List.generate(widget.series.length, (rodIndex) {
          final s = widget.series[rodIndex];
          final value = groupIndex < s.points.length
              ? s.points[groupIndex].value
              : 0.0;
          final isSelected =
              groupIndex == _touchedGroupIndex && rodIndex == _touchedRodIndex;
          final color = hasSelection && !isSelected
              ? s.color.withValues(alpha: 0.4)
              : s.color;
          return BarChartRodData(
            toY: value,
            color: color,
            width: barWidth,
            borderRadius: borderRadius,
          );
        }),
        barsSpace: _BarChartDimensions.barsSpace,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.series.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              bottom: Spacing.lg,
            ),
            child: Wrap(
              spacing: Spacing.md,
              children: [
                for (final s in widget.series)
                  _LegendItem(
                    series: s,
                    textTheme: theme.textTheme,
                    colors: colors,
                  ),
              ],
            ),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              left: Spacing.xs,
              right: Spacing.sm,
              bottom: Spacing.xs,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxBarWidth = responsiveValue(
                  context,
                  mobile: _BarChartDimensions.barWidthMobile,
                  desktop: _BarChartDimensions.barWidthDesktop,
                );
                final minBarWidth = responsiveValue(
                  context,
                  mobile: _BarChartDimensions.barWidthMinMobile,
                  desktop: _BarChartDimensions.barWidthMinDesktop,
                );
                final numSeries = widget.series.length;
                final numGroups = _numGroups;
                final barWidth = numGroups > 0 && numSeries > 0
                    ? (() {
                        final totalBarsSpace =
                            numGroups *
                            (numSeries - 1) *
                            _BarChartDimensions.barsSpace;
                        final totalGroupGaps =
                            _BarChartDimensions.minGroupGap * (numGroups + 1);
                        final availableForBars =
                            constraints.maxWidth -
                            totalBarsSpace -
                            totalGroupGaps;
                        final computed =
                            availableForBars / (numGroups * numSeries);
                        return computed.clamp(minBarWidth, maxBarWidth);
                      })()
                    : maxBarWidth;
                final barBorderRadius = responsiveValue(
                  context,
                  mobile: const BorderRadius.vertical(
                    top: Radius.circular(_BarChartDimensions.barRadiusMobile),
                  ),
                  desktop: const BorderRadius.vertical(
                    top: Radius.circular(_BarChartDimensions.barRadiusDesktop),
                  ),
                );

                final rawInterval = widget.yAxisLabels.length >= 2
                    ? (widget.maxValue - widget.minValue) /
                          (widget.yAxisLabels.length - 1)
                    : null;
                final yInterval = rawInterval != null && rawInterval > 0
                    ? rawInterval
                    : null;

                final labelStyle = theme.textTheme.labelSmall?.copyWith(
                  color: colors?.onSurfaceMuted ?? _BarChartColors.label,
                );
                final gridColor =
                    colors?.outlineVariant ?? _BarChartColors.grid;

                return BarChart(
                  BarChartData(
                    minY: widget.minValue,
                    maxY: widget.maxValue,
                    barGroups: _buildGroups(barWidth, barBorderRadius),
                    alignment: BarChartAlignment.spaceEvenly,
                    gridData: FlGridData(
                      show: widget.yAxisLabels.length >= 2 && yInterval != null,
                      drawVerticalLine: false,
                      horizontalInterval: yInterval,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: gridColor,
                        strokeWidth: 1,
                        dashArray: [4, 4],
                      ),
                    ),
                    extraLinesData: ExtraLinesData(
                      extraLinesOnTop: false,
                      horizontalLines: [
                        HorizontalLine(
                          y: widget.minValue,
                          color: gridColor,
                          strokeWidth: 1,
                          dashArray: [4, 4],
                        ),
                        HorizontalLine(
                          y: widget.maxValue,
                          color: gridColor,
                          strokeWidth: 1,
                          dashArray: [4, 4],
                        ),
                      ],
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: numGroups > 0,
                          reservedSize: responsiveValue(
                            context,
                            mobile: _BarChartDimensions.bottomReservedMobile,
                            desktop: _BarChartDimensions.bottomReserved,
                          ),
                          getTitlesWidget: (value, meta) {
                            final i = value.round();
                            if (i < 0 ||
                                i >= numGroups ||
                                value != i.toDouble()) {
                              return const SizedBox.shrink();
                            }
                            final xLabel =
                                widget.series.isNotEmpty &&
                                    i < widget.series.first.points.length
                                ? widget.series.first.points[i].xLabel
                                : '';
                            final isMobile = Breakpoints.isMobile(
                              MediaQuery.sizeOf(context).width,
                            );
                            return SideTitleWidget(
                              meta: meta,
                              space: Spacing.sm,
                              child: isMobile
                                  ? Transform.rotate(
                                      angle: -pi / 4,
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        xLabel,
                                        style: labelStyle,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  : Text(xLabel, style: labelStyle),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: widget.yAxisLabels.isNotEmpty,
                          reservedSize: _BarChartDimensions.leftReserved,
                          interval: yInterval,
                          getTitlesWidget: (value, meta) {
                            if (widget.yAxisLabels.length < 2 ||
                                yInterval == null) {
                              return const SizedBox.shrink();
                            }
                            final i = ((value - widget.minValue) / yInterval)
                                .round();
                            if (i < 0 || i >= widget.yAxisLabels.length) {
                              return const SizedBox.shrink();
                            }
                            final expected = widget.minValue + i * yInterval;
                            if ((value - expected).abs() > yInterval * 0.01) {
                              return const SizedBox.shrink();
                            }
                            return SideTitleWidget(
                              meta: meta,
                              space: Spacing.sm,
                              child: Text(
                                widget.yAxisLabels[i],
                                style: labelStyle,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barTouchData: BarTouchData(
                      handleBuiltInTouches: true,
                      touchCallback: _handleTouch,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) =>
                            colors?.surfaceContainer ??
                            _BarChartColors.tooltipBg,
                        tooltipBorderRadius: BorderRadius.circular(
                          _BarChartDimensions.tooltipRadius,
                        ),
                        tooltipPadding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                          vertical: Spacing.xs,
                        ),
                        fitInsideHorizontally: true,
                        fitInsideVertically: true,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          if (rodIndex >= widget.series.length) return null;
                          final s = widget.series[rodIndex];
                          if (groupIndex >= s.points.length) return null;
                          final point = s.points[groupIndex];
                          return BarTooltipItem(
                            '${point.tooltipLabel}\n',
                            (theme.textTheme.bodySmall ?? const TextStyle())
                                .copyWith(
                                  color:
                                      colors?.onSurfaceVariant ??
                                      _BarChartColors.tooltipLabel,
                                ),
                            children: [
                              TextSpan(
                                text: point.tooltipValue,
                                style:
                                    (theme.textTheme.bodySmall ??
                                            const TextStyle())
                                        .copyWith(
                                          color:
                                              colors?.onSurface ??
                                              _BarChartColors.tooltipText,
                                        ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.series,
    required this.textTheme,
    required this.colors,
  });

  final BarChartSeries series;
  final TextTheme textTheme;
  final AppColors? colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: _BarChartDimensions.legendDotSize,
          height: _BarChartDimensions.legendDotSize,
          decoration: BoxDecoration(
            color: series.color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: Spacing.xxs),
        Text(
          series.label,
          style: textTheme.bodyMedium?.copyWith(
            color: colors?.onSurfaceVariant ?? _BarChartColors.label,
          ),
        ),
      ],
    );
  }
}

abstract final class _BarChartDimensions {
  static const double leftReserved = 48;
  static const double bottomReserved = 44;
  static const double bottomReservedMobile = 80;
  static const double barWidthDesktop = 46;
  static const double barWidthMinDesktop = 8;
  static const double barWidthMobile = 18;
  static const double barWidthMinMobile = 6;
  static const double barRadiusDesktop = 8;
  static const double barRadiusMobile = 10;
  static const double barsSpace = 4;
  static const double minGroupGap = 16;
  static const double legendDotSize = 8;
  static const double tooltipRadius = 8;
}

abstract final class _BarChartColors {
  static const Color grid = Color(0xFFE2E2E2);
  static const Color tooltipBg = Color(0xFFF0F1F1);
  static const Color tooltipLabel = Color(0xFF5D5F5F);
  static const Color tooltipText = Color(0xFF1A1C1C);
  static const Color label = Color(0xFF909191);
}
