import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A grid of cards highlighting key financial metrics '
      '(e.g. total spending, savings rate, net worth). '
      'String fields support data model bindings via {"path": "..."}.',
  properties: {
    'cards': S.list(
      description: 'List of metric cards to display in a responsive layout.',
      items: S.object(
        properties: {
          'label': A2uiSchemas.stringReference(
            description:
                'Short label describing the metric (e.g. "Fixed costs").',
          ),
          'value': A2uiSchemas.stringReference(
            description: r'Primary metric value (e.g. "$4,319").',
          ),
          'subtitle': A2uiSchemas.stringReference(
            description:
                'Optional context line below the value '
                '(e.g. "vs last month").',
          ),
          'delta': S.string(
            description:
                'Optional short numeric delta including sign and unit. '
                'Must be a number with a sign and unit ONLY — no words or '
                r'descriptions (e.g. "+1.2%", "-$80", "+3k"). '
                r'Wrong: "Commodity hedge needed", "Drawdown: -$61k". '
                'Use subtitle for any descriptive context instead.',
          ),
          'deltaDirection': S.string(
            description:
                'Whether the delta is favorable or unfavorable for the user. '
                'Controls the colour: "positive" = green, "negative" = red. '
                'Ignore the sign of the number. Instead ask: '
                'is the user in a better or worse position because of this? '
                '"positive" (green): improvement achieved, goal met, '
                'savings realised, high coverage or utilisation '
                '(e.g. "-95%" tax-advantaged coverage is green — '
                'sheltering 95% of surplus is great). '
                '"negative" (red): problem still exists, gap or deficit '
                'remaining, target not yet met, overspending '
                '(e.g. "-18.9%" gap-to-close is red — the shortfall '
                'still exists; "+7%" fixed-cost ratio above goal is red). '
                'When in doubt: would a financial advisor highlight this '
                'in green (good news) or red (needs attention)?',
            enumValues: ['positive', 'negative'],
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
///
/// String fields (`label`, `value`, `subtitle`) support data model
/// bindings via `{"path": "..."}` for reactive values.
/// The `delta` field must be a pre-formatted literal string (e.g. "+1.2%").
final metricCardsItem = CatalogItem(
  name: 'MetricCard',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawCards = json['cards']! as List;

    final cards = rawCards.cast<Map<String, Object?>>().indexed.map((entry) {
      final (index, c) = entry;
      return _BoundMetricCard(
        key: ValueKey('metric_card_$index'),
        dataContext: ctx.dataContext,
        cardData: c,
        delta: c['delta'] as String?,
        deltaDirection: _parseDeltaDirection(c['deltaDirection'] as String?),
      );
    }).toList();

    return MetricCardsLayout(cards: cards);
  },
);

class _BoundMetricCard extends StatelessWidget {
  const _BoundMetricCard({
    required this.dataContext,
    required this.cardData,
    required this.delta,
    required this.deltaDirection,
    super.key,
  });

  final DataContext dataContext;
  final Map<String, Object?> cardData;
  final String? delta;
  final MetricDeltaDirection? deltaDirection;

  @override
  Widget build(BuildContext context) {
    return BoundString(
      dataContext: dataContext,
      value: cardData['label'],
      builder: (context, label) {
        return BoundString(
          dataContext: dataContext,
          value: cardData['value'],
          builder: (context, value) {
            return BoundString(
              dataContext: dataContext,
              value: cardData['subtitle'] ?? '',
              builder: (context, subtitle) {
                final deltaValue = cardData['delta'];
                if (deltaValue == null) {
                  return MetricCard(
                    label: label ?? '',
                    value: value ?? '',
                    subtitle: subtitle?.isEmpty ?? true ? null : subtitle,
                    deltaDirection: deltaDirection,
                  );
                }
                return BoundString(
                  dataContext: dataContext,
                  value: deltaValue,
                  builder: (context, delta) {
                    return MetricCard(
                      label: label ?? '',
                      value: value ?? '',
                      subtitle: subtitle?.isEmpty ?? true ? null : subtitle,
                      delta: delta,
                      deltaDirection: deltaDirection,
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
