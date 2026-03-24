import 'dart:math';

import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A line chart for visualizing trends over time '
      '(e.g. monthly spending, account balance history).',
  properties: {
    'points': S.list(
      description: 'Data points defining the line.',
      items: S.object(
        properties: {
          'xLabel': A2uiSchemas.stringReference(
            description: 'Label on the x-axis (e.g. "Jan", "Feb").',
          ),
          'value': S.number(description: 'Numeric y-axis value.'),
          'tooltipLabel': A2uiSchemas.stringReference(
            description: 'Header text shown in the tooltip.',
          ),
          'tooltipValue': A2uiSchemas.stringReference(
            description:
                r'Body text shown in the tooltip (e.g. "Spend: \$1580").',
          ),
        },
        required: ['xLabel', 'value', 'tooltipLabel', 'tooltipValue'],
      ),
    ),
    'yAxisLabels': S.list(
      description:
          'Pre-formatted y-axis labels ordered bottom to top '
          r'(e.g. ["\$0k", "\$2k", "\$4k"]).',
      items: S.string(),
    ),
  },
  required: ['points', 'yAxisLabels'],
);

/// CatalogItem that renders a [LineChart] widget.
///
/// Point string fields (`xLabel`, `tooltipLabel`, `tooltipValue`) support
/// data model bindings via `{"path": "..."}`.
final lineChartItem = CatalogItem(
  name: 'LineChart',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawPoints = json['points']! as List;
    final rawYLabels = json['yAxisLabels']! as List;

    // LineChart points need all values up front for min/max calculation,
    // so we resolve strings eagerly here. BoundString is used per-point
    // for reactivity if needed, but the chart itself requires static data.
    final points = rawPoints.cast<Map<String, Object?>>().map((p) {
      return LineChartPoint(
        xLabel: _resolveString(p['xLabel']),
        value: (p['value']! as num).toDouble(),
        tooltipLabel: _resolveString(p['tooltipLabel']),
        tooltipValue: _resolveString(p['tooltipValue']),
      );
    }).toList();

    final yAxisLabels = rawYLabels.cast<String>();

    final values = points.map((p) => p.value);
    final minValue = values.isEmpty ? 0.0 : values.reduce(min);
    final maxValue = values.isEmpty ? 0.0 : values.reduce(max);

    return SizedBox(
      height: 300,
      child: LineChart(
        points: points,
        yAxisLabels: yAxisLabels,
        minValue: minValue,
        maxValue: maxValue,
      ),
    );
  },
);

/// Resolves a value that may be a literal string or a path binding map.
/// For path bindings, returns the path as a fallback since LineChart
/// needs synchronous data.
String _resolveString(Object? value) {
  if (value is String) return value;
  if (value is Map && value.containsKey('path')) {
    return value['path'] as String? ?? '';
  }
  return value?.toString() ?? '';
}
