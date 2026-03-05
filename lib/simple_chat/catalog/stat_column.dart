import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'MOBILE ONLY: a vertical stack of labeled statistics. '
      'Each stat shows a large value with a label below it.',
  properties: {
    'component': S.string(enumValues: ['StatColumn']),
    'stats': S.list(
      description: 'The list of statistics to display.',
      items: S.object(
        properties: {
          'label': A2uiSchemas.stringReference(
            description: 'The label for this stat.',
          ),
          'value': A2uiSchemas.stringReference(
            description: 'The displayed value for this stat.',
          ),
        },
        required: ['label', 'value'],
      ),
    ),
  },
  required: ['component', 'stats'],
);

extension type _StatColumnData.fromMap(Map<String, Object?> _json) {
  List<Object?> get stats => _json['stats'] as List<Object?>;
}

extension type _StatEntry.fromMap(Map<String, Object?> _json) {
  Object get label => _json['label'] as Object;
  Object get value => _json['value'] as Object;
}

final statColumn = CatalogItem(
  name: 'StatColumn',
  isImplicitlyFlexible: true,
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": "StatColumn",
          "stats": [
            { "label": "Population", "value": "2.1M" },
            { "label": "Area", "value": "105 km²" },
            { "label": "Founded", "value": "3rd century BC" }
          ]
        }
      ]
    ''',
  ],
  widgetBuilder: (context) {
    final data = _StatColumnData.fromMap(
      context.data as Map<String, Object?>,
    );

    final List<_StatEntry> entries = data.stats
        .whereType<Map<String, Object?>>()
        .map(_StatEntry.fromMap)
        .toList();

    return _StatColumnWidget(
      entries: entries,
      dataContext: context.dataContext,
    );
  },
);

class _StatColumnWidget extends StatelessWidget {
  const _StatColumnWidget({
    required this.entries,
    required this.dataContext,
  });

  final List<_StatEntry> entries;
  final DataContext dataContext;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < entries.length; i++) ...[
              if (i > 0) const Divider(),
              _StatTile(
                entry: entries[i],
                dataContext: dataContext,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.entry,
    required this.dataContext,
  });

  final _StatEntry entry;
  final DataContext dataContext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoundString(
            dataContext: dataContext,
            value: entry.value,
            builder: (context, value) => Text(
              value ?? '',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 2),
          BoundString(
            dataContext: dataContext,
            value: entry.label,
            builder: (context, label) => Text(
              label ?? '',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
