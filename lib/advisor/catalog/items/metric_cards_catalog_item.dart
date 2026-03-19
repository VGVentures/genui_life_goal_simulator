import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

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
                'Optional context line below the value (e.g. "vs last month").',
          ),
          'delta': A2uiSchemas.stringReference(
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
    'action': A2uiSchemas.action(
      description: 'The action to perform when a metric card is tapped.',
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
/// String fields (`label`, `value`, `subtitle`, `delta`) support data model
/// bindings via `{"path": "..."}` for reactive values.
final metricCardsItem = CatalogItem(
  name: 'MetricCard',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawCards = json['cards']! as List;
    final action = json['action'] as Map<String, Object?>?;

    final cards = rawCards.cast<Map<String, Object?>>().indexed.map((entry) {
      final (index, c) = entry;
      return _BoundMetricCard(
        key: ValueKey('metric_card_$index'),
        dataContext: ctx.dataContext,
        cardData: c,
        deltaDirection: _parseDeltaDirection(c['deltaDirection'] as String?),
        isSelected: c['isSelected'] as bool? ?? false,
        onTap: action == null
            ? null
            : () {
                if (action case {'event': final Map<String, Object?> event}) {
                  ctx.dispatchEvent(
                    UserActionEvent(
                      name: event['name']! as String,
                      sourceComponentId: ctx.id,
                      context: {
                        ...event['context'] as Map<String, Object?>? ?? {},
                        'index': index,
                      },
                    ),
                  );
                }
              },
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Spacing.md,
      children: cards,
    );
  },
);

class _BoundMetricCard extends StatelessWidget {
  const _BoundMetricCard({
    required this.dataContext,
    required this.cardData,
    required this.deltaDirection,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final DataContext dataContext;
  final Map<String, Object?> cardData;
  final MetricDeltaDirection? deltaDirection;
  final bool isSelected;
  final VoidCallback? onTap;

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
                    isSelected: isSelected,
                    onTap: onTap,
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
                      isSelected: isSelected,
                      onTap: onTap,
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
