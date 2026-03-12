import 'package:finance_app/app/presentation.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  properties: {
    'items': S.list(
      description: 'List of transactions to display.',
      items: S.object(
        properties: {
          'title': S.string(
            description:
                'Transaction name (e.g. "Nobu Restaurant").',
          ),
          'description': S.string(
            description:
                'Transaction category (e.g. "Dining").',
          ),
          'amount': S.string(
            description:
                r'Formatted amount string (e.g. "$450").',
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

    final items = rawItems
        .cast<Map<String, Object?>>()
        .map(
          (item) => TransactionListItem(
            title: item['title']! as String,
            description: item['description']! as String,
            amount: item['amount']! as String,
          ),
        )
        .toList();

    return TransactionList(items: items);
  },
);
