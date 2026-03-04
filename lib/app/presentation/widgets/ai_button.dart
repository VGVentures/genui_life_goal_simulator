import 'package:finance_app/app/presentation/app_colors.dart';
import 'package:finance_app/app/presentation/app_text_styles.dart';
import 'package:finance_app/app/presentation/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AiButton extends StatelessWidget {
  const AiButton({
    required this.text,
    required this.onTap,
    super.key,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorExtension = Theme.of(context).extension<AppColors>();

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(_Dimensions.borderRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_Dimensions.borderRadius),
            gradient: colorExtension?.geniusGradient,
          ),
          child: Padding(
            padding: const EdgeInsets.all(_Dimensions.borderWidth),
            child: Ink(
              decoration: BoxDecoration(
                color: colorExtension?.surfaceVariant,
                borderRadius: BorderRadius.circular(
                  _Dimensions.borderRadius - _Dimensions.borderWidth,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.xxxl,
                  vertical: _Dimensions.verticalPadding,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/onboarding/soft_star.svg',
                      width: _Dimensions.iconSize,
                      height: _Dimensions.iconSize,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      text,
                      style: AppTextStyles.labelLargeMobile.copyWith(
                        color: colorExtension?.onSurface,
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

abstract final class _Dimensions {
  static const double borderRadius = 100;
  static const double borderWidth = 2;
  static const double iconSize = 18;
  static const double verticalPadding = 8;
}
