import 'dart:math';

import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

const _colorValues = [
  'pink',
  'mustard',
  'orange',
  'brightOrange',
  'deepRed',
  'plum',
  'aqua',
  'lightBlue',
  'lightOlive',
  'darkOlive',
  'emerald',
];

final _pointSchema = S.object(
  properties: {
    'xLabel': A2uiSchemas.stringReference(
      description: 'Label on the x-axis (e.g. "Jan", "Feb").',
    ),
    'value': S.number(description: 'Numeric y-axis value.'),
    'tooltipLabel': A2uiSchemas.stringReference(
      description: 'Header text shown in the tooltip.',
    ),
    'tooltipValue': A2uiSchemas.stringReference(
      description: r'Body text shown in the tooltip (e.g. "Spend: \$1580").',
    ),
  },
  required: ['xLabel', 'value', 'tooltipLabel', 'tooltipValue'],
);

final _seriesSchema = S.object(
  properties: {
    'label': S.string(description: 'Legend label for this series.'),
    'color': S.string(
      description: 'Bar color for this series.',
      enumValues: _colorValues,
    ),
    'points': S.list(
      description: 'Data points for this series, one per x-axis group.',
      items: _pointSchema,
    ),
  },
  required: ['label', 'color', 'points'],
);

final _schema = S.object(
  description:
      'A grouped bar chart for comparing discrete values across multiple '
      'series and categories (e.g. monthly spending by account, '
      'budget vs. actual by category). '
      'Use LineChart instead when the goal is to show a continuous trend '
      'over time for a single series.',
  properties: {
    'series': S.list(
      description:
          'Data series to render as grouped bars. Use 1–3 series for '
          'best readability. Each series shares the same x-axis groups.',
      items: _seriesSchema,
      minItems: 1,
    ),
    'yAxisLabels': S.list(
      description:
          'Pre-formatted y-axis labels ordered bottom to top '
          r'(e.g. ["\$0k", "\$2k", "\$4k", "\$6k", "\$8k"]).',
      items: S.string(),
    ),
  },
  required: ['series', 'yAxisLabels'],
);

Color _resolveColor(String value, AppColors? colors) {
  return switch (value) {
        'mustard' => colors?.mustardColor,
        'orange' => colors?.orangeColor,
        'brightOrange' => colors?.brightOrangeColor,
        'deepRed' => colors?.deepRedColor,
        'plum' => colors?.plumColor,
        'aqua' => colors?.aquaColor,
        'lightBlue' => colors?.lightBlueColor,
        'lightOlive' => colors?.lightOliveColor,
        'darkOlive' => colors?.darkOliveColor,
        'emerald' => colors?.emeraldColor,
        _ => colors?.pinkColor,
      } ??
      const Color(0xFFE98AD4);
}

String _resolveString(Object? value) {
  if (value is String) return value;
  if (value is Map && value.containsKey('path')) {
    return value['path'] as String? ?? '';
  }
  return value?.toString() ?? '';
}

/// CatalogItem that renders a [BarChart] widget.
///
/// Series string fields (`label`) and point string fields (`xLabel`,
/// `tooltipLabel`, `tooltipValue`) support data model bindings via
/// `{"path": "..."}`.
final barChartItem = CatalogItem(
  name: 'BarChart',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawSeries = json['series']! as List;
    final rawYLabels = json['yAxisLabels']! as List;

    final yAxisLabels = rawYLabels.cast<String>();

    return Builder(
      builder: (context) {
        final colors = Theme.of(context).extension<AppColors>();

        final series = rawSeries.cast<Map<String, Object?>>().map((s) {
          final rawPoints = s['points']! as List;
          final points = rawPoints.cast<Map<String, Object?>>().map((p) {
            return BarChartPoint(
              xLabel: _resolveString(p['xLabel']),
              value: (p['value']! as num).toDouble(),
              tooltipLabel: _resolveString(p['tooltipLabel']),
              tooltipValue: _resolveString(p['tooltipValue']),
            );
          }).toList();

          return BarChartSeries(
            label: _resolveString(s['label']),
            color: _resolveColor(s['color']! as String, colors),
            points: points,
          );
        }).toList();

        final allValues = series.expand((s) => s.points.map((p) => p.value));
        final maxValue = allValues.isEmpty ? 0.0 : allValues.reduce(max);

        return SizedBox(
          height: 291,
          child: BarChart(
            series: series,
            yAxisLabels: yAxisLabels,
            minValue: 0,
            maxValue: maxValue,
          ),
        );
      },
    );
  },
);
