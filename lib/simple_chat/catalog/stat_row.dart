import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'DESKTOP ONLY: a horizontal row of labeled statistics with '
      'dividers between them. Each stat shows a large value with '
      'a label below it.',
  properties: {
    'component': S.string(enumValues: ['StatRow']),
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

extension type _StatRowData.fromMap(Map<String, Object?> _json) {
  List<Object?> get stats => _json['stats'] as List<Object?>;
}

extension type _StatEntry.fromMap(Map<String, Object?> _json) {
  Object get label => _json['label'] as Object;
  Object get value => _json['value'] as Object;
}

final statRow = CatalogItem(
  name: 'StatRow',
  isImplicitlyFlexible: true,
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": "StatRow",
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
    final data = _StatRowData.fromMap(
      context.data as Map<String, Object?>,
    );

    final List<_StatEntry> entries = data.stats
        .whereType<Map<String, Object?>>()
        .map(_StatEntry.fromMap)
        .toList();

    return _StatRowWidget(
      entries: entries,
      dataContext: context.dataContext,
    );
  },
);

class _StatRowWidget extends StatelessWidget {
  const _StatRowWidget({
    required this.entries,
    required this.dataContext,
  });

  final List<_StatEntry> entries;
  final DataContext dataContext;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              for (int i = 0; i < entries.length; i++) ...[
                if (i > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: VerticalDivider(
                      width: 1,
                      color: Theme.of(context)
                          .colorScheme
                          .outlineVariant,
                    ),
                  ),
                Expanded(
                  child: _StatCell(
                    entry: entries[i],
                    dataContext: dataContext,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.entry,
    required this.dataContext,
  });

  final _StatEntry entry;
  final DataContext dataContext;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BoundString(
          dataContext: dataContext,
          value: entry.value,
          builder: (context, value) => Text(
            value ?? '',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 4),
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
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
