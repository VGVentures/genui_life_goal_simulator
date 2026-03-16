import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:finance_app/onboarding/pick_profile/pick_profile.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    required this.profileType,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final ProfileType profileType;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorExtensions = Theme.of(context).extension<AppColors>();
    final beginnerColor = colorExtensions?.primary ?? const Color(0xFF6D92F5);
    final optimizerColor = colorExtensions?.pinkColor;
    final l10n = context.l10n;
    final isOptimizer = profileType == ProfileType.optimizer;
    final titleColor = isOptimizer ? optimizerColor : beginnerColor;

    final title = isOptimizer
        ? l10n.profileOptimizerTitle
        : l10n.profileBeginnerTitle;
    final description = isOptimizer
        ? l10n.profileOptimizerDescription
        : l10n.profileBeginnerDescription;

    final isMobile = Breakpoints.isMobile(MediaQuery.of(context).size.width);

    final rotation = isMobile ? 0.0 : (isOptimizer ? 0.09 : -0.09);

    return Transform.rotate(
      angle: rotation,
      child: ConstrainedBox(
        constraints: isMobile
            ? const BoxConstraints(minHeight: 250)
            : const BoxConstraints(minHeight: 400),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Ink(
              decoration: BoxDecoration(
                color: isSelected
                    ? Color.alphaBlend(
                        beginnerColor.withValues(alpha: 0.1),
                        colorExtensions?.surfaceVariant ?? Colors.white,
                      )
                    : colorExtensions?.surfaceVariant ?? Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? beginnerColor : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(isMobile ? Spacing.md : Spacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      profileType.iconAsset,
                      width: isMobile
                          ? _Dimensions.mobileIconSize
                          : _Dimensions.iconSize,
                      height: isMobile
                          ? _Dimensions.mobileIconSize
                          : _Dimensions.iconSize,
                    ),
                    SizedBox(
                      height: isMobile ? Spacing.xl : (Spacing.xxxl * 3),
                    ),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          (isMobile
                                  ? AppTextStyles.displaySmallMobile
                                  : AppTextStyles.displayLargeDesktop)
                              .copyWith(color: titleColor),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      description,
                      style: isMobile
                          ? AppTextStyles.titleMediumMobile.copyWith(
                              color: colorExtensions?.onSurfaceVariant,
                            )
                          : AppTextStyles.headlineLargeDesktop.copyWith(
                              color: colorExtensions?.onSurfaceVariant,
                              fontWeight: FontWeight.w400,
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

extension on ProfileType {
  String get iconAsset => switch (this) {
    ProfileType.beginner => 'assets/images/onboarding/StarBegginer.png',
    ProfileType.optimizer => 'assets/images/onboarding/StarOptimizer.png',
  };
}

abstract final class _Dimensions {
  static const double iconSize = 120;
  static const double mobileIconSize = 60;
}
