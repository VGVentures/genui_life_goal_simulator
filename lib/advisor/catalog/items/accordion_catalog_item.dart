import 'package:finance_app/app/presentation.dart';
import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
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
    'buttonLabel': S.string(
      description:
          'CTA button label. Required when buttonVariant is not "none".',
    ),
    'buttonVariant': S.string(
      description: 'Button style to render. Defaults to "none".',
      enumValues: ['primary', 'secondary', 'none'],
    ),
    'action': A2uiSchemas.action(
      description:
          'The action to perform when the item button is tapped. '
          'Required when buttonVariant is not "none".',
    ),
  },
  required: ['title', 'subtitle', 'amount'],
);

final _schema = S.object(
  description:
      'A collapsible panel that groups related financial action items '
      'under a header (e.g. "Debt Reduction Steps", "Savings Actions"). '
      'String fields in items support data model bindings via '
      '{"path": "..."} for reactive values.',
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

ActionItemButtonVariant _parseVariant(String? value) {
  return switch (value) {
    'primary' => ActionItemButtonVariant.primary,
    'secondary' => ActionItemButtonVariant.secondary,
    _ => ActionItemButtonVariant.none,
  };
}

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
            children: rawItems
                .cast<Map<String, Object?>>()
                .indexed
                .map((entry) {
                  final (index, item) = entry;
                  return _BoundActionItem(
                    key: ValueKey('accordion_item_$index'),
                    dataContext: ctx.dataContext,
                    itemData: item,
                    dispatchEvent: ctx.dispatchEvent,
                    componentId: ctx.id,
                  );
                })
                .toList(),
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
    required this.dispatchEvent,
    required this.componentId,
    super.key,
  });

  final DataContext dataContext;
  final Map<String, Object?> itemData;
  final DispatchEventCallback dispatchEvent;
  final String componentId;

  VoidCallback? _buildOnButtonTap(String? title) {
    final action = itemData['action'] as Map<String, Object?>?;
    if (action == null) return null;
    if (action case {'event': final Map<String, Object?> event}) {
      return () {
        dispatchEvent(
          UserActionEvent(
            name: event['name']! as String,
            sourceComponentId: componentId,
            context: {
              ...event['context'] as Map<String, Object?>? ?? {},
              'title': ?title,
            },
          ),
        );
      };
    }
    return null;
  }

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
                    buttonLabel: itemData['buttonLabel'] as String?,
                    buttonVariant: _parseVariant(
                      itemData['buttonVariant'] as String?,
                    ),
                    onButtonTap: _buildOnButtonTap(title),
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
                      buttonLabel: itemData['buttonLabel'] as String?,
                      buttonVariant: _parseVariant(
                        itemData['buttonVariant'] as String?,
                      ),
                      onButtonTap: _buildOnButtonTap(title),
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
