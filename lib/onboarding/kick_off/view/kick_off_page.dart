import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:finance_app/onboarding/kick_off/view/widgets/trust_badge.dart';
import 'package:finance_app/persona/persona.dart';
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
        constraints: const BoxConstraints(maxWidth: 700),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 70,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: 0,
                    child: Transform.rotate(
                      angle: -0.03,
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
                      angle: 0.03,
                      child: TrustBadge(
                        text: l10n.trustBadgeText,
                        backgroundColor: appColors.badgeWhite,
                        textColor: appColors.badgeTextBlueColor,
                        icon: Image.asset(
                          'assets/icons_kick_off/check_icon.png',
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              l10n.kickOffTitle,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 48,
                height: 80 / 64,
                letterSpacing: -1,
                color: Color(0xFFF9FAFB),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              l10n.kickOffDescription,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 20,
                height: 1.5,
                letterSpacing: 0,
                color: Color(0xFFF9FAFB),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    // Base button without padding
    final baseButton = OutlinedButton(
      onPressed: () => _onNextPressed(context),
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        side: const BorderSide(color: Colors.white, width: 1.1),
        padding: const EdgeInsets.all(40),
      ),
      child: const Icon(
        Icons.arrow_forward,
        color: Colors.white,
      ),
    );

    // Desktop button with more padding
    final desktopButton = Padding(
      padding: const EdgeInsets.only(bottom: 30, right: 20),
      child: baseButton,
    );

    // Mobile button closer to the corner
    final mobileButton = Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 10),
      child: baseButton,
    );

    // Top right decoration with stars and activity zone
    const topRightDesktopDecoration = Positioned(
      top: 60,
      right: 40,
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          children: [
            // Small star top left
            Positioned(
              top: 0,
              left: 20,
              child: Image(
                image: AssetImage('assets/icons_kick_off/Soft Star.png'),
                width: 20,
                height: 20,
              ),
            ),
            // Large star top right
            Positioned(
              top: 10,
              right: 0,
              child: Opacity(
                opacity: 0.7,
                child: Image(
                  image: AssetImage('assets/icons_kick_off/Star 7.png'),
                  width: 20,
                  height: 20,
                ),
              ),
            ),
            // Activity zone (cube) center
            Positioned(
              top: 80,
              left: 40,
              child: Opacity(
                opacity: 0.7,
                child: Image(
                  image: AssetImage('assets/icons_kick_off/activity_zone.png'),
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            // Small star bottom right
            Positioned(
              bottom: 20,
              right: 30,
              child: Image(
                image: AssetImage('assets/icons_kick_off/Star 9.png'),
                width: 16,
                height: 16,
              ),
            ),
          ],
        ),
      ),
    );

    // Bottom left decoration with stars and flare
    const bottomLeftDesktopDecoration = Positioned(
      bottom: 80,
      left: 40,
      child: SizedBox(
        width: 250,
        height: 250,
        child: Stack(
          children: [
            // Star top left
            Positioned(
              top: 0,
              left: 20,
              child: Opacity(
                opacity: 0.5,
                child: Image(
                  image: AssetImage('assets/icons_kick_off/Star 7.png'),
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            // Flare center
            Positioned(
              top: 100,
              left: 60,
              child: Opacity(
                opacity: 0.5,
                child: Image(
                  image: AssetImage('assets/icons_kick_off/flare.png'),
                  width: 35,
                  height: 35,
                ),
              ),
            ),
            // Small star right
            Positioned(
              top: 120,
              right: 40,
              child: Image(
                image: AssetImage('assets/icons_kick_off/Star 11.png'),
                width: 12,
                height: 12,
              ),
            ),
            // Soft star bottom left
            Positioned(
              bottom: 0,
              left: 10,
              child: Opacity(
                opacity: 0.5,
                child: Image(
                  image: AssetImage('assets/icons_kick_off/Soft Star.png'),
                  width: 21,
                  height: 21,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Mobile top right decoration
    const mobileTopRightDecoration = Positioned(
      top: 80,
      right: 20,
      child: SizedBox(
        width: 120,
        height: 130,
        child: Stack(
          children: [
            // Ellipse top
            Positioned(
              top: 0,
              left: 20,
              child: Image(
                image: AssetImage('assets/icons_kick_off/Ellipse 139.png'),
                width: 8,
                height: 8,
              ),
            ),
            // Activity zone (cube)
            Positioned(
              top: 15,
              right: 0,
              child: Opacity(
                opacity: 0.7,
                child: Image(
                  image: AssetImage('assets/icons_kick_off/activity_zone.png'),
                  width: 32,
                  height: 32,
                ),
              ),
            ),
            // Star 5
            Positioned(
              top: 65,
              left: 10,
              child: Image(
                image: AssetImage('assets/icons_kick_off/Star 5.png'),
                width: 14,
                height: 14,
              ),
            ),
            // Ellipse bottom right
            Positioned(
              bottom: 0,
              right: 15,
              child: Image(
                image: AssetImage('assets/icons_kick_off/Ellipse 139.png'),
                width: 8,
                height: 8,
              ),
            ),
          ],
        ),
      ),
    );

    // Mobile bottom left decoration
    const mobileBottomLeftDecoration = Positioned(
      bottom: 60,
      left: 20,
      child: SizedBox(
        width: 120,
        height: 120,
        child: Stack(
          children: [
            // Ellipse top left
            Positioned(
              top: 0,
              left: 0,
              child: Image(
                image: AssetImage('assets/icons_kick_off/Ellipse 139.png'),
                width: 8,
                height: 8,
              ),
            ),
            // Flare
            Positioned(
              top: 15,
              left: 50,
              child: Opacity(
                opacity: 0.5,
                child: Image(
                  image: AssetImage('assets/icons_kick_off/flare.png'),
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            // Soft star bottom left
            Positioned(
              bottom: 0,
              left: 20,
              child: Opacity(
                opacity: 0.5,
                child: Image(
                  image: AssetImage('assets/icons_kick_off/Soft Star.png'),
                  width: 18,
                  height: 18,
                ),
              ),
            ),
            // Ellipse bottom right
            Positioned(
              bottom: 25,
              right: 20,
              child: Image(
                image: AssetImage('assets/icons_kick_off/Ellipse 139.png'),
                width: 8,
                height: 8,
              ),
            ),
          ],
        ),
      ),
    );

    // Desktop decorated body
    final desktopDecoratedBody = Stack(
      children: [
        body,
        topRightDesktopDecoration,
        bottomLeftDesktopDecoration,
      ],
    );

    // Mobile decorated body
    final mobileDecoratedBody = Stack(
      children: [
        body,
        mobileTopRightDecoration,
        mobileBottomLeftDecoration,
      ],
    );

    return ResponsiveScaffold(
      mobile: Scaffold(
        backgroundColor: bgColor,
        body: mobileDecoratedBody,
        floatingActionButton: mobileButton,
      ),
      desktop: Scaffold(
        backgroundColor: bgColor,
        body: desktopDecoratedBody,
        floatingActionButton: desktopButton,
      ),
    );
  }
}
