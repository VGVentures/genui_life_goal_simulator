import 'package:finance_app/onboarding/kick_off/view/kick_off_values.dart';
import 'package:flutter/material.dart';

class MobileKickOffView extends StatelessWidget {
  const MobileKickOffView({
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
      top: KickOffValues.mobileTopDecorationTop,
      right: KickOffValues.mobileDecorationOffset,
      child: SizedBox(
        width: KickOffValues.mobileDecorationWidth,
        height: KickOffValues.mobileTopDecorationHeight,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 20,
              child: Image(
                image: AssetImage('assets/icons_kick_off/ellipse_139.png'),
                width: 8,
                height: 8,
              ),
            ),
            Positioned(
              top: 15,
              right: 0,
              child: Opacity(
                opacity: KickOffValues.decorationOpacity,
                child: Image(
                  image: AssetImage('assets/icons_kick_off/activity_zone.png'),
                  width: 32,
                  height: 32,
                ),
              ),
            ),
            Positioned(
              top: 65,
              left: 10,
              child: Image(
                image: AssetImage('assets/icons_kick_off/star_5.png'),
                width: 14,
                height: 14,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 15,
              child: Image(
                image: AssetImage('assets/icons_kick_off/ellipse_139.png'),
                width: 8,
                height: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomLeftDecoration() {
    return const Positioned(
      bottom: KickOffValues.mobileBottomDecorationBottom,
      left: KickOffValues.mobileDecorationOffset,
      child: SizedBox(
        width: KickOffValues.mobileDecorationWidth,
        height: KickOffValues.mobileBottomDecorationHeight,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Image(
                image: AssetImage('assets/icons_kick_off/ellipse_139.png'),
                width: 8,
                height: 8,
              ),
            ),
            Positioned(
              top: 15,
              left: 50,
              child: Opacity(
                opacity: KickOffValues.decorationOpacityLight,
                child: Image(
                  image: AssetImage('assets/icons_kick_off/flare.png'),
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 20,
              child: Opacity(
                opacity: KickOffValues.decorationOpacityLight,
                child: Image(
                  image: AssetImage('assets/icons_kick_off/soft_star.png'),
                  width: 18,
                  height: 18,
                ),
              ),
            ),
            Positioned(
              bottom: 25,
              right: 20,
              child: Image(
                image: AssetImage('assets/icons_kick_off/ellipse_139.png'),
                width: 8,
                height: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
