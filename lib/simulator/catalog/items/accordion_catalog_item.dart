import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _itemSchema = S.object(
  description: 'A single action item displayed inside the accordion.',
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
      'A collapsible panel that groups related financial action items '
      'under a header (e.g. "Debt Reduction Steps", "Savings Actions"). '
      'String fields in items support data model bindings via '
      '{"path": "..."} for reactive values. '
      'Use the optional child property on items to add a trailing '
      'widget (e.g. an AppButton) for per-item actions.',
  properties: {
    'title': A2uiSchemas.stringReference(
      description: 'Header text displayed in the accordion.',
    ),
    'items': S.list(
      description:
          'Ordered list of action items shown when the accordion is expanded.',
      items: _itemSchema,
    ),
    'isExpanded': S.boolean(
      description:
          'Whether the accordion starts in expanded state. Defaults to false.',
    ),
  },
  required: ['title', 'items'],
);

/// CatalogItem that renders an expandable/collapsible accordion panel.
///
/// String fields (`title`, item `title`, `subtitle`, `amount`, `delta`)
/// support data model bindings via `{"path": "..."}` for reactive values.
final accordionItem = CatalogItem(
  name: 'AppAccordion',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;

    final titleValue = json['title']!;
    final rawItems = json['items']! as List<Object?>;
    final isExpanded = (json['isExpanded'] as bool?) ?? false;

    return BoundString(
      dataContext: ctx.dataContext,
      value: titleValue,
      builder: (context, title) {
        return AppAccordion(
          title: title ?? '',
          isExpanded: isExpanded,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: rawItems.cast<Map<String, Object?>>().indexed.map((
              entry,
            ) {
              final (index, item) = entry;
              final childId = item['child'] as String?;
              return _BoundActionItem(
                key: ValueKey('accordion_item_$index'),
                dataContext: ctx.dataContext,
                itemData: item,
                trailing: childId != null ? ctx.buildChild(childId) : null,
              );
            }).toList(),
          ),
        );
      },
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
                      trailing: trailing,
                      delta: delta,
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
