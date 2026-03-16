import 'package:finance_app/app/presentation.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A card showing a financial category with its amount and a trend '
      'sparkline. String fields support data model bindings via '
      '{"path": "..."}.',
  properties: {
    'label': A2uiSchemas.stringReference(
      description: 'Category name displayed at the top-left (e.g. "Savings").',
    ),
    'amount': A2uiSchemas.stringReference(
      description: r'Formatted amount string (e.g. "$12,500").',
    ),
    'trend': S.string(
      description: 'Direction of the trend sparkline.',
      enumValues: ['negative', 'stable', 'positive'],
    ),
  },
  required: ['label', 'amount', 'trend'],
);

TrendType _parseTrend(String value) {
  return switch (value) {
    'negative' => TrendType.negative,
    'stable' => TrendType.stable,
    'positive' => TrendType.positive,
    _ => TrendType.stable,
  };
}

/// CatalogItem that renders a [SparklineCard].
///
/// `label` and `amount` support data model bindings for reactive values.
final sparklineCardItem = CatalogItem(
  name: 'SparklineCard',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final trend = _parseTrend(json['trend']! as String);

    return BoundString(
      dataContext: ctx.dataContext,
      value: json['label'],
      builder: (context, label) {
        return BoundString(
          dataContext: ctx.dataContext,
          value: json['amount'],
          builder: (context, amount) {
            return SparklineCard(
              label: label ?? '',
              amount: amount ?? '',
              trend: trend,
            );
          },
        );
      },
    );
  },
);
