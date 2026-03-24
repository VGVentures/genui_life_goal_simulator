import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/onboarding/kick_off/view/kick_off_values.dart';

class DesktopKickOffView extends StatelessWidget {
  const DesktopKickOffView({
    required this.body,
    required this.backgroundColor,
    required this.floatingActionButton,
    super.key,
  });

  final Widget body;
  final Color backgroundColor;
  final Widget floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          body,
          _buildTopRightDecoration(),
          _buildBottomLeftDecoration(),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _buildTopRightDecoration() {
    return const Positioned(
      top: KickOffValues.desktopTopDecorationTop,
      right: KickOffValues.desktopDecorationOffset,
      child: SizedBox(
        width: KickOffValues.desktopDecorationSize,
        height: KickOffValues.desktopDecorationSize,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 20,
              child: Image(
                image: AssetImage('assets/icons_kick_off/soft_star.png'),
                width: 20,
                height: 20,
              ),
            ),
            Positioned(
              top: 10,
              right: 0,
              child: Opacity(
                opacity: KickOffValues.decorationOpacity,
                child: Image(
                  image: AssetImage('assets/icons_kick_off/star_7.png'),
                  width: 20,
                  height: 20,
                ),
              ),
            ),
            Positioned(
              top: 80,
              left: 40,
              child: Opacity(
                opacity: KickOffValues.decorationOpacity,
                child: Image(
                  image: AssetImage('assets/icons_kick_off/activity_zone.png'),
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 30,
              child: Image(
                image: AssetImage('assets/icons_kick_off/star_9.png'),
                width: 16,
                height: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomLeftDecoration() {
    return const Positioned(
      bottom: KickOffValues.desktopBottomDecorationBottom,
      left: KickOffValues.desktopDecorationOffset,
      child: SizedBox(
        width: KickOffValues.desktopBottomDecorationSize,
        height: KickOffValues.desktopBottomDecorationSize,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 20,
              child: Opacity(
                opacity: KickOffValues.decorationOpacityLight,
                child: Image(
                  image: AssetImage('assets/icons_kick_off/star_7.png'),
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            Positioned(
              top: 100,
              left: 60,
              child: Opacity(
                opacity: KickOffValues.decorationOpacityLight,
                child: Image(
                  image: AssetImage('assets/icons_kick_off/flare.png'),
                  width: 35,
                  height: 35,
                ),
              ),
            ),
            Positioned(
              top: 120,
              right: 40,
              child: Image(
                image: AssetImage('assets/icons_kick_off/star_11.png'),
                width: 12,
                height: 12,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 10,
              child: Opacity(
                opacity: KickOffValues.decorationOpacityLight,
                child: Image(
                  image: AssetImage('assets/icons_kick_off/soft_star.png'),
                  width: 21,
                  height: 21,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
