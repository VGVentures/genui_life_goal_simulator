import 'package:flutter/material.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';
import 'package:vgv_genui_financial_advisor/gen/assets.gen.dart';
import 'package:vgv_genui_financial_advisor/l10n/l10n.dart';
import 'package:vgv_genui_financial_advisor/onboarding/intro/view/widgets/widgets.dart';

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
            child: Assets.images.intro.waveline3.svg(
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            left: 18,
            top: 90,
            child: Assets.images.intro.star8.svg(
              width: 18,
              height: 18,
            ),
          ),
          Positioned(
            left: 25,
            top: 250,
            child: Assets.images.intro.star8.svg(
              width: 15,
              height: 15,
            ),
          ),
          Positioned(
            left: 100,
            top: 380,
            child: Assets.images.intro.circles.svg(
              width: 10,
              height: 10,
            ),
          ),
          Positioned(
            right: 50,
            top: 100,
            child: Assets.images.intro.star8.svg(
              width: 16,
              height: 16,
            ),
          ),
          Positioned(
            left: 160,
            top: 210,
            child: Assets.images.intro.circles.svg(
              width: 10,
              height: 10,
            ),
          ),
          Positioned(
            right: 30,
            top: 350,
            child: Assets.images.intro.softstar.svg(
              width: 25,
              height: 25,
            ),
          ),
          Positioned(
            right: 50,
            top: 200,
            child: Assets.images.intro.circles.svg(
              width: 10,
              height: 10,
            ),
          ),
          Positioned(
            right: 120,
            top: 350,
            child: Assets.images.intro.star7.svg(
              width: 12,
              height: 12,
            ),
          ),
          const Positioned(
            top: 420,
            left: 0,
            right: 0,
            child: Center(child: IntroBadges()),
          ),
          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                const SizedBox(height: 55),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.introTitlePrefix, style: _titleStyle),
                    ShaderMask(
                      shaderCallback: (bounds) => _vgvGradient.createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('x ', style: _titleStyle),
                          Text('VGV', style: _titleStyle),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    l10n.introDescription,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleMediumMobile.copyWith(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.xxl),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                  child: GetStartedButton(
                    onPressed: onGetStarted,
                    label: l10n.introGetStartedLabel,
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
