import 'package:finance_app/app/presentation/spacing.dart';
import 'package:finance_app/app/presentation/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _itemSchema = S.object(
  properties: {
    'title': S.string(
      description: 'Category label displayed above the bar (e.g. "Dining").',
    ),
    'value': S.number(
      description: 'Current amount spent or used (e.g. 420).',
    ),
    'total': S.number(
      description:
          'Budget or maximum value (e.g. 400). '
          'Bar turns green below 65%, orange at 65–85%, red above 85%.',
    ),
  },
  required: ['title', 'value', 'total'],
);

final _schema = S.object(
  description:
      'Spending categories vs. a fixed budget limit. '
      'Use when the user has a defined budget per category. '
      'Color codes automatically: green < 65%, orange 65–85%, red > 85%.',
  properties: {
    'items': S.list(
      description: 'List of progress bars to display stacked vertically.',
      items: _itemSchema,
      minItems: 1,
    ),
  },
  required: ['items'],
);

/// CatalogItem that renders one or more ProgressBar widgets stacked vertically.
final progressBarItem = CatalogItem(
  name: 'ProgressBar',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawItems = json['items']! as List<Object?>;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < rawItems.length; i++) ...[
          if (i > 0) const SizedBox(height: Spacing.md),
          _buildBar(rawItems[i]! as Map<String, Object?>),
        ],
      ],
    );
  },
);

Widget _buildBar(Map<String, Object?> item) {
  return ProgressBar(
    title: item['title']! as String,
    value: (item['value']! as num).toDouble(),
    total: (item['total']! as num).toDouble(),
  );
}
