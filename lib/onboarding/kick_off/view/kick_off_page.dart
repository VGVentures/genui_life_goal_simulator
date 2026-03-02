import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:finance_app/onboarding/kick_off/view/desktop_kick_off_view.dart';
import 'package:finance_app/onboarding/kick_off/view/kick_off_values.dart';
import 'package:finance_app/onboarding/kick_off/view/mobile_kick_off_view.dart';
import 'package:finance_app/onboarding/kick_off/view/widgets/trust_badge.dart';
import 'package:flutter/material.dart';

class KickOffPage extends StatelessWidget {
  const KickOffPage({super.key});

  void _onNextPressed(BuildContext context) {
    // Navigator.of(context).push(
    //   MaterialPageRoute<void>(
    //     builder: (_) => const PickProfilePage(),
    //   ),
    // );

    // Must be changed for correct route when pick profile is pushed
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final appColors = Theme.of(context).extension<AppColors>()!;
    final bgColor = appColors.accentBlue;

    final body = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: KickOffValues.maxContentWidth,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: KickOffValues.badgesStackHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: 0,
                    child: Transform.rotate(
                      angle: -KickOffValues.badgeRotationAngle,
                      child: TrustBadge(
                        text: l10n.notHardcodedBadgeText,
                        backgroundColor: appColors.badgeDarkBlue,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Transform.rotate(
                      angle: KickOffValues.badgeRotationAngle,
                      child: TrustBadge(
                        text: l10n.trustBadgeText,
                        backgroundColor: appColors.badgeWhite,
                        textColor: appColors.badgeTextBlueColor,
                        icon: Image.asset(
                          'assets/icons_kick_off/check_icon.png',
                          width: Spacing.md,
                          height: Spacing.md,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: KickOffValues.titleTopGap),
            Text(
              l10n.kickOffTitle,
              style: AppTextStyles.titleLarge?.copyWith(
                fontSize: 48,
                height: 80 / 64,
                letterSpacing: -1,
                color: const Color(0xFFF9FAFB),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: KickOffValues.titleDescriptionGap),
            Text(
              l10n.kickOffDescription,
              style: AppTextStyles.bodyLarge?.copyWith(
                fontSize: 20,
                height: 1.5,
                letterSpacing: 0,
                color: const Color(0xFFF9FAFB),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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
        body: body,
        backgroundColor: bgColor,
        floatingActionButton: baseButton,
      ),
      desktop: DesktopKickOffView(
        body: body,
        backgroundColor: bgColor,
        floatingActionButton: baseButton,
      ),
    );
  }
}
