import 'package:finance_app/app/presentation.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A grid of cards highlighting key financial metrics '
      '(e.g. total spending, savings rate, net worth).',
  properties: {
    'cards': S.list(
      description: 'List of metric cards to display in a responsive layout.',
      items: S.object(
        properties: {
          'label': S.string(
            description:
                'Short label describing the metric (e.g. "Fixed costs").',
          ),
          'value': S.string(
            description: r'Primary metric value (e.g. "$4,319").',
          ),
          'subtitle': S.string(
            description:
                'Optional context line below the value (e.g. "vs last month").',
          ),
          'delta': S.string(
            description: 'Optional delta text (e.g. "+1.2%").',
          ),
          'deltaDirection': S.string(
            description: 'Colour direction of the delta indicator.',
            enumValues: ['positive', 'negative'],
          ),
          'isSelected': S.boolean(
            description: 'Whether the card is in the selected state.',
          ),
        },
        required: ['label', 'value'],
      ),
    ),
  },
  required: ['cards'],
);

MetricDeltaDirection? _parseDeltaDirection(String? value) {
  return switch (value) {
    'positive' => MetricDeltaDirection.positive,
    'negative' => MetricDeltaDirection.negative,
    _ => null,
  };
}

/// CatalogItem that renders a [MetricCardsLayout] of [MetricCard] widgets.
final metricCardsItem = CatalogItem(
  name: 'MetricCard',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawCards = json['cards']! as List;

    final cards = rawCards.cast<Map<String, Object?>>().map((c) {
      return MetricCard(
        label: c['label']! as String,
        value: c['value']! as String,
        subtitle: c['subtitle'] as String?,
        delta: c['delta'] as String?,
        deltaDirection: _parseDeltaDirection(c['deltaDirection'] as String?),
        isSelected: c['isSelected'] as bool? ?? false,
      );
    }).toList();

    return MetricCardsLayout(cards: cards);
  },
);
