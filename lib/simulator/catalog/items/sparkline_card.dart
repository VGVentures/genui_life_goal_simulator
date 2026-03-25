import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A horizontal (desktop) or vertical (mobile) set of sparkline cards '
      'showing financial categories with '
      'amounts and trend sparklines. Always provide at least 2 cards. '
      'String fields support data model bindings via {"path": "..."}.',
  properties: {
    'cards': S.list(
      description:
          'List of sparkline cards to display side by side on desktop, '
          'or stacked vertically on mobile. '
          'Minimum 2 cards required. '
          'Provide at least 2.',
      items: S.object(
        properties: {
          'label': A2uiSchemas.stringReference(
            description:
                'Category name displayed at the top-left (e.g. "Savings").',
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
      ),
    ),
  },
  required: ['cards'],
);

TrendType _parseTrend(String value) {
  return switch (value) {
    'negative' => TrendType.negative,
    'stable' => TrendType.stable,
    'positive' => TrendType.positive,
    _ => TrendType.stable,
  };
}

/// CatalogItem that renders a [SparklineCardsLayout] of [SparklineCard]
/// widgets.
///
/// `label` and `amount` support data model bindings for reactive values.
/// Always provide at least 2 cards so the row fills the available width.
final sparklineCardItem = CatalogItem(
  name: 'SparklineCard',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawCards = json['cards']! as List;
    final cards = rawCards.cast<Map<String, Object?>>().indexed.map((entry) {
      final (index, c) = entry;
      final trend = _parseTrend(c['trend']! as String);
      return _BoundSparklineCard(
        key: ValueKey('sparkline_card_$index'),
        dataContext: ctx.dataContext,
        label: c['label'],
        amount: c['amount'],
        trend: trend,
      );
    }).toList();

    return SparklineCardsLayout(cards: cards);
  },
);

class _BoundSparklineCard extends SparklineCard {
  const _BoundSparklineCard({
    required DataContext dataContext,
    required Object? label,
    required Object? amount,
    required super.trend,
    super.key,
  }) : _dataContext = dataContext,
       _labelValue = label,
       _amountValue = amount,
       super(label: '', amount: '');

  final DataContext _dataContext;
  final Object? _labelValue;
  final Object? _amountValue;

  @override
  Widget build(BuildContext context) {
    return BoundString(
      dataContext: _dataContext,
      value: _labelValue,
      builder: (context, label) {
        return BoundString(
          dataContext: _dataContext,
          value: _amountValue,
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
  }
}
