import 'package:finance_app/app/presentation/spacing.dart';
import 'package:finance_app/app/presentation/widgets/horizontal_bar.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _itemSchema = S.object(
  properties: {
    'category': S.string(
      description: 'Spending category label (e.g. "Dining").',
    ),
    'amount': S.string(
      description: r'Formatted amount string (e.g. "$420").',
    ),
    'progress': S.number(
      description: 'Bar fill ratio from 0.0 (empty) to 1.0 (full).',
    ),
    'comparisonLabel': S.string(
      description: 'Sub-label shown below the bar (e.g. "Groceries").',
    ),
    'comparisonValue': S.string(
      description:
          'Formatted comparison value with sign and % (e.g. "+10%", "-5%"). '
          'Negative values are shown in red, positive in green.',
    ),
  },
  required: [
    'category',
    'amount',
    'progress',
    'comparisonLabel',
    'comparisonValue',
  ],
);

final _schema = S.object(
  properties: {
    'items': S.list(
      description:
          'List of horizontal bars to display stacked vertically. '
          'All items should show the same type of info.',
      items: _itemSchema,
      minItems: 1,
    ),
  },
  required: ['items'],
);

/// CatalogItem that renders one or more HorizontalBar widgets stacked
/// vertically.
final horizontalBarItem = CatalogItem(
  name: 'HorizontalBar',
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
  return HorizontalBar(
    category: item['category']! as String,
    amount: item['amount']! as String,
    progress: (item['progress']! as num).toDouble(),
    comparisonLabel: item['comparisonLabel']! as String,
    comparisonValue: item['comparisonValue']! as String,
  );
}
