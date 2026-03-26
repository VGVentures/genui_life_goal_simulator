import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/gen/assets.gen.dart';

class SelectableOptionCard extends StatelessWidget {
  const SelectableOptionCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final themeOf = Theme.of(context);
    final colorExtension = themeOf.extension<AppColors>();
    final iconSize = responsiveValue(
      context,
      mobile: Spacing.lg,
      desktop: _Dimensions.iconSize,
    );

    return Material(
      color: colorExtension?.onPrimary,
      borderRadius: BorderRadius.circular(Spacing.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(Spacing.lg),
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected
                ? colorExtension?.primary.withValues(alpha: 0.1)
                : colorExtension?.onPrimary,
            borderRadius: BorderRadius.circular(Spacing.lg),
            border: Border.all(
              color: isSelected
                  ? colorExtension?.primary ?? Colors.white
                  : Colors.transparent,
              width: _Dimensions.borderWidth,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: responsiveValue(
                context,
                mobile: _Dimensions.mobileVerticalPadding,
                desktop: _Dimensions.verticalPadding,
              ),
              horizontal: responsiveValue(
                context,
                mobile: Spacing.xs,
                desktop: _Dimensions.horizontalPadding,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isSelected) ...[
                  Assets.images.onboarding.checkedOption.svg(
                    width: iconSize,
                    height: iconSize,
                    // color: colorExtension?.primary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: Spacing.md),
                ],
                Flexible(
                  child: Text(
                    label,
                    style:
                        responsiveValue<TextStyle>(
                          context,
                          mobile: AppTextStyles.titleMediumMobile,
                          desktop: AppTextStyles.headlineLargeDesktop,
                        ).copyWith(
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? colorExtension?.onSurface
                              : colorExtension?.onSurfaceVariant,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

abstract final class _Dimensions {
  static const double iconSize = 40;
  static const double borderWidth = 2;
  static const double horizontalPadding = 40;
  static const double verticalPadding = 44;
  static const double mobileVerticalPadding = 17;
}
