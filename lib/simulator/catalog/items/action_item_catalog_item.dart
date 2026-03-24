import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _itemSchema = S.object(
  description:
      'A single financial task, recommendation, or transaction highlight. '
      'String fields support data model bindings via {"path": "..."}.',
  properties: {
    'title': A2uiSchemas.stringReference(
      description: 'Primary label, e.g. "Restaurant".',
    ),
    'subtitle': A2uiSchemas.stringReference(
      description: 'Secondary label, e.g. "Dining • Feb 18".',
    ),
    'amount': A2uiSchemas.stringReference(
      description: r'Monetary value shown on the right, e.g. "$450".',
    ),
    'delta': A2uiSchemas.stringReference(
      description: 'Optional change indicator, e.g. "+28%".',
    ),
    'child': S.string(
      description:
          'Optional component ID rendered as a trailing widget '
          '(e.g. an AppButton). Use for per-item actions.',
    ),
  },
  required: ['title', 'subtitle', 'amount'],
);

final _schema = S.object(
  description:
      'A list of financial tasks, recommendations, or transaction highlights. '
      'Stack between 2 and 10 items. '
      'Add delta when showing change over time (e.g. "+28%"). '
      'Use the optional child property to add a trailing widget '
      '(e.g. an AppButton) to individual items.',
  properties: {
    'items': S.list(
      items: _itemSchema,
      description: 'Ordered list of action items to display.',
    ),
  },
  required: ['items'],
);

/// CatalogItem that renders a group of financial action items.
final actionItemsGroupItem = CatalogItem(
  name: 'ActionItemsGroup',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawItems = json['items']! as List<Object?>;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rawItems.cast<Map<String, Object?>>().indexed.map((entry) {
        final (index, item) = entry;
        final childId = item['child'] as String?;
        return _BoundActionItem(
          key: ValueKey('action_item_$index'),
          dataContext: ctx.dataContext,
          itemData: item,
          trailing: childId != null ? ctx.buildChild(childId) : null,
        );
      }).toList(),
    );
  },
);

class _BoundActionItem extends StatelessWidget {
  const _BoundActionItem({
    required this.dataContext,
    required this.itemData,
    this.trailing,
    super.key,
  });

  final DataContext dataContext;
  final Map<String, Object?> itemData;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return BoundString(
      dataContext: dataContext,
      value: itemData['title'],
      builder: (context, title) {
        return BoundString(
          dataContext: dataContext,
          value: itemData['subtitle'],
          builder: (context, subtitle) {
            return BoundString(
              dataContext: dataContext,
              value: itemData['amount'],
              builder: (context, amount) {
                final deltaValue = itemData['delta'];
                if (deltaValue == null) {
                  return ActionItem(
                    title: title ?? '',
                    subtitle: subtitle ?? '',
                    amount: amount ?? '',
                    trailing: trailing,
                  );
                }
                return BoundString(
                  dataContext: dataContext,
                  value: deltaValue,
                  builder: (context, delta) {
                    return ActionItem(
                      title: title ?? '',
                      subtitle: subtitle ?? '',
                      amount: amount ?? '',
                      delta: delta,
                      trailing: trailing,
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
