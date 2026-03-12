import 'package:finance_app/app/presentation.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  properties: {
    'label': S.string(
      description:
          'Category name displayed at the top-left '
          '(e.g. "Savings").',
    ),
    'amount': S.string(
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
final sparklineCardItem = CatalogItem(
  name: 'SparklineCard',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;

    return SparklineCard(
      label: json['label']! as String,
      amount: json['amount']! as String,
      trend: _parseTrend(json['trend']! as String),
    );
  },
);
