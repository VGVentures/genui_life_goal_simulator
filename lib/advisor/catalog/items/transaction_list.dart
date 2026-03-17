import 'package:finance_app/app/presentation.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  properties: {
    'items': S.list(
      description: 'List of transactions to display.',
      items: S.object(
        properties: {
          'title': A2uiSchemas.stringReference(
            description: 'Transaction name (e.g. "Nobu Restaurant").',
          ),
          'description': A2uiSchemas.stringReference(
            description: 'Transaction category (e.g. "Dining").',
          ),
          'amount': A2uiSchemas.stringReference(
            description: r'Formatted amount string (e.g. "$450").',
          ),
          'action': A2uiSchemas.action(
            description:
                'Optional action dispatched when the View button is tapped.',
          ),
        },
        required: ['title', 'description', 'amount'],
      ),
    ),
  },
  required: ['items'],
);

/// CatalogItem that renders a [TransactionList].
final transactionListItem = CatalogItem(
  name: 'TransactionList',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawItems = json['items']! as List;

    final items = rawItems.cast<Map<String, Object?>>().map((item) {
      final action = item['action'] as Map<String, Object?>?;

      return TransactionListItem(
        title: _resolveString(item['title']),
        description: _resolveString(item['description']),
        amount: _resolveString(item['amount']),
        onViewDetails: action == null
            ? null
            : () {
                if (action case {'event': final Map<String, Object?> event}) {
                  ctx.dispatchEvent(
                    UserActionEvent(
                      name: event['name']! as String,
                      sourceComponentId: ctx.id,
                      context: {
                        ...event['context'] as Map<String, Object?>? ?? {},
                        'title': _resolveString(item['title']),
                        'description': _resolveString(item['description']),
                        'amount': _resolveString(item['amount']),
                      },
                    ),
                  );
                }
              },
      );
    }).toList();

    return TransactionList(items: items);
  },
);

String _resolveString(Object? value) {
  if (value is String) return value;
  return value?.toString() ?? '';
}
