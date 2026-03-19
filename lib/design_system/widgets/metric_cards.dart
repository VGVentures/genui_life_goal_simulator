import 'package:flutter/material.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

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
/// Supports five visual variants depending on the parameters provided:
///
/// - **Plain** – [label], [value], and optional [subtitle]; no delta.
/// - **Delta+** – adds a green [delta] via [MetricDeltaDirection.positive].
/// - **Delta-** – adds a red [delta] via [MetricDeltaDirection.negative].
/// - **Delta+Text** – like Delta+, but [subtitle] contains extended
///   comparison text (e.g. "+$40 above 3mo avg").
/// - **Selected** – any of the above with [isSelected] set to `true`.
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
    this.isSelected = false,
    this.onTap,
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

  /// Whether this card renders in the selected/active state.
  final bool isSelected;

  /// Optional tap callback. When `null` the card is non-interactive.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
    final textTheme = Theme.of(context).textTheme;

    final content = _MetricCardContent(
      label: label,
      value: value,
      subtitle: subtitle,
      delta: delta,
      deltaColor: _deltaColor(colors),
      isSelected: isSelected,
      textTheme: textTheme,
      colors: colors,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(_Dimensions.borderRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_Dimensions.borderRadius),
        child: content,
      ),
    );
  }

  Color _deltaColor(AppColors? colors) {
    return switch (deltaDirection) {
      MetricDeltaDirection.positive =>
        colors?.success ?? _MetricCardColors.positive,
      MetricDeltaDirection.negative =>
        colors?.error ?? _MetricCardColors.negative,
      null => colors?.onSurfaceMuted ?? _MetricCardColors.subtitle,
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
    required this.isSelected,
    required this.textTheme,
    required this.colors,
  });

  final String label;
  final String value;
  final String? subtitle;
  final String? delta;
  final Color deltaColor;
  final bool isSelected;
  final TextTheme textTheme;
  final AppColors? colors;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? (colors?.primaryContainer ?? _MetricCardColors.selectedBackground)
        : (colors?.surface ?? _MetricCardColors.background);

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(_Dimensions.borderRadius),
        border: Border.all(
          color: isSelected
              ? (colors?.primary ?? _MetricCardColors.selectedBorder)
              : Colors.transparent,
          width: _Dimensions.selectedBorderWidth,
        ),
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
            const SizedBox(height: _Dimensions.subtitleTopSpacing),
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
  final AppColors? colors;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: textTheme.bodyMedium?.copyWith(
        color: colors?.onSurfaceVariant ?? _MetricCardColors.label,
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
  final AppColors? colors;

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
              color: colors?.onSurface ?? _MetricCardColors.value,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (delta != null) ...[
          const SizedBox(width: _Dimensions.deltaSpacing),
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
  final AppColors? colors;

  @override
  Widget build(BuildContext context) {
    return Text(
      subtitle,
      style: textTheme.labelMedium?.copyWith(
        color: colors?.onSurfaceMuted ?? _MetricCardColors.subtitle,
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

abstract final class _Dimensions {
  static const double borderRadius = 8;
  static const double selectedBorderWidth = 1.5;
  static const double deltaSpacing = 4;
  static const double subtitleTopSpacing = 2;
}

abstract final class _MetricCardColors {
  static const Color background = Color(0xFFFFFFFF);
  static const Color selectedBackground = Color(0xFFE3F2FD);
  static const Color selectedBorder = Color(0xFF2196F3);
  static const Color label = Color(0xFF616161);
  static const Color value = Color(0xFF212121);
  static const Color subtitle = Color(0xFF757575);
  static const Color positive = Color(0xFF4CAF50);
  static const Color negative = Color(0xFFF44336);
}
