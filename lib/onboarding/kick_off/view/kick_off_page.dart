import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';
import 'package:vgv_genui_financial_advisor/l10n/l10n.dart';
import 'package:vgv_genui_financial_advisor/onboarding/kick_off/view/desktop_kick_off_view.dart';
import 'package:vgv_genui_financial_advisor/onboarding/kick_off/view/kick_off_values.dart';
import 'package:vgv_genui_financial_advisor/onboarding/kick_off/view/mobile_kick_off_view.dart';
import 'package:vgv_genui_financial_advisor/onboarding/kick_off/view/widgets/trust_badge.dart';
import 'package:vgv_genui_financial_advisor/onboarding/pick_profile/view/pick_profile_page.dart';
import 'package:vgv_genui_financial_advisor/onboarding/widgets/widgets.dart';

class KickOffPage extends StatelessWidget {
  const KickOffPage({super.key});

  void _onNextPressed(BuildContext context) {
    unawaited(
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const PickProfilePage(),
        ),
      ),
    );
  }

  Widget _buildBody({
    required AppLocalizations l10n,
    required AppColors appColors,
    required TextStyle badgeLargeStyle,
    required TextStyle badgeMediumStyle,
    required TextStyle titleStyle,
    required TextStyle descriptionStyle,
    required String descriptionText,
    Alignment alignment = Alignment.center,
    double? descriptionWidth,
    double trustBadgeTop = 5,
    double trustBadgeIconSize = 30,
    double? badgesToTitleGap,
  }) {
    return Align(
      alignment: alignment,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: KickOffValues.maxContentWidth,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: KickOffValues.badgesStackHeight,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        bottom: 0,
                        child: Transform.rotate(
                          angle: -KickOffValues.badgeRotationAngleSmall,
                          child: TrustBadge(
                            text: l10n.notHardcodedBadgeText,
                            backgroundColor: appColors.primaryStrong,
                            textColor: Colors.white,
                            textStyle: badgeLargeStyle,
                          ),
                        ),
                      ),
                      Positioned(
                        top: trustBadgeTop,
                        child: Transform.rotate(
                          angle: KickOffValues.badgeRotationAngle,
                          child: TrustBadge(
                            text: l10n.trustBadgeText,
                            backgroundColor: const Color(0xFFF0F0F0),
                            textColor: appColors.onPrimaryContainer,
                            icon: SvgPicture.asset(
                              'assets/icons_kick_off/trust_icon.svg',
                              width: trustBadgeIconSize,
                              height: trustBadgeIconSize,
                            ),
                            textStyle: badgeMediumStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: badgesToTitleGap ?? KickOffValues.titleTopGap),
                Text(
                  l10n.kickOffTitle,
                  style: titleStyle.copyWith(
                    color: const Color(0xFFF9FAFB),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: KickOffValues.titleDescriptionGap),
          SizedBox(
            width: descriptionWidth,
            child: Text(
              descriptionText,
              style: descriptionStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final appColors = Theme.of(context).extension<AppColors>()!;
    final bgColor = appColors.primary;

    final mobileBody = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: _buildBody(
        l10n: l10n,
        appColors: appColors,
        badgeLargeStyle: AppTextStyles.bodyLargeMobile,
        badgeMediumStyle: AppTextStyles.bodyMediumMobile,
        titleStyle: AppTextStyles.displayLargeDesktop.copyWith(
          color: appColors.onPrimary,
        ),
        descriptionStyle: AppTextStyles.titleMediumMobile.copyWith(
          color: appColors.onInverseSurface,
        ),
        descriptionText: l10n.kickOffDescription,
        alignment: const Alignment(0, -0.2),
        trustBadgeTop: 15,
        trustBadgeIconSize: 24,
      ),
    );

    final desktopBody = _buildBody(
      l10n: l10n,
      appColors: appColors,
      badgeLargeStyle: AppTextStyles.titleLargeDesktop,
      badgeMediumStyle: AppTextStyles.titleMediumDesktop,
      titleStyle: AppTextStyles.titleLargeDesktop.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 64,
        height: 80 / 64,
        letterSpacing: -1,
        color: const Color(0xFFF9FAFB),
      ),
      descriptionStyle: AppTextStyles.headlineLargeMobile.copyWith(
        color: appColors.onInverseSurface,
        fontWeight: FontWeight.w500,
      ),
      descriptionText: l10n.kickOffDescription,
      descriptionWidth: 1000,
      badgesToTitleGap: 60,
    );

    final baseButton = OnboardingNextButton(
      onPressed: () => _onNextPressed(context),
      borderColor: appColors.onPrimary,
      iconColor: appColors.onPrimary,
    );

    return ResponsiveScaffold(
      mobile: MobileKickOffView(
        body: mobileBody,
        backgroundColor: bgColor,
        floatingActionButton: baseButton,
      ),
      desktop: DesktopKickOffView(
        body: desktopBody,
        backgroundColor: bgColor,
        floatingActionButton: baseButton,
      ),
    );
  }
}
