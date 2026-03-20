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
    super.key,
  });

  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  /// Border color. Defaults to [AppColors.primary].
  final Color? borderColor;

  /// Icon color. Defaults to [AppColors.primary].
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
    final effectiveBorderColor = borderColor ?? colors?.primary ?? Colors.white;
    final effectiveIconColor = iconColor ?? colors?.primary ?? Colors.white;
    final isDisabled = onPressed == null;
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

    return Opacity(
      opacity: isDisabled ? _disabledOpacity : 1.0,
      child: SizedBox(
        width: size,
        height: size,
        child: OutlinedButton(
          onPressed: onPressed,
          style:
              OutlinedButton.styleFrom(
                shape: const CircleBorder(),
                side: BorderSide(color: effectiveBorderColor),
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.zero,
              ).copyWith(
                overlayColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return effectiveBorderColor.withValues(alpha: 0.15);
                  }
                  if (states.contains(WidgetState.hovered)) {
                    return effectiveBorderColor.withValues(alpha: 0.08);
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
      ),
    );
  }

  static const double _disabledOpacity = 0.4;
}

abstract final class _Dimensions {
  static const double mobileSize = 72;
  static const double desktopSize = 96;
  static const double mobileIconSize = 14;
  static const double desktopIconSize = 20;
}
