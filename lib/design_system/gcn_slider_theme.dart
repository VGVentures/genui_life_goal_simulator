import 'package:flutter/material.dart';

/// Theme for the GCN slider's bespoke thumb visuals.
///
/// These colors aren't tied to light/dark surfaces the same way the rest of
/// the app color tokens are — the thumb sits on a gradient and uses a fixed
/// ring and shadow to stay legible across themes.
class GCNSliderTheme extends ThemeExtension<GCNSliderTheme> {
  const GCNSliderTheme({
    required this.thumbRingColor,
    required this.thumbShadowColor,
  });

  /// Color of the circular ring around the gradient thumb.
  final Color thumbRingColor;

  /// Color of the soft shadow rendered behind the thumb ring.
  final Color thumbShadowColor;

  @override
  GCNSliderTheme copyWith({
    Color? thumbRingColor,
    Color? thumbShadowColor,
  }) => GCNSliderTheme(
    thumbRingColor: thumbRingColor ?? this.thumbRingColor,
    thumbShadowColor: thumbShadowColor ?? this.thumbShadowColor,
  );

  @override
  GCNSliderTheme lerp(GCNSliderTheme? other, double t) {
    if (other == null) return this;
    return GCNSliderTheme(
      thumbRingColor:
          Color.lerp(thumbRingColor, other.thumbRingColor, t) ?? thumbRingColor,
      thumbShadowColor:
          Color.lerp(thumbShadowColor, other.thumbShadowColor, t) ??
          thumbShadowColor,
    );
  }
}

/// Convenience accessor for [GCNSliderTheme] on the current theme.
extension GCNSliderThemeX on BuildContext {
  /// The [GCNSliderTheme] registered on the current theme.
  GCNSliderTheme get gcnSliderTheme =>
      Theme.of(this).extension<GCNSliderTheme>()!;
}

/// Light-theme variant of [GCNSliderTheme].
const lightGCNSliderTheme = GCNSliderTheme(
  thumbRingColor: Color(0xFFFFFFFF),
  thumbShadowColor: Color(0xFF000000),
);

/// Dark-theme variant of [GCNSliderTheme].
const darkGCNSliderTheme = GCNSliderTheme(
  thumbRingColor: Color(0xFFFFFFFF),
  thumbShadowColor: Color(0xFF000000),
);
