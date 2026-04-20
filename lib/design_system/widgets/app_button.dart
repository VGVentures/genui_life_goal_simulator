import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/gen/fonts.gen.dart';
import 'package:genui_life_goal_simulator/l10n/l10n.dart';

/// Visual variant for [AppButton].
enum AppButtonVariant {
  /// Filled button with primary blue background and white text.
  filled,

  /// Outlined button with primary blue 1.5px border and dark text.
  outlined,

  /// Gradient button with a linear gradient background and white text.
  gradient,
}

/// Size variant for [AppButton].
enum AppButtonSize {
  /// Large: 48px height, 16px horizontal padding.
  large(height: 48, horizontalPadding: Spacing.md),

  /// Small: 40px height, 12px horizontal padding.
  small(height: 40, horizontalPadding: Spacing.sm)
  ;

  const AppButtonSize({
    required this.height,
    required this.horizontalPadding,
  });

  /// The fixed height for this button size.
  final double height;

  /// The horizontal padding applied to the button at this size.
  final double horizontalPadding;
}

/// {@template app_button}
/// A configurable button supporting filled and outlined variants with two
/// sizes (large / small), optional leading/trailing icons, and a loading state.
///
/// Uses [FilledButton] internally for the [AppButtonVariant.filled] style and
/// [OutlinedButton] for [AppButtonVariant.outlined].
/// {@endtemplate}
class AppButton extends StatelessWidget {
  /// {@macro app_button}
  const AppButton({
    required this.label,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.large,
    this.onPressed,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.pillRadius = 100,
    this.minWidth = 72,
    this.outlineBorderWidth = 1.5,
    this.focusRingWidth = 3,
    this.loadingIndicatorSize = Spacing.md,
    this.loadingStrokeWidth = 2,
    super.key,
  });

  /// Button label text.
  final String label;

  /// Visual style of the button.
  final AppButtonVariant variant;

  /// Size of the button.
  final AppButtonSize size;

  /// Called when the button is tapped. Pass `null` to disable the button.
  final VoidCallback? onPressed;

  /// When `true`, displays a [CircularProgressIndicator] with "Loading…" text
  /// and prevents further taps.
  final bool isLoading;

  /// Optional icon displayed before the label.
  final Widget? leadingIcon;

  /// Optional icon displayed after the label.
  final Widget? trailingIcon;

  /// Corner radius used for the pill-shaped border.
  final double pillRadius;

  /// Minimum width of the button.
  final double minWidth;

  /// Border width for the outlined variant.
  final double outlineBorderWidth;

  /// Border width drawn when the button is focused.
  final double focusRingWidth;

  /// Size of the loading indicator shown when [isLoading] is `true`.
  final double loadingIndicatorSize;

  /// Stroke width of the loading indicator.
  final double loadingStrokeWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final style = _buttonStyle(colors: colors);

    // When loading, disable the button entirely.
    final effectiveOnPressed = isLoading ? null : onPressed;

    final child = _buildChild(context, colors: colors);

    return switch (variant) {
      AppButtonVariant.filled => FilledButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: child,
      ),
      AppButtonVariant.outlined => OutlinedButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: child,
      ),
      AppButtonVariant.gradient => FilledButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: child,
      ),
    };
  }

  Widget _buildChild(
    BuildContext context, {
    required AppColors colors,
  }) {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: loadingIndicatorSize,
            child: CircularProgressIndicator(
              strokeWidth: loadingStrokeWidth,
              color: colors.onSurfaceMuted,
            ),
          ),
          const SizedBox(width: Spacing.xs),
          Text(context.l10n.appButtonLoadingLabel),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[
          leadingIcon!,
          SizedBox(width: label.isNotEmpty ? Spacing.xs : 0),
        ],
        Text(label),
        if (trailingIcon != null) ...[
          SizedBox(width: label.isNotEmpty ? Spacing.xs : 0),
          trailingIcon!,
        ],
      ],
    );
  }

  ButtonStyle _buttonStyle({required AppColors colors}) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.surfaceContainer;
        }
        return switch (variant) {
          AppButtonVariant.filled => _resolveFilledBackground(states, colors),
          AppButtonVariant.outlined => _resolveOutlinedBackground(
            states,
            colors.primary,
          ),
          AppButtonVariant.gradient => Colors.transparent,
        };
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.onSurfaceDisabled;
        }
        return switch (variant) {
          AppButtonVariant.filled => colors.onPrimary,
          AppButtonVariant.outlined => colors.onSurface,
          AppButtonVariant.gradient => colors.onPrimary,
        };
      }),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.focused)) {
          return BorderSide(
            color: colors.onSurfaceVariant,
            width: focusRingWidth,
          );
        }
        if (variant == AppButtonVariant.outlined) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(
              color: colors.onSurfaceDisabled,
              width: outlineBorderWidth,
            );
          }
          return BorderSide(
            color: colors.primary,
            width: outlineBorderWidth,
          );
        }
        return BorderSide.none;
      }),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(pillRadius),
        ),
      ),
      padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(horizontal: size.horizontalPadding),
      ),
      minimumSize: WidgetStateProperty.all(
        Size(minWidth, size.height),
      ),
      tapTargetSize: MaterialTapTargetSize.padded,
      textStyle: WidgetStateProperty.all(_labelTextStyle),
      elevation: WidgetStateProperty.all(0),
      backgroundBuilder: variant == AppButtonVariant.gradient
          ? (context, states, child) {
              final isDisabled = states.contains(WidgetState.disabled);
              final isHovered = states.contains(WidgetState.hovered);
              final isPressed = states.contains(WidgetState.pressed);
              final isFocused = states.contains(WidgetState.focused);
              final overlay = colors.onPrimary;

              return DecoratedBox(
                decoration: BoxDecoration(
                  gradient: isDisabled ? null : colors.geniusGradient,
                  borderRadius: BorderRadius.circular(pillRadius),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isPressed || isFocused
                        ? overlay.withValues(alpha: 0.2)
                        : isHovered
                        ? overlay.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(pillRadius),
                  ),
                  child: child,
                ),
              );
            }
          : null,
    );
  }

  static Color _resolveFilledBackground(
    Set<WidgetState> states,
    AppColors colors,
  ) {
    final primary = colors.primary;
    final overlay = colors.onSurface;
    if (states.contains(WidgetState.pressed)) {
      return Color.lerp(primary, overlay, 0.2)!;
    }
    if (states.contains(WidgetState.focused)) {
      return Color.lerp(primary, overlay, 0.2)!;
    }
    if (states.contains(WidgetState.hovered)) {
      return Color.lerp(primary, overlay, 0.1)!;
    }
    return primary;
  }

  static Color _resolveOutlinedBackground(
    Set<WidgetState> states,
    Color primary,
  ) {
    if (states.contains(WidgetState.pressed)) {
      return primary.withValues(alpha: 0.2);
    }
    if (states.contains(WidgetState.focused)) {
      return primary.withValues(alpha: 0.2);
    }
    if (states.contains(WidgetState.hovered)) {
      return primary.withValues(alpha: 0.1);
    }
    return Colors.transparent;
  }
}

const _labelTextStyle = TextStyle(
  fontFamily: FontFamily.poppins,
  fontSize: 14,
  fontWeight: FontWeight.w500,
  height: 20 / 14,
  letterSpacing: -0.15,
);
