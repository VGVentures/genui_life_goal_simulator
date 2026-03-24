import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

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

final _itemSchema = S.object(
  properties: {
    'label': S.string(
      description: 'Category name (e.g. "Groceries").',
    ),
    'value': S.number(
      description: 'Numeric value used to compute the segment arc proportion.',
    ),
    'amount': S.string(
      description: r'Pre-formatted display string (e.g. "$1,420").',
    ),
    'color': S.string(
      description: 'Segment color.',
      enumValues: _colorValues,
    ),
  },
  required: ['label', 'value', 'amount', 'color'],
);

final _schema = S.object(
  description:
      'An interactive donut (pie) chart with a color-coded legend. '
      'Use when showing part-to-whole relationships '
      '(e.g. spending by category, portfolio allocation).',
  properties: {
    'items': S.list(
      description: 'Segments to display. Use 3–7 items for best readability.',
      items: _itemSchema,
      minItems: 2,
    ),
    'totalLabel': S.string(
      description:
          'Label shown in the donut center when no segment is selected '
          '(e.g. "Total Spending").',
    ),
    'totalAmount': S.string(
      description:
          'Formatted total shown in the center when nothing is selected '
          r'(e.g. "$4,225").',
    ),
  },
  required: ['items', 'totalLabel', 'totalAmount'],
);

Color? _resolveColor(String value, AppColors? colors) {
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
  };
}

/// CatalogItem that renders a [PieChartComponent].
final pieChartItem = CatalogItem(
  name: 'PieChart',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawItems = json['items']! as List;
    final totalLabel = json['totalLabel']! as String;
    final totalAmount = json['totalAmount']! as String;

    return Builder(
      builder: (context) {
        final colors = Theme.of(context).extension<AppColors>();

        final items = rawItems.cast<Map<String, Object?>>().map((item) {
          return PieChartItem(
            label: item['label']! as String,
            value: (item['value']! as num).toDouble(),
            amount: item['amount']! as String,
            color: _resolveColor(item['color']! as String, colors),
          );
        }).toList();

        return PieChartComponent(
          items: items,
          totalLabel: totalLabel,
          totalAmount: totalAmount,
        );
      },
    );
  },
);
