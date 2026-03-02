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
    final beginnerColor =
        colorExtensions?.secondary.shade600 ?? const Color(0xFF6D92F5);
    final l10n = context.l10n;
    final isOptimizer = profileType == ProfileType.optimizer;
    final titleColor = isOptimizer ? _kOptimizerColor : beginnerColor;

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
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: isMobile
              ? const BoxConstraints(minHeight: 250)
              : const BoxConstraints(minHeight: 400),
          decoration: BoxDecoration(
            color: Colors.white,
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
          padding: EdgeInsets.all(
            isMobile ? _Dimensions.mobilePadding : _Dimensions.padding,
          ),
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
                height: isMobile
                    ? _Dimensions.mobileIconTitleSpacing
                    : _Dimensions.iconTitleSpacing,
              ),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isMobile
                      ? _Dimensions.mobileTitleFontSize
                      : _Dimensions.titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                description,
                style: TextStyle(
                  color: _kTextColor,
                  fontSize: isMobile
                      ? _Dimensions.mobileDescFontSize
                      : _Dimensions.descFontSize,
                  height: 1.4,
                ),
              ),
            ],
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

const _kOptimizerColor = Color(0xFFFFB1EE);
const _kTextColor = Color(0xFF1A1A2E);

abstract final class _Dimensions {
  static const double padding = 24;
  static const double mobilePadding = 16;
  static const double iconSize = 120;
  static const double mobileIconSize = 60;
  static const double iconTitleSpacing = 100;
  static const double mobileIconTitleSpacing = 24;
  static const double titleFontSize = 40;
  static const double mobileTitleFontSize = 25.34;
  static const double descFontSize = 32;
  static const double mobileDescFontSize = 18;
}
