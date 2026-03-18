import 'package:flutter/material.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';
import 'package:vgv_genui_financial_advisor/gen/assets.gen.dart';

/// {@template onboarding_next_button}
/// A circular forward-arrow button used across onboarding screens.
///
/// Provides consistent sizing (responsive) and a subtle hover effect.
/// {@endtemplate}
class OnboardingNextButton extends StatelessWidget {
  /// {@macro onboarding_next_button}
  const OnboardingNextButton({
    required this.onPressed,
    this.borderColor,
    this.iconColor,
    this.backgroundColor,
    super.key,
  });

  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  /// Border color. Defaults to [AppColors.primary].
  final Color? borderColor;

  /// Icon color. Defaults to [AppColors.primary].
  final Color? iconColor;

  ///Button background color. Defaults to [AppColors.primary]
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
    final isDisabled = onPressed == null;
    final effectiveBorderColor =
        (!isDisabled ? borderColor : colors?.onSurfaceDisabled) ??
        colors?.primary ??
        Colors.white;
    final effectiveIconColor =
        (!isDisabled ? iconColor : colors?.onSurfaceDisabled) ??
        colors?.primary ??
        Colors.white;
    final size = responsiveValue(
      context,
      mobile: _Dimensions.mobileSize,
      desktop: _Dimensions.desktopSize,
    );
    final iconSize = responsiveValue(
      context,
      mobile: _Dimensions.mobileIconSize,
      desktop: _Dimensions.desktopIconSize,
    );

    return SizedBox(
      width: size,
      height: size,
      child: OutlinedButton(
        onPressed: onPressed,
        style:
            OutlinedButton.styleFrom(
              shape: const CircleBorder(),
              side: BorderSide(color: effectiveBorderColor),
              backgroundColor: backgroundColor ?? colors?.primarySurface,
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return effectiveBorderColor.withValues(alpha: 0.20);
                }
                if (states.contains(WidgetState.hovered)) {
                  return effectiveBorderColor.withValues(alpha: 0.15);
                }
                return Colors.transparent;
              }),
            ),
        child: Assets.images.onboarding.rightArrow.svg(
          colorFilter: ColorFilter.mode(
            effectiveIconColor,
            BlendMode.srcIn,
          ),
          width: iconSize,
          height: iconSize,
        ),
      ),
    );
  }
}

abstract final class _Dimensions {
  static const double mobileSize = 80;
  static const double desktopSize = 140;
  static const double mobileIconSize = 16;
  static const double desktopIconSize = 21;
}
