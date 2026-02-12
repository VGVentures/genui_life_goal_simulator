import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  properties: {
    'name': S.string(description: 'Display user name.'),
    'recommendation': S.string(
      description:
          'Display brief recommendation for the user financial situation.',
    ),
  },
  required: ['name', 'recommendation'],
);

/// CatalogItem that renders an user summary overview card.
final userSummaryCardItem = CatalogItem(
  name: 'UserSummaryCard',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final name = json['name']! as String;
    final recommendation = json['recommendation']! as String;
    final context = ctx.buildContext;

    return Card(
      color: Theme.of(context).colorScheme.inversePrimary,
      // TODO(juanRodriguez17): Use spacing class when gets merged
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              recommendation,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  },
);
