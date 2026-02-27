import 'package:finance_app/app/presentation/app_colors.dart';
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

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_Dimensions.borderRadius),
        gradient: LinearGradient(
          colors: [
            colorExtension?.secondary.shade500 ?? const Color(0xFF2461EB),
            colorExtension?.secondary.shade400 ?? const Color(0xFFD4C6FB),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            offset: Offset(4, 4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(_Dimensions.borderWidth),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            _Dimensions.borderRadius - _Dimensions.borderWidth,
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
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
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: _Dimensions.fontSize,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF232326),
                      height: _Dimensions.lineHeight / _Dimensions.fontSize,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                ],
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
  static const double fontSize = 16;
  static const double lineHeight = 20;
  static const double verticalPadding = 8;
}
