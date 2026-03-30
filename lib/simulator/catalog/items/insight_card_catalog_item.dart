import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A contextual insight card that surfaces a key takeaway with an emoji '
      'badge, title, and description. '
      'Choose a variant to communicate sentiment: '
      '"neutral" for informational insights (default), '
      '"success" for positive outcomes, '
      '"warning" for cautionary messages, and '
      '"error" for critical or negative findings. '
      'String fields support data model bindings via {"path": "..."}. '
      'Use InsightCard inside a SummaryContainer to surface insights '
      'alongside financial data — never inside a QuestionContainer. '
      'IMPORTANT: Do NOT wrap InsightCard in a SectionCard — it already has '
      'its own card styling and background.',
  properties: {
    'variant': S.string(
      description:
          'Visual style of the card. '
          'Defaults to "neutral" if omitted.',
      enumValues: ['neutral', 'success', 'warning', 'error'],
    ),
    'emoji': A2uiSchemas.stringReference(
      description:
          'A single emoji shown in the badge for the neutral variant. '
          'Ignored for success, warning, and error variants.',
    ),
    'title': A2uiSchemas.stringReference(
      description:
          'Primary headline text '
          '(e.g. "Dining is your biggest opportunity").',
    ),
    'description': A2uiSchemas.stringReference(
      description:
          'Supporting body text providing detail or context '
          r'(e.g. "You spent \$420 on dining this month").',
    ),
  },
  required: ['title', 'description'],
);

InsightCardVariant _parseVariant(String? value) {
  return switch (value) {
    'success' => InsightCardVariant.success,
    'warning' => InsightCardVariant.warning,
    'error' => InsightCardVariant.error,
    _ => InsightCardVariant.neutral,
  };
}

/// CatalogItem that renders an [InsightCard] widget.
///
/// The `variant` field controls the card's colour scheme and border.
/// String fields (`emoji`, `title`, `description`) support data model
/// bindings via `{"path": "..."}`.
final insightCardItem = CatalogItem(
  name: 'InsightCard',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final variant = _parseVariant(json['variant'] as String?);

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: _BoundInsightCard(
        dataContext: ctx.dataContext,
        cardData: json,
        variant: variant,
      ),
    );
  },
);

class _BoundInsightCard extends StatelessWidget {
  const _BoundInsightCard({
    required this.dataContext,
    required this.cardData,
    required this.variant,
  });

  final DataContext dataContext;
  final Map<String, Object?> cardData;
  final InsightCardVariant variant;

  @override
  Widget build(BuildContext context) {
    return BoundString(
      dataContext: dataContext,
      value: cardData['emoji'],
      builder: (context, emoji) {
        return BoundString(
          dataContext: dataContext,
          value: cardData['title'],
          builder: (context, title) {
            return BoundString(
              dataContext: dataContext,
              value: cardData['description'],
              builder: (context, description) {
                return InsightCard(
                  emoji: emoji,
                  title: title ?? '',
                  description: description ?? '',
                  variant: variant,
                );
              },
            );
          },
        );
      },
    );
  }
}
