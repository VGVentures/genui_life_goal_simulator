import 'package:finance_app/gen/assets.gen.dart';
import 'package:finance_app/intro/view/widgets/widgets.dart';
import 'package:finance_app/l10n/l10n.dart';
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
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.paddingOf(context).top,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              Assets.images.intro.waveline3,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            left: 18,
            top: 90,
            child: SvgPicture.asset(
              Assets.images.intro.star8,
              width: 18,
              height: 18,
            ),
          ),
          Positioned(
            left: 25,
            top: 250,
            child: SvgPicture.asset(
              Assets.images.intro.star8,
              width: 15,
              height: 15,
            ),
          ),
          Positioned(
            left: 100,
            top: 380,
            child: SvgPicture.asset(
              Assets.images.intro.circles,
              width: 10,
              height: 10,
            ),
          ),
          Positioned(
            right: 50,
            top: 100,
            child: SvgPicture.asset(
              Assets.images.intro.star8,
              width: 16,
              height: 16,
            ),
          ),
          Positioned(
            left: 160,
            top: 210,
            child: SvgPicture.asset(
              Assets.images.intro.circles,
              width: 10,
              height: 10,
            ),
          ),
          Positioned(
            right: 30,
            top: 350,
            child: SvgPicture.asset(
              Assets.images.intro.softstar,
              width: 25,
              height: 25,
            ),
          ),
          Positioned(
            right: 50,
            top: 200,
            child: SvgPicture.asset(
              Assets.images.intro.circles,
              width: 10,
              height: 10,
            ),
          ),
          Positioned(
            right: 120,
            top: 350,
            child: SvgPicture.asset(
              Assets.images.intro.star7,
              width: 12,
              height: 12,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),
                const IntroBadges(),
                const SizedBox(height: 24),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.introTitlePrefix, style: _titleStyle),
                    ShaderMask(
                      shaderCallback: (bounds) => _vgvGradient.createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                      child: const Text('VGV', style: _titleStyle),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    l10n.introDescription,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xCCFFFFFF),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GetStartedButton(
                    onPressed: onGetStarted,
                    label: l10n.introGetStartedLabel,
                    height: 56,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
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
