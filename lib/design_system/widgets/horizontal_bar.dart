import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// A horizontal progress bar that displays a spending category with its
/// amount, a proportional fill bar, and a signed comparison value.
///
/// Supports two visual variants based on [comparisonValue]:
/// - Negative (over budget): comparison text shown in red.
/// - Positive (under budget): comparison text shown in green.
class HorizontalBar extends StatelessWidget {
  const HorizontalBar({
    required this.category,
    required this.amount,
    required this.progress,
    required this.comparisonLabel,
    required this.comparisonValue,
    super.key,
  });

  /// Spending category label (e.g. "Dining").
  final String category;

  /// Formatted amount string (e.g. "\$420").
  final String amount;

  /// Bar fill ratio from 0.0 (empty) to 1.0 (full).
  final double progress;

  /// Sub-label shown below the bar (e.g. "Groceries").
  final String comparisonLabel;

  /// Formatted comparison value with sign and % (e.g. "+10%", "-5%").
  final String comparisonValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    final isNegative = comparisonValue.startsWith('-');
    final comparisonColor = isNegative ? colors.error : colors.success;

    final barGradient = colors.geniusGradient;
    final trackColor = colors.outlineVariant;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Spacing.xxs,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurface,
              ),
            ),
            Text(
              amount,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colors.onSurface,
              ),
            ),
          ],
        ),
        _HorizontalProgressBar(
          progress: progress.clamp(0.0, 1.0),
          gradient: barGradient,
          trackColor: trackColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              comparisonLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceMuted,
              ),
            ),
            Text(
              comparisonValue,
              style: theme.textTheme.labelLarge?.copyWith(
                color: comparisonColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HorizontalProgressBar extends StatelessWidget {
  const _HorizontalProgressBar({
    required this.progress,
    required this.gradient,
    required this.trackColor,
  });

  final double progress;
  final LinearGradient gradient;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: trackColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          FractionallySizedBox(
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
