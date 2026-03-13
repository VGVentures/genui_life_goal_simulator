import 'package:finance_app/app/presentation.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _itemSchema = S.object(
  description: 'A single action item displayed inside the accordion.',
  properties: {
    'title': S.string(description: 'Primary label, e.g. "Restaurant".'),
    'subtitle': S.string(
      description: 'Secondary label, e.g. "Dining • Feb 18".',
    ),
    'amount': S.string(
      description: r'Monetary value shown on the right, e.g. "$450".',
    ),
    'delta': S.string(description: 'Optional change indicator, e.g. "+28%".'),
    'buttonLabel': S.string(
      description:
          'CTA button label. Required when buttonVariant is not "none".',
    ),
    'buttonVariant': S.string(
      description: 'Button style to render. Defaults to "none".',
      enumValues: ['primary', 'secondary', 'none'],
    ),
  },
  required: ['title', 'subtitle', 'amount'],
);

final _schema = S.object(
  description:
      'A collapsible panel that groups related financial action items '
      'under a header (e.g. "Debt Reduction Steps", "Savings Actions").',
  properties: {
    'title': S.string(description: 'Header text displayed in the accordion.'),
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
final accordionItem = CatalogItem(
  name: 'AppAccordion',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;

    final title = json['title']! as String;
    final rawItems = json['items']! as List<Object?>;
    final isExpanded = (json['isExpanded'] as bool?) ?? false;

    final items = rawItems.cast<Map<String, Object?>>().map((item) {
      return ActionItem(
        title: item['title']! as String,
        subtitle: item['subtitle']! as String,
        amount: item['amount']! as String,
        delta: item['delta'] as String?,
        buttonLabel: item['buttonLabel'] as String?,
        buttonVariant: _parseVariant(item['buttonVariant'] as String?),
      );
    }).toList();

    return AppAccordion(
      title: title,
      isExpanded: isExpanded,
      content: ActionItemsGroup(items: items),
    );
  },
);
