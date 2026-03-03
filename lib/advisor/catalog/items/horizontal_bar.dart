import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:intl/intl.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _currencyFormat = NumberFormat.currency(symbol: r'$', decimalDigits: 0);

final _schema = S.object(
  properties: {
    'category': S.string(
      description: 'The spending category label (e.g. "Dining").',
    ),
    'amount': S.number(
      description: 'The total amount in USD.',
    ),
    'progress': S.number(
      description: 'Bar fill ratio from 0.0 (empty) to 1.0 (full).',
    ),
    'comparisonLabel': S.string(
      description:
          'Sub-label shown below the bar (e.g. a comparison category).',
    ),
    'comparisonValue': S.number(
      description:
          'Signed delta value. Negative means over budget; '
          'positive means under budget.',
    ),
    'isPercentage': S.boolean(
      description: 'When true, appends "%" to the comparison value display.',
    ),
  },
  required: [
    'category',
    'amount',
    'progress',
    'comparisonLabel',
    'comparisonValue',
    'isPercentage',
  ],
);

/// CatalogItem that renders a horizontal progress bar with budget comparison.
///
/// Supports two visual variants based on [comparisonValue]:
/// - Negative (over budget): comparison text shown in red.
/// - Positive (under budget): comparison text shown in green.
final horizontalBarItem = CatalogItem(
  name: 'HorizontalBar',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final context = ctx.buildContext;

    final category = json['category']! as String;
    final amount = (json['amount']! as num).toDouble();
    final progress = (json['progress']! as num).toDouble().clamp(0.0, 1.0);
    final comparisonLabel = json['comparisonLabel']! as String;
    final comparisonValue = (json['comparisonValue']! as num).toDouble();
    final isPercentage = json['isPercentage']! as bool;

    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();

    final isPositive = comparisonValue >= 0;

    // Green for positive, red for negative.
    final positiveColor = colors?.neutral.shade50 ?? Colors.green;
    final negativeColor = colors?.error ?? Colors.red;
    final comparisonColor = isPositive ? positiveColor : negativeColor;

    final sign = isPositive ? '+' : '';
    final suffix = isPercentage ? '%' : '';
    final comparisonText = '$sign${comparisonValue.toStringAsFixed(0)}$suffix';

    // Bar fill: solid blue → light purple gradient.
    final barFillStart = colors?.secondary.shade500 ?? const Color(0xFF2461EB);
    final barFillEnd = colors?.secondary.shade400 ?? const Color(0xFFD4C6FB);

    // Bar track: very light blue-grey.
    final trackColor = colors?.secondary.shade200 ?? const Color(0xFFE2E8F9);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Spacing.xxs,
      children: [
        // Top row: category + amount.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: colors?.primary.shade900,
              ),
            ),
            Text(
              _currencyFormat.format(amount),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: colors?.surface,
              ),
            ),
          ],
        ),

        // Gradient progress bar.
        _HorizontalProgressBar(
          progress: progress,
          fillStart: barFillStart,
          fillEnd: barFillEnd,
          trackColor: trackColor,
        ),

        // Bottom row: comparison label + colored delta value.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              comparisonLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors?.primary.shade500,
              ),
            ),
            Text(
              comparisonText,
              style: theme.textTheme.labelLarge?.copyWith(
                color: comparisonColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  },
);

class _HorizontalProgressBar extends StatelessWidget {
  const _HorizontalProgressBar({
    required this.progress,
    required this.fillStart,
    required this.fillEnd,
    required this.trackColor,
  });

  final double progress;
  final Color fillStart;
  final Color fillEnd;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8,
      child: Stack(
        children: [
          // Track (full width, light background).
          Container(
            decoration: BoxDecoration(
              color: trackColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          // Fill (proportional width, gradient).
          FractionallySizedBox(
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [fillStart, fillEnd],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
