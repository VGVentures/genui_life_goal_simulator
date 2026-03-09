import 'dart:async';

import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:finance_app/onboarding/kick_off/view/desktop_kick_off_view.dart';
import 'package:finance_app/onboarding/kick_off/view/kick_off_values.dart';
import 'package:finance_app/onboarding/kick_off/view/mobile_kick_off_view.dart';
import 'package:finance_app/onboarding/kick_off/view/widgets/trust_badge.dart';
import 'package:finance_app/onboarding/pick_profile/view/pick_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
  }) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: KickOffValues.maxContentWidth,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                    top: 5,
                    child: Transform.rotate(
                      angle: KickOffValues.badgeRotationAngle,
                      child: TrustBadge(
                        text: l10n.trustBadgeText,
                        backgroundColor: const Color(0xFFF0F0F0),
                        textColor: appColors.onPrimaryContainer,
                        icon: SvgPicture.asset(
                          'assets/icons_kick_off/trust_icon.svg',
                          width: 30,
                          height: 30,
                        ),
                        textStyle: badgeMediumStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: KickOffValues.titleTopGap),
            Text(
              l10n.kickOffTitle,
              style: titleStyle.copyWith(
                color: const Color(0xFFF9FAFB),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: KickOffValues.titleDescriptionGap),
            Text(
              descriptionText,
              style: descriptionStyle.copyWith(
                color: const Color(0xFFF9FAFB),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
        badgeLargeStyle: AppTextStyles.titleLargeMobile,
        badgeMediumStyle: AppTextStyles.titleMediumMobile,
        titleStyle: AppTextStyles.displayLargeDesktop,
        descriptionStyle: AppTextStyles.titleSmallDesktop,
        descriptionText: l10n.kickOffDescriptionMobile,
        alignment: const Alignment(0, -0.2),
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
      ),
      descriptionStyle: AppTextStyles.headlineLargeDesktop,
      descriptionText: l10n.kickOffDescription,
    );

    final baseButton = OutlinedButton(
      onPressed: () => _onNextPressed(context),
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        side: const BorderSide(
          color: Colors.white,
          width: KickOffValues.buttonBorderWidth,
        ),
        padding: const EdgeInsets.all(KickOffValues.buttonPadding),
      ),
      child: const Icon(
        Icons.arrow_forward,
        color: Colors.white,
      ),
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
