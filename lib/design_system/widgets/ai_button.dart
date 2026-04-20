import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:genui_life_goal_simulator/design_system/app_colors.dart';
import 'package:genui_life_goal_simulator/design_system/app_text_styles.dart';
import 'package:genui_life_goal_simulator/design_system/spacing.dart';

class AiButton extends StatelessWidget {
  const AiButton({
    required this.text,
    required this.onTap,
    this.borderRadius = 100,
    this.borderWidth = 2,
    this.iconSize = 18,
    super.key,
  });

  final String text;
  final VoidCallback onTap;

  /// Corner radius of the pill-shaped button.
  final double borderRadius;

  /// Thickness of the gradient border drawn around the button.
  final double borderWidth;

  /// Size of the leading star icon.
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: colors.geniusGradient,
          ),
          child: Padding(
            padding: EdgeInsets.all(borderWidth),
            child: Ink(
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(
                  borderRadius - borderWidth,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.xxxl,
                  vertical: Spacing.xs,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/onboarding/soft_star.svg',
                      width: iconSize,
                      height: iconSize,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      text,
                      style: AppTextStyles.labelLargeMobile.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
