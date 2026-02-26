import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';

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
    final colorScheme = themeOf.colorScheme;
    final colorExtension = themeOf.extension<AppColors>();
    final textTheme = themeOf.textTheme;
    final iconSize = responsiveValue(
      context,
      mobile: Spacing.lg,
      desktop: _Dimensions.iconSize,
    );
    final textSize = responsiveValue(
      context,
      mobile: _Dimensions.mobileTextSize,
      desktop: _Dimensions.fontSize,
    );

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(Spacing.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Spacing.lg),
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected
                ? colorExtension?.secondary.shade300
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(Spacing.lg),
            border: Border.all(
              color:
                  (isSelected
                      ? colorExtension?.secondary.shade600
                      : colorExtension?.secondary.shade50) ??
                  colorScheme.primary,
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
                  Assets.images.onboarding.checkedOption.image(
                    width: iconSize,
                    height: iconSize,
                  ),
                  const SizedBox(width: Spacing.md),
                ],
                Flexible(
                  child: Text(
                    label,
                    style: textTheme.bodyLarge?.copyWith(
                      fontSize: textSize,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: colorScheme.primary,
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
  static const double fontSize = 32;
  static const double mobileTextSize = 18;
}
