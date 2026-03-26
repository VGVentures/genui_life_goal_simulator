import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A table comparing spending between last month and this month '
      'by category, showing amounts and percentage deltas.',
  properties: {
    'items': S.list(
      description: 'Rows of the comparison table.',
      items: S.object(
        properties: {
          'label': A2uiSchemas.stringReference(
            description: 'Category name (e.g. "Groceries").',
          ),
          'lastMonthAmount': S.number(
            description: "Last month's spend as a numeric value.",
          ),
          'actualMonthAmount': S.number(
            description: "This month's spend as a numeric value.",
          ),
        },
        required: ['label', 'lastMonthAmount', 'actualMonthAmount'],
      ),
    ),
  },
  required: ['items'],
);

/// CatalogItem that renders a [ComparisonTable] widget.
final comparisonTableItem = CatalogItem(
  name: 'ComparisonTable',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawItems = json['items']! as List;

    final items = rawItems.cast<Map<String, Object?>>().map((row) {
      return ComparisonTableItem(
        label: _resolveString(row['label']),
        lastMonthAmount: (row['lastMonthAmount']! as num).toDouble(),
        actualMonthAmount: (row['actualMonthAmount']! as num).toDouble(),
      );
    }).toList();

    return ComparisonTable(items: items);
  },
);

String _resolveString(Object? value) {
  if (value is String) return value;
  return value?.toString() ?? '';
}
