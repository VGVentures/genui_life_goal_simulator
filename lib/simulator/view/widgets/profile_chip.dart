import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/gen/assets.gen.dart';
import 'package:genui_life_goal_simulator/l10n/l10n.dart';
import 'package:genui_life_goal_simulator/onboarding/pick_profile/pick_profile.dart';

class ProfileChip extends StatelessWidget {
  const ProfileChip({
    required this.profileType,
    required this.onTap,
    super.key,
  });

  final ProfileType profileType;
  final VoidCallback onTap;

  String _profileLabel(AppLocalizations l10n) => switch (profileType) {
    ProfileType.beginner => l10n.profileBeginnerTitle,
    ProfileType.optimizer => l10n.profileOptimizerTitle,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>();
    final isMobile = Breakpoints.isMobile(
      MediaQuery.sizeOf(context).width,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_Dimensions.buttonRadius),
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 0 : Spacing.md,
            vertical: Spacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: Spacing.xxs,
            children: [
              if (profileType == ProfileType.beginner)
                Assets.images.onboarding.starBeginner.svg(
                  width: _Dimensions.iconSize,
                  height: _Dimensions.iconSize,
                )
              else
                Assets.images.onboarding.starOptimizer.svg(
                  width: _Dimensions.iconSize,
                  height: _Dimensions.iconSize,
                ),
              if (!isMobile)
                Text(
                  _profileLabel(l10n),
                  style: textTheme.labelLarge?.copyWith(
                    color: colors?.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

abstract final class _Dimensions {
  static const double iconSize = 19;
  static const double buttonRadius = 100;
}
