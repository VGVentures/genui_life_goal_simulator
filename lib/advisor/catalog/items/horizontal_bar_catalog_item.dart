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
      description:
          r'Actual ÷ reference as a decimal (e.g. $420 ÷ $400 = 1.05). '
          'The bar clamps at 1.0 visually.',
    ),
    'comparisonLabel': S.string(
      description:
          'Short label for the reference row '
          '(e.g. "vs last month", "vs category avg").',
    ),
    'comparisonValue': S.string(
      description:
          'Signed % change vs the reference. '
          'Positive = spent more than reference → shown in red. '
          'Negative = spent less → shown in green. '
          'Always include the sign (e.g. "+5%", "-12%").',
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
  description:
      'Spending categories compared against a reference (e.g. last month, '
      'category average). Use when the reference is a prior period or an '
      'external benchmark, not a fixed budget limit. '
      'All items must use the same type of reference.',
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
