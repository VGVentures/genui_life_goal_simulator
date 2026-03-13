import 'package:finance_app/app/presentation.dart';
import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
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
    'buttonLabel': S.string(
      description:
          'CTA button label. Required when buttonVariant is not "none".',
    ),
    'buttonVariant': S.string(
      description: 'Button style to render. Defaults to "none".',
      enumValues: ['primary', 'secondary', 'none'],
    ),
    'action': A2uiSchemas.action(
      description: 'The action to perform when the button is pressed.',
    ),
  },
  required: ['title', 'subtitle', 'amount'],
);

final _schema = S.object(
  description:
      'A list of financial tasks, recommendations, or transaction highlights. '
      'Stack between 2 and 10 items — all items must be the same type '
      '(e.g. all with buttons or all without). '
      'Add delta when showing change over time (e.g. "+28%"). '
      'Set buttonVariant to "primary" or "secondary" with a buttonLabel '
      'only when there is a clear, immediate action for the user to take.',
  properties: {
    'items': S.list(
      items: _itemSchema,
      description: 'Ordered list of action items to display.',
    ),
  },
  required: ['items'],
);

ActionItemButtonVariant _parseVariant(String? value) {
  return switch (value) {
    'primary' => ActionItemButtonVariant.primary,
    'secondary' => ActionItemButtonVariant.secondary,
    _ => ActionItemButtonVariant.none,
  };
}

/// CatalogItem that renders a group of financial action items.
///
/// String fields (`title`, `subtitle`, `amount`, `delta`) support data model
/// bindings via `{"path": "..."}` for reactive values. Buttons dispatch
/// actions immediately when tapped.
final actionItemsGroupItem = CatalogItem(
  name: 'ActionItemsGroup',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawItems = json['items']! as List<Object?>;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rawItems
          .cast<Map<String, Object?>>()
          .indexed
          .map((entry) {
            final (index, item) = entry;
            return _BoundActionItem(
              key: ValueKey('action_item_$index'),
              dataContext: ctx.dataContext,
              itemData: item,
              dispatchEvent: ctx.dispatchEvent,
              componentId: ctx.id,
            );
          })
          .toList(),
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
