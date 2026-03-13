import 'package:finance_app/app/presentation.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  properties: {
    'items': S.list(
      description: 'Ranked list of items, ordered from highest to lowest.',
      items: S.object(
        properties: {
          'title': S.string(
            description: 'Display name (e.g. "The French Laundry").',
          ),
          'amount': S.string(
            description: r'Formatted spend amount (e.g. "$350").',
          ),
          'delta': S.string(
            description:
                'Percentage change with sign '
                '(e.g. "+15%", "-5%").',
          ),
        },
        required: ['title', 'amount', 'delta'],
      ),
    ),
  },
  required: ['items'],
);

/// CatalogItem that renders a [RankedTable].
final rankedTableItem = CatalogItem(
  name: 'RankedTable',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rankedItems = json['items']! as List;

    final items = rankedItems
        .cast<Map<String, Object?>>()
        .map(
          (item) => RankedTableItem(
            title: item['title']! as String,
            amount: item['amount']! as String,
            delta: item['delta']! as String,
          ),
        )
        .toList();

    return RankedTable(items: items);
  },
);
