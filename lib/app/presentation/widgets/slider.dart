import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';

/// {@template gcn_slider}
/// A slider component with a title and subtitle header.
///
/// Supports two visual variants:
/// - **Basic**: continuous slider with optional min/max range labels.
/// - **Splits**: discrete slider with tick marks and per-division labels,
///   enabled by providing [divisions] and [splitLabels].
/// {@endtemplate}
class GcnSlider extends StatelessWidget {
  /// {@macro gcn_slider}
  const GcnSlider({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.valueLabel,
    this.minLabel,
    this.maxLabel,
    this.divisions,
    this.splitLabels,
    super.key,
  });

  /// Header title displayed above the slider.
  final String title;

  /// Subtitle shown below the title (e.g. "Dining • Feb 18").
  final String subtitle;

  /// Current slider value. Must be between [min] and [max].
  final double value;

  /// Minimum slider value.
  final double min;

  /// Maximum slider value.
  final double max;

  /// Called when the user moves the slider.
  final ValueChanged<double> onChanged;

  /// Formatted value label shown at the top-right (e.g. "\$450").
  /// Only shown in the basic variant.
  final String? valueLabel;

  /// Label below the track at the minimum end (e.g. "\$1").
  final String? minLabel;

  /// Label below the track at the maximum end (e.g. "\$1270").
  final String? maxLabel;

  /// Number of discrete divisions. When non-null, enables the splits variant.
  final int? divisions;

  /// Per-division labels for the splits variant.
  /// Should contain [divisions] + 1 elements.
  final List<String>? splitLabels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();

    final gradient = colors?.geniusGradient ??
        const LinearGradient(
          colors: [_SliderColors.fillStart, _SliderColors.fillEnd],
        );
    final trackColor = colors?.outlineVariant ?? _SliderColors.track;
    final thumbColor = colors?.primary ?? _SliderColors.thumb;
    final mutedColor = colors?.onSurfaceMuted ?? _SliderColors.labelMuted;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors?.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (valueLabel != null)
              Text(
                valueLabel!,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors?.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(color: mutedColor),
        ),
        const SizedBox(height: Spacing.xs),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8,
            inactiveTrackColor: trackColor,
            activeTrackColor: Colors.transparent,
            thumbColor: thumbColor,
            overlayColor: thumbColor.withValues(alpha: 0.12),
            trackShape: _GradientTrackShape(
              gradient: gradient,
              trackColor: trackColor,
            ),
            thumbShape: _RingThumbShape(thumbColor: thumbColor),
            tickMarkShape: divisions != null
                ? _VerticalTickMarkShape(color: trackColor)
                : SliderTickMarkShape.noTickMark,
            showValueIndicator: ShowValueIndicator.never,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
        if (divisions != null && splitLabels != null)
          _SplitLabels(
            labels: splitLabels!,
            value: value,
            min: min,
            max: max,
            theme: theme,
            mutedColor: mutedColor,
          )
        else
          _RangeLabels(
            minLabel: minLabel,
            maxLabel: maxLabel,
            theme: theme,
            mutedColor: mutedColor,
          ),
        const Divider(),
      ],
    );
  }
}

// Private helpers

const double _kSliderLabelPadding = 24;

class _RangeLabels extends StatelessWidget {
  const _RangeLabels({
    required this.minLabel,
    required this.maxLabel,
    required this.theme,
    required this.mutedColor,
  });

  final String? minLabel;
  final String? maxLabel;
  final ThemeData theme;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    if (minLabel == null && maxLabel == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kSliderLabelPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            minLabel ?? '',
            style: theme.textTheme.bodySmall?.copyWith(color: mutedColor),
          ),
          Text(
            maxLabel ?? '',
            style: theme.textTheme.bodySmall?.copyWith(color: mutedColor),
          ),
        ],
      ),
    );
  }
}

class _SplitLabels extends StatelessWidget {
  const _SplitLabels({
    required this.labels,
    required this.value,
    required this.min,
    required this.max,
    required this.theme,
    required this.mutedColor,
  });

  final List<String> labels;
  final double value;
  final double min;
  final double max;
  final ThemeData theme;
  final Color mutedColor;

  int get _selectedIndex {
    if (labels.isEmpty || max == min) return 0;
    final normalized = (value - min) / (max - min);
    return (normalized * (labels.length - 1))
        .round()
        .clamp(0, labels.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selectedIndex;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kSliderLabelPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 0; i < labels.length; i++)
            Text(
              labels[i],
              style: theme.textTheme.bodySmall?.copyWith(
                color: mutedColor,
                fontWeight:
                    i == selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
        ],
      ),
    );
  }
}

// Custom slider shapes

class _GradientTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  const _GradientTrackShape({
    required this.gradient,
    required this.trackColor,
  });

  final LinearGradient gradient;
  final Color trackColor;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
    Offset? secondaryOffset,
  }) {
    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final radius = Radius.circular(trackRect.height / 2);

    // Full inactive track.
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, radius),
      Paint()..color = trackColor,
    );

    // Active gradient (left of thumb).
    final activeRight =
        thumbCenter.dx.clamp(trackRect.left, trackRect.right);
    if (activeRight > trackRect.left) {
      context.canvas
        ..save()
        ..clipRRect(RRect.fromRectAndRadius(trackRect, radius))
        ..drawRect(
          Rect.fromLTRB(
            trackRect.left,
            trackRect.top,
            activeRight,
            trackRect.bottom,
          ),
          Paint()..shader = gradient.createShader(trackRect),
        )
        ..restore();
    }
  }
}

class _RingThumbShape extends SliderComponentShape {
  const _RingThumbShape({required this.thumbColor});

  final Color thumbColor;

  static const double _radius = 10;
  static const double _ringWidth = 2;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      const Size.fromRadius(_radius + _ringWidth);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    context.canvas
      ..drawCircle(center, _radius + _ringWidth, Paint()..color = Colors.white)
      ..drawCircle(center, _radius, Paint()..color = thumbColor);
  }
}

class _VerticalTickMarkShape extends SliderTickMarkShape {
  const _VerticalTickMarkShape({required this.color});

  final Color color;

  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    required bool isEnabled,
  }) =>
      const Size(1, 8);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    required bool isEnabled,
  }) {
    final halfTrack = (sliderTheme.trackHeight ?? 8.0) / 2;
    context.canvas.drawLine(
      Offset(center.dx, center.dy - halfTrack),
      Offset(center.dx, center.dy + halfTrack),
      Paint()
        ..color = color
        ..strokeWidth = 1.0,
    );
  }
}

// Fallback colors

abstract final class _SliderColors {
  static const fillStart = Color(0xFF2461EB);
  static const fillEnd = Color(0xFFD4C6FB);
  static const track = Color(0xFFE2E8F9);
  static const thumb = Color(0xFF7C8FF5);
  static const labelMuted = Color(0xFF94A3B8);
}
