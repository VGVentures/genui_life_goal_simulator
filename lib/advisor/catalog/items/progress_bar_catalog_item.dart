import 'package:finance_app/app/presentation/spacing.dart';
import 'package:finance_app/app/presentation/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _itemSchema = S.object(
  properties: {
    'title': A2uiSchemas.stringReference(
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
      children: rawItems.cast<Map<String, Object?>>().indexed.map((entry) {
        final (index, item) = entry;
        return Padding(
          key: ValueKey('pbar_$index'),
          padding: EdgeInsets.only(
            top: index > 0 ? Spacing.md : 0,
          ),
          child: BoundString(
            dataContext: ctx.dataContext,
            value: item['title'],
            builder: (context, title) {
              return ProgressBar(
                title: title ?? '',
                value: (item['value']! as num).toDouble(),
                total: (item['total']! as num).toDouble(),
              );
            },
          ),
        );
      }).toList(),
    );
  },
);
