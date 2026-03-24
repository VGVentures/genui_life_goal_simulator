import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/spacing.dart';
import 'package:genui_life_goal_simulator/design_system/widgets/horizontal_bar.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _itemSchema = S.object(
  properties: {
    'category': A2uiSchemas.stringReference(
      description: 'Spending category label (e.g. "Dining").',
    ),
    'amount': A2uiSchemas.stringReference(
      description: r'Formatted amount string (e.g. "$420").',
    ),
    'progress': S.number(
      description:
          r'Actual ÷ reference as a decimal (e.g. $420 ÷ $400 = 1.05). '
          'The bar clamps at 1.0 visually.',
    ),
    'comparisonLabel': A2uiSchemas.stringReference(
      description:
          'Short label for the reference row '
          '(e.g. "vs last month", "vs category avg").',
    ),
    'comparisonValue': A2uiSchemas.stringReference(
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
      children: rawItems.cast<Map<String, Object?>>().indexed.map((entry) {
        final (index, item) = entry;
        return Padding(
          key: ValueKey('hbar_$index'),
          padding: EdgeInsets.only(
            top: index > 0 ? Spacing.md : 0,
          ),
          child: _BoundHorizontalBar(
            dataContext: ctx.dataContext,
            itemData: item,
          ),
        );
      }).toList(),
    );
  },
);

class _BoundHorizontalBar extends StatelessWidget {
  const _BoundHorizontalBar({
    required this.dataContext,
    required this.itemData,
  });

  final DataContext dataContext;
  final Map<String, Object?> itemData;

  @override
  Widget build(BuildContext context) {
    return BoundString(
      dataContext: dataContext,
      value: itemData['category'],
      builder: (context, category) {
        return BoundString(
          dataContext: dataContext,
          value: itemData['amount'],
          builder: (context, amount) {
            return BoundString(
              dataContext: dataContext,
              value: itemData['comparisonLabel'],
              builder: (context, comparisonLabel) {
                return BoundString(
                  dataContext: dataContext,
                  value: itemData['comparisonValue'],
                  builder: (context, comparisonValue) {
                    return HorizontalBar(
                      category: category ?? '',
                      amount: amount ?? '',
                      progress: (itemData['progress']! as num).toDouble(),
                      comparisonLabel: comparisonLabel ?? '',
                      comparisonValue: comparisonValue ?? '',
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
