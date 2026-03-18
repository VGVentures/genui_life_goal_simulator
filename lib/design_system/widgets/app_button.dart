import 'package:flutter/material.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';
import 'package:vgv_genui_financial_advisor/gen/fonts.gen.dart';
import 'package:vgv_genui_financial_advisor/l10n/l10n.dart';

/// Visual variant for [AppButton].
enum AppButtonVariant {
  /// Filled button with primary blue background and white text.
  filled,

  /// Outlined button with primary blue 1.5px border and dark text.
  outlined,
}

/// Size variant for [AppButton].
enum AppButtonSize {
  /// Large: 48px height, 16px horizontal padding.
  large,

  /// Small: 40px height, 12px horizontal padding.
  small,
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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();

    final primary = colors?.primary ?? _Colors.primary;
    final onPrimary = colors?.onPrimary ?? _Colors.onPrimary;
    final onSurface = colors?.onSurface ?? _Colors.onSurface;

    final style = _buttonStyle(
      primary: primary,
      onPrimary: onPrimary,
      onSurface: onSurface,
    );

    // When loading, disable the button entirely.
    final effectiveOnPressed = isLoading ? null : onPressed;

    final child = _buildChild(
      context,
      primary: primary,
      onPrimary: onPrimary,
    );

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
    };
  }

  Widget _buildChild(
    BuildContext context, {
    required Color primary,
    required Color onPrimary,
  }) {
    if (isLoading) {
      final colors = Theme.of(context).extension<AppColors>();
      final indicatorColor = colors?.onSurfaceMuted ?? const Color(0xFF909191);
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: _Dimensions.loadingIndicatorSize,
            child: CircularProgressIndicator(
              strokeWidth: _Dimensions.loadingStrokeWidth,
              color: indicatorColor,
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
          const SizedBox(width: Spacing.xs),
        ],
        Text(label),
        if (trailingIcon != null) ...[
          const SizedBox(width: Spacing.xs),
          trailingIcon!,
        ],
      ],
    );
  }

  ButtonStyle _buttonStyle({
    required Color primary,
    required Color onPrimary,
    required Color onSurface,
  }) {
    final height = size == AppButtonSize.large
        ? _Dimensions.largeHeight
        : _Dimensions.smallHeight;
    final horizontalPadding = size == AppButtonSize.large
        ? _Dimensions.largePadding
        : _Dimensions.smallPadding;

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return _Colors.disabledBackground;
        }
        return switch (variant) {
          AppButtonVariant.filled => _resolveFilledBackground(states, primary),
          AppButtonVariant.outlined => _resolveOutlinedBackground(
            states,
            primary,
          ),
        };
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return _Colors.disabledText;
        }
        return switch (variant) {
          AppButtonVariant.filled => onPrimary,
          AppButtonVariant.outlined => onSurface,
        };
      }),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.focused)) {
          return const BorderSide(
            color: _Colors.focusRing,
            width: _Dimensions.focusRingWidth,
          );
        }
        if (variant == AppButtonVariant.outlined) {
          if (states.contains(WidgetState.disabled)) {
            return const BorderSide(
              color: _Colors.disabledOutline,
              width: _Dimensions.outlineBorderWidth,
            );
          }
          return BorderSide(
            color: primary,
            width: _Dimensions.outlineBorderWidth,
          );
        }
        return BorderSide.none;
      }),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_Dimensions.pillRadius),
        ),
      ),
      padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(horizontal: horizontalPadding),
      ),
      minimumSize: WidgetStateProperty.all(
        Size(_Dimensions.minWidth, height),
      ),
      tapTargetSize: MaterialTapTargetSize.padded,
      textStyle: WidgetStateProperty.all(_Dimensions.labelTextStyle),
      elevation: WidgetStateProperty.all(0),
    );
  }

  static Color _resolveFilledBackground(
    Set<WidgetState> states,
    Color primary,
  ) {
    if (states.contains(WidgetState.pressed)) {
      return Color.lerp(primary, Colors.black, 0.2)!;
    }
    if (states.contains(WidgetState.focused)) {
      return Color.lerp(primary, Colors.black, 0.2)!;
    }
    if (states.contains(WidgetState.hovered)) {
      return Color.lerp(primary, Colors.black, 0.1)!;
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

abstract final class _Dimensions {
  static const double largeHeight = 48;
  static const double smallHeight = 40;
  static const double largePadding = 16;
  static const double smallPadding = 12;
  static const double pillRadius = 100;
  static const double minWidth = 72;
  static const double outlineBorderWidth = 1.5;
  static const double focusRingWidth = 3;
  static const double loadingIndicatorSize = 16;
  static const double loadingStrokeWidth = 2;

  static const TextStyle labelTextStyle = TextStyle(
    fontFamily: FontFamily.poppins,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: -0.15,
  );
}

abstract final class _Colors {
  static const Color primary = Color(0xFF6D92F5);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1A1C1C);
  static const Color disabledBackground = Color(0xFFF0F1F1);
  static const Color disabledText = Color(0xFFAAABAB);
  static const Color disabledOutline = Color(0xFFAAABAB);
  static const Color focusRing = Color(0xFF6D6D6D);
}
