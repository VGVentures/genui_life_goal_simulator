import 'package:finance_app/intro/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// {@template intro_mobile_view}
/// Mobile layout for the intro screen.
/// {@endtemplate}
class IntroMobileView extends StatelessWidget {
  /// {@macro intro_mobile_view}
  const IntroMobileView({this.onGetStarted, super.key});

  /// Called when the "Get started" button is pressed.
  final VoidCallback? onGetStarted;

  static const _backgroundColor = Color(0xFF020F30);

  static const _vgvGradient = LinearGradient(
    colors: [Color(0xFF93A0F5), Color(0xFFBBB7F9)],
  );

  static const _titleStyle = TextStyle(
    fontFamily: 'Poppins',
    color: Colors.white,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1,
    letterSpacing: -2,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/intro/waveline3.svg',
              fit: BoxFit.fitWidth,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
            const Spacer(),
            const IntroBadge(),
            const SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Gen UI x ', style: _titleStyle),
                ShaderMask(
                  shaderCallback: (bounds) => _vgvGradient.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: const Text('VGV', style: _titleStyle),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'This demo shows how Generative UI transforms financial '
                'products from static dashboards into adaptive experiences. '
                'The UI reshapes itself based on goals, behavior, and context',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xB3FFFFFF),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GetStartedButton(onPressed: onGetStarted),
            ),
            const SizedBox(height: 32),
          ],
        ),
          ),
        ],
      ),
    );
  }
}
