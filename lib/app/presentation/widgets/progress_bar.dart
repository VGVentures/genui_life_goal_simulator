import 'package:finance_app/app/presentation/app_colors.dart';
import 'package:finance_app/app/presentation/spacing.dart';
import 'package:flutter/material.dart';

/// {@template progress_bar}
/// A molecule widget displaying a labeled progress bar with
/// threshold-based color coding.
///
/// The bar color reflects [value] relative to [total]:
/// - **< 65 %** – success (green)
/// - **65–85 %** – warning (orange)
/// - **> 85 %** – error (red)
///
/// ```dart
/// ProgressBar(
///   title: 'Dining',
///   value: 420,
///   total: 400,
/// )
/// ```
/// {@endtemplate}
class ProgressBar extends StatelessWidget {
  /// {@macro progress_bar}
  const ProgressBar({
    required this.title,
    required this.value,
    required this.total,
    this.formatValue,
    super.key,
  });

  /// Category label displayed above the bar.
  final String title;

  /// Current amount (e.g. amount spent).
  final double value;

  /// Budget / maximum value.
  final double total;

  /// Optional formatter applied to both [value] and [total].
  ///
  /// Defaults to a dollar-prefixed integer string (e.g. `$420`).
  final String Function(double)? formatValue;

  static const double _warningThreshold = 0.65;
  static const double _errorThreshold = 0.85;
  static const double _trackHeight = 8;

  double get _progress => total > 0 ? value / total : 0;

  Color _barColor(AppColors colors) {
    final ratio = _progress;
    if (ratio > _errorThreshold) return colors.error;
    if (ratio >= _warningThreshold) return colors.warning;
    return colors.success;
  }

  static String _defaultFormat(double v) => '\$${v.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final fmt = formatValue ?? _defaultFormat;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textTheme.titleSmall?.copyWith(color: colors.onSurface),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  fmt(value),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                Text(
                  ' / ${fmt(total)}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: Spacing.xs),
        LinearProgressIndicator(
          value: _progress.clamp(0.0, 1.0),
          backgroundColor: colors.surfaceContainerHigh,
          valueColor: AlwaysStoppedAnimation(_barColor(colors)),
          minHeight: _trackHeight,
          borderRadius: BorderRadius.circular(100),
        ),
      ],
    );
  }
}
