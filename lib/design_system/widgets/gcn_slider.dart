import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// {@template gcn_slider}
/// A slider component with a title and subtitle header.
///
/// Supports two visual variants:
/// - **Basic**: continuous slider with optional min/max range labels.
/// - **Splits**: discrete slider with tick marks and per-division labels,
///   enabled by providing [divisions] and [splitLabels].
/// {@endtemplate}
class GCNSlider extends StatelessWidget {
  /// {@macro gcn_slider}
  const GCNSlider({
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
    final textTheme = theme.textTheme;
    final colors = theme.extension<AppColors>();

    final gradient =
        colors?.geniusGradient ??
        const LinearGradient(
          colors: [_SliderColors.fillStart, _SliderColors.fillEnd],
        );
    final trackColor = colors?.surfaceContainer ?? _SliderColors.track;
    final thumbColor = colors?.primary ?? _SliderColors.thumb;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textTheme.titleSmall?.copyWith(
                color: colors?.onSurface,
              ),
            ),
            if (valueLabel != null)
              Text(
                valueLabel!,
                style: textTheme.bodyLarge?.copyWith(
                  color: colors?.onSurface,
                ),
              ),
          ],
        ),
        Text(
          subtitle,
          style: textTheme.bodyMedium?.copyWith(color: colors?.onSurfaceMuted),
        ),
        const SizedBox(height: Spacing.sm),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: Spacing.sm,
            inactiveTrackColor: trackColor,
            activeTrackColor: Colors.transparent,
            thumbColor: thumbColor,
            overlayColor: thumbColor.withValues(alpha: 0.12),
            trackShape: _GradientTrackShape(
              gradient: gradient,
              trackColor: trackColor,
            ),
            thumbShape: _RingThumbShape(gradient: gradient),
            tickMarkShape: divisions != null
                ? _VerticalTickMarkShape(
                    color: colors?.outlineStrong ?? const Color(0xFFAAABAB),
                  )
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
        const SizedBox(height: Spacing.xxs),
        if (divisions != null && splitLabels != null)
          _SplitLabels(
            labels: splitLabels!,
            value: value,
            min: min,
            max: max,
          )
        else
          _RangeLabels(
            minLabel: minLabel,
            maxLabel: maxLabel,
          ),
        const SizedBox(height: Spacing.md),
        const Divider(),
      ],
    );
  }
}

class _RangeLabels extends StatelessWidget {
  const _RangeLabels({
    required this.minLabel,
    required this.maxLabel,
  });

  final String? minLabel;
  final String? maxLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.extension<AppColors>();

    if (minLabel == null && maxLabel == null) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          minLabel ?? '',
          style: textTheme.bodyMedium?.copyWith(
            color: colors?.onSurfaceMuted,
          ),
        ),
        Text(
          maxLabel ?? '',
          style: textTheme.bodyMedium?.copyWith(
            color: colors?.onSurfaceMuted,
          ),
        ),
      ],
    );
  }
}

class _SplitLabels extends StatelessWidget {
  const _SplitLabels({
    required this.labels,
    required this.value,
    required this.min,
    required this.max,
  });

  final List<String> labels;
  final double value;
  final double min;
  final double max;

  int get _selectedIndex {
    if (labels.isEmpty || max == min) return 0;
    final normalized = (value - min) / (max - min);
    return (normalized * (labels.length - 1)).round().clamp(
      0,
      labels.length - 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();

    final selected = _selectedIndex;

    final labelsLength = labels.length;
    final textStyle = theme.textTheme.bodyMedium;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          width: width,
          child: Stack(
            children: [
              Opacity(opacity: 0, child: Text(labels.first, style: textStyle)),
              for (var i = 0; i < labelsLength; i++)
                Positioned(
                  left: i < labelsLength - 1
                      ? i / (labelsLength - 1) * width
                      : null,
                  right: i == labelsLength - 1 ? 0 : null,
                  child: FractionalTranslation(
                    translation: Offset(
                      i == 0 || i == labelsLength - 1 ? 0 : -0.5,
                      0,
                    ),
                    child: Text(
                      labels[i],
                      style: textStyle?.copyWith(
                        color: i == selected
                            ? colors?.onSurface
                            : colors?.onSurfaceMuted,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _GradientTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  const _GradientTrackShape({
    required this.gradient,
    required this.trackColor,
  });

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    Offset offset = Offset.zero,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight ?? 2.0;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    return Rect.fromLTWH(
      offset.dx,
      trackTop,
      parentBox.size.width,
      trackHeight,
    );
  }

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

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, radius),
      Paint()..color = trackColor,
    );

    final activeRight = thumbCenter.dx.clamp(trackRect.left, trackRect.right);
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
  const _RingThumbShape({required this.gradient});

  final LinearGradient gradient;

  static const double _radius = 7;
  static const double _ringWidth = 4;

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
    final rect = Rect.fromCircle(center: center, radius: _radius);
    context.canvas
      ..drawCircle(
        center,
        _radius + _ringWidth + 2,
        Paint()
          ..color = Colors.black.withValues(alpha: 0.12)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      )
      ..drawCircle(center, _radius + _ringWidth, Paint()..color = Colors.white)
      ..drawCircle(
        center,
        _radius,
        Paint()..shader = gradient.createShader(rect),
      );
  }
}

class _VerticalTickMarkShape extends SliderTickMarkShape {
  const _VerticalTickMarkShape({required this.color});

  final Color color;

  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    required bool isEnabled,
  }) => const Size(1, 8);

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
    if (center.dx <= thumbCenter.dx || center.dx >= parentBox.size.width - 4) {
      return;
    }
    final halfTrack = (sliderTheme.trackHeight ?? 8.0) / 2;
    context.canvas.drawLine(
      Offset(center.dx, center.dy - halfTrack - 3),
      Offset(center.dx, center.dy + halfTrack + 3),
      Paint()
        ..color = color
        ..strokeWidth = 1.0,
    );
  }
}

abstract final class _SliderColors {
  static const fillStart = Color(0xFF2461EB);
  static const fillEnd = Color(0xFFD4C6FB);
  static const track = Color(0xFFE2E8F9);
  static const thumb = Color(0xFF7C8FF5);
}
