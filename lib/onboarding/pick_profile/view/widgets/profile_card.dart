import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/gen/assets.gen.dart';
import 'package:genui_life_goal_simulator/l10n/l10n.dart';
import 'package:genui_life_goal_simulator/onboarding/pick_profile/pick_profile.dart';

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
                    profileType.iconWidget(
                      size: isMobile
                          ? _Dimensions.mobileIconSize
                          : _Dimensions.iconSize,
                    ),
                    if (isMobile)
                      const SizedBox(height: Spacing.xl)
                    else
                      const Spacer(),
                    SizedBox(
                      width: isMobile ? null : _Dimensions.textWidth,
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            (isMobile
                                    ? AppTextStyles.displaySmallMobile
                                    : AppTextStyles.displayLargeDesktop)
                                .copyWith(
                                  color: titleColor,
                                  fontSize: isMobile ? null : _FontSizes.title,
                                ),
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    SizedBox(
                      width: isMobile ? null : _Dimensions.textWidth,
                      child: Text(
                        description,
                        style: isMobile
                            ? AppTextStyles.titleMediumMobile.copyWith(
                                color: colorExtensions?.onSurfaceVariant,
                              )
                            : AppTextStyles.headlineLargeDesktop.copyWith(
                                color: colorExtensions?.onSurfaceVariant,
                                fontWeight: FontWeight.w400,
                                fontSize: _FontSizes.description,
                              ),
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
  Widget iconWidget({required double size}) => switch (this) {
    ProfileType.beginner => Assets.images.onboarding.starBeginner.svg(
      width: size,
      height: size,
    ),
    ProfileType.optimizer => Assets.images.onboarding.starOptimizer.svg(
      width: size,
      height: size,
    ),
  };
}

abstract final class _Dimensions {
  static const double iconSize = 120;
  static const double mobileIconSize = 60;
  static const double textWidth = 402;
}

abstract final class _FontSizes {
  static const double title = 48;
  static const double description = 32;
}
