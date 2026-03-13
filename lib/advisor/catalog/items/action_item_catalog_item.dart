import 'package:finance_app/app/presentation.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _itemSchema = S.object(
  description:
      'A single financial task, recommendation, or transaction highlight.',
  properties: {
    'title': S.string(description: 'Primary label, e.g. "Restaurant".'),
    'subtitle': S.string(
      description: 'Secondary label, e.g. "Dining • Feb 18".',
    ),
    'amount': S.string(
      description: r'Monetary value shown on the right, e.g. "$450".',
    ),
    'delta': S.string(
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

/// CatalogItem that renders a group of financial action items.
final actionItemsGroupItem = CatalogItem(
  name: 'ActionItemsGroup',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawItems = json['items']! as List<Object?>;

    final items = rawItems.map((raw) {
      final item = raw! as Map<String, Object?>;
      final variantRaw = item['buttonVariant'] as String?;
      final variant = switch (variantRaw) {
        'primary' => ActionItemButtonVariant.primary,
        'secondary' => ActionItemButtonVariant.secondary,
        _ => ActionItemButtonVariant.none,
      };
      final action = item['action'] as Map<String, Object?>?;

      return ActionItem(
        title: item['title']! as String,
        subtitle: item['subtitle']! as String,
        amount: item['amount']! as String,
        delta: item['delta'] as String?,
        buttonLabel: item['buttonLabel'] as String?,
        buttonVariant: variant,
        onButtonTap: () {
          if (action case {'event': final Map<String, Object?> event}) {
            ctx.dispatchEvent(
              UserActionEvent(
                name: event['name']! as String,
                sourceComponentId: ctx.id,
                context: event['context'] as Map<String, Object?>? ?? {},
              ),
            );
          }
        },
      );
    }).toList();

    return ActionItemsGroup(items: items);
  },
);
