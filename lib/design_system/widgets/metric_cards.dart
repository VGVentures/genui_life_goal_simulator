import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// Direction of a metric delta indicator relative to its context.
enum MetricDeltaDirection {
  /// Delta is favorable; displayed in green.
  positive,

  /// Delta is unfavorable; displayed in red.
  negative,
}

/// A card molecule that displays a key financial metric with an optional
/// delta indicator and subtitle.
///
/// Supports four visual variants depending on the parameters provided:
///
/// - **Plain** – [label], [value], and optional [subtitle]; no delta.
/// - **Delta+** – adds a green [delta] via [MetricDeltaDirection.positive].
/// - **Delta-** – adds a red [delta] via [MetricDeltaDirection.negative].
/// - **Delta+Text** – like Delta+, but [subtitle] contains extended
///   comparison text (e.g. "+$40 above 3mo avg").
///
/// Use [MetricCardsLayout] to display a collection of cards with a responsive
/// horizontal-row (desktop) or vertical-stack (mobile) arrangement.
class MetricCard extends StatelessWidget {
  /// Creates a [MetricCard].
  const MetricCard({
    required this.label,
    required this.value,
    this.subtitle,
    this.delta,
    this.deltaDirection,
    this.borderRadius = 8,
    this.subtitleTopSpacing = 2,
    super.key,
  });

  /// Short label describing the metric (e.g. "Fixed costs").
  final String label;

  /// Primary metric value displayed prominently (e.g. "\$4,319").
  final String value;

  /// Optional context line shown below [value] (e.g. "vs last month").
  final String? subtitle;

  /// Optional delta shown inline next to [value] (e.g. "+1.2%").
  ///
  /// Set [deltaDirection] to control the indicator colour.
  final String? delta;

  /// Colour direction of [delta]: green for positive, red for negative.
  ///
  /// Has no visual effect when [delta] is null.
  final MetricDeltaDirection? deltaDirection;

  /// Corner radius of the card container.
  final double borderRadius;

  /// Vertical gap between the value row and the subtitle.
  final double subtitleTopSpacing;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return _MetricCardContent(
      label: label,
      value: value,
      subtitle: subtitle,
      delta: delta,
      deltaColor: _deltaColor(colors),
      textTheme: textTheme,
      colors: colors,
      borderRadius: borderRadius,
      subtitleTopSpacing: subtitleTopSpacing,
    );
  }

  Color _deltaColor(AppColors colors) {
    return switch (deltaDirection) {
      MetricDeltaDirection.positive => colors.success,
      MetricDeltaDirection.negative => colors.error,
      null => colors.onSurfaceMuted,
    };
  }
}

class _MetricCardContent extends StatelessWidget {
  const _MetricCardContent({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.delta,
    required this.deltaColor,
    required this.textTheme,
    required this.colors,
    required this.borderRadius,
    required this.subtitleTopSpacing,
  });

  final String label;
  final String value;
  final String? subtitle;
  final String? delta;
  final Color deltaColor;
  final TextTheme textTheme;
  final AppColors colors;
  final double borderRadius;
  final double subtitleTopSpacing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _MetricLabel(label: label, textTheme: textTheme, colors: colors),
          const SizedBox(height: Spacing.xs),
          _MetricValueRow(
            value: value,
            delta: delta,
            deltaColor: deltaColor,
            textTheme: textTheme,
            colors: colors,
          ),
          if (subtitle != null) ...[
            SizedBox(height: subtitleTopSpacing),
            _MetricSubtitle(
              subtitle: subtitle!,
              textTheme: textTheme,
              colors: colors,
            ),
          ],
        ],
      ),
    );
  }
}

class _MetricLabel extends StatelessWidget {
  const _MetricLabel({
    required this.label,
    required this.textTheme,
    required this.colors,
  });

  final String label;
  final TextTheme textTheme;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: textTheme.bodyMedium?.copyWith(
        color: colors.onSurfaceVariant,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _MetricValueRow extends StatelessWidget {
  const _MetricValueRow({
    required this.value,
    required this.delta,
    required this.deltaColor,
    required this.textTheme,
    required this.colors,
  });

  final String value;
  final String? delta;
  final Color deltaColor;
  final TextTheme textTheme;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Flexible(
          child: Text(
            value,
            style: textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (delta != null) ...[
          const SizedBox(width: Spacing.xxs),
          Text(
            delta!,
            style: textTheme.labelLarge?.copyWith(
              color: deltaColor,
            ),
          ),
        ],
      ],
    );
  }
}

class _MetricSubtitle extends StatelessWidget {
  const _MetricSubtitle({
    required this.subtitle,
    required this.textTheme,
    required this.colors,
  });

  final String subtitle;
  final TextTheme textTheme;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Text(
      subtitle,
      style: textTheme.labelMedium?.copyWith(
        color: colors.onSurfaceMuted,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Responsive layout for a collection of [MetricCard] widgets.
///
/// - **Desktop** (screen width ≥ 600 px): cards in a single horizontal row,
///   each taking equal width via [Expanded].
/// - **Mobile** (screen width < 600 px): cards stacked vertically, each
///   stretching to full width.
class MetricCardsLayout extends StatelessWidget {
  /// Creates a [MetricCardsLayout].
  const MetricCardsLayout({required this.cards, super.key});

  /// Cards to display.
  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      mobile: _MobileMetricCardsLayout(cards: cards),
      desktop: _DesktopMetricCardsLayout(cards: cards),
    );
  }
}

class _DesktopMetricCardsLayout extends StatelessWidget {
  const _DesktopMetricCardsLayout({required this.cards});

  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < cards.length; i++) ...[
          Expanded(child: cards[i]),
          if (i < cards.length - 1) const SizedBox(width: Spacing.md),
        ],
      ],
    );
  }
}

class _MobileMetricCardsLayout extends StatelessWidget {
  const _MobileMetricCardsLayout({required this.cards});

  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:
          cards.expand((c) => [c, const SizedBox(height: Spacing.md)]).toList()
            ..removeLast(),
    );
  }
}
