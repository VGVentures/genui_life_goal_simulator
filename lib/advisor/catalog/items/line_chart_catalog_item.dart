import 'dart:math';

import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
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
          'xLabel': S.string(
            description: 'Label on the x-axis (e.g. "Jan", "Feb").',
          ),
          'value': S.number(description: 'Numeric y-axis value.'),
          'tooltipLabel': S.string(
            description: 'Header text shown in the tooltip.',
          ),
          'tooltipValue': S.string(
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
final lineChartItem = CatalogItem(
  name: 'LineChart',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawPoints = json['points']! as List;
    final rawYLabels = json['yAxisLabels']! as List;

    final points = rawPoints.cast<Map<String, Object?>>().map((p) {
      return LineChartPoint(
        xLabel: p['xLabel']! as String,
        value: (p['value']! as num).toDouble(),
        tooltipLabel: p['tooltipLabel']! as String,
        tooltipValue: p['tooltipValue']! as String,
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
