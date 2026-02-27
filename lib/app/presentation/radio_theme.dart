import 'package:flutter/material.dart';

/// Radio button theme configuration matching Figma design system.
RadioThemeData get radioThemeData => RadioThemeData(
  fillColor: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.disabled)) {
      return RadioColors.disabled;
    }
    if (states.contains(WidgetState.error)) {
      return RadioColors.error;
    }
    return RadioColors.primary;
  }),
  overlayColor: WidgetStateProperty.resolveWith((states) {
    final isError = states.contains(WidgetState.error);
    if (states.contains(WidgetState.pressed)) {
      return isError ? RadioColors.errorPressed : RadioColors.primaryPressed;
    }
    if (states.contains(WidgetState.focused)) {
      return isError ? RadioColors.errorFocused : RadioColors.primaryFocused;
    }
    if (states.contains(WidgetState.hovered)) {
      return isError ? RadioColors.errorHovered : RadioColors.primaryHovered;
    }
    return Colors.transparent;
  }),
  splashRadius: 24,
  materialTapTargetSize: MaterialTapTargetSize.padded,
  visualDensity: VisualDensity.standard,
);

/// Radio button colors from design system.
abstract final class RadioColors {
  /// Primary selected/unselected color: #6d92f5
  static const Color primary = Color(0xFF6D92F5);

  /// Primary hovered background: #f3f6ff (primary-container from Figma)
  static const Color primaryHovered = Color(0xFFF3F6FF);

  /// Primary focused overlay (12% opacity)
  static const Color primaryFocused = Color(0x1F6D92F5);

  /// Primary pressed overlay (16% opacity)
  static const Color primaryPressed = Color(0x296D92F5);

  /// Error color: #BB1B1B
  static const Color error = Color(0xFFBB1B1B);

  /// Error hovered: rgba(187, 27, 27, 0.08)
  static const Color errorHovered = Color(0x14BB1B1B);

  /// Error focused: rgba(187, 27, 27, 0.12)
  static const Color errorFocused = Color(0x1FBB1B1B);

  /// Error pressed: rgba(187, 27, 27, 0.16)
  static const Color errorPressed = Color(0x29BB1B1B);

  /// Disabled color: #aaabab
  static const Color disabled = Color(0xFFAAABAB);
}
