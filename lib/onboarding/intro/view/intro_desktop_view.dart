import 'package:flutter/material.dart';
import 'package:vgv_genui_financial_advisor/feature_flags/view/widgets/dev_menu_drawer.dart';
import 'package:vgv_genui_financial_advisor/gen/assets.gen.dart';
import 'package:vgv_genui_financial_advisor/l10n/l10n.dart';
import 'package:vgv_genui_financial_advisor/onboarding/intro/view/widgets/widgets.dart';

/// {@template intro_desktop_view}
/// Desktop layout for the intro screen.
/// {@endtemplate}
class IntroDesktopView extends StatelessWidget {
  /// {@macro intro_desktop_view}
  const IntroDesktopView({this.onGetStarted, super.key});

  /// Called when the "Get started" button is pressed.
  final VoidCallback? onGetStarted;

  static const _backgroundColor = Color(0xFF020F30);

  static const _vgvGradient = LinearGradient(
    colors: [Color(0xFF93A0F5), Color(0xFFBBB7F9)],
  );

  static const _titleStyle = TextStyle(
    fontFamily: 'Poppins',
    color: Colors.white,
    fontSize: 116,
    fontWeight: FontWeight.w700,
    height: 1,
    letterSpacing: -2,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      endDrawer: const DevMenuDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: const Icon(Icons.bug_report),
              );
            },
          ),
        ],
      ),
      backgroundColor: _backgroundColor,
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Assets.images.intro.waveline1.svg(
              fit: BoxFit.fitHeight,
              alignment: Alignment.centerLeft,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Assets.images.intro.waveline2.svg(
              fit: BoxFit.fitHeight,
              alignment: Alignment.centerRight,
            ),
          ),
          Positioned(
            left: 80,
            top: 200,
            child: Assets.images.intro.circles.svg(
              width: 10,
              height: 10,
            ),
          ),
          Positioned(
            left: 180,
            top: 220,
            child: Assets.images.intro.star8.svg(
              width: 24,
              height: 25,
            ),
          ),
          Positioned(
            left: 180,
            top: 320,
            child: Assets.images.intro.circles.svg(
              width: 10,
              height: 10,
            ),
          ),
          Positioned(
            left: 170,
            top: 590,
            child: Assets.images.intro.star6.svg(
              width: 23,
              height: 23,
            ),
          ),
          Positioned(
            left: 90,
            top: 830,
            child: Assets.images.intro.circles.svg(
              width: 10,
              height: 10,
            ),
          ),
          Positioned(
            left: 400,
            top: 830,
            child: Assets.images.intro.circles.svg(
              width: 10,
              height: 10,
            ),
          ),
          Positioned(
            left: 820,
            top: 900,
            child: Assets.images.intro.circles.svg(
              width: 10,
              height: 10,
            ),
          ),
          Positioned(
            left: 1100,
            top: 820,
            child: Assets.images.intro.circles.svg(
              width: 10,
              height: 10,
            ),
          ),
          Positioned(
            left: 1300,
            top: 850,
            child: Assets.images.intro.circles.svg(
              width: 10,
              height: 10,
            ),
          ),
          Positioned(
            right: 790,
            top: 80,
            child: Assets.images.intro.circles.svg(
              width: 10,
              height: 10,
            ),
          ),
          Positioned(
            right: 580,
            top: 140,
            child: Assets.images.intro.circles.svg(
              width: 10,
              height: 10,
            ),
          ),
          Positioned(
            right: 250,
            top: 140,
            child: Assets.images.intro.star7.svg(
              width: 24,
              height: 24,
            ),
          ),
          Positioned(
            right: 290,
            top: 500,
            child: Assets.images.intro.softstar.svg(
              width: 24,
              height: 24,
            ),
          ),
          Positioned(
            right: 150,
            top: 700,
            child: Assets.images.intro.star9.svg(
              width: 15,
              height: 15,
            ),
          ),
          Positioned(
            right: 80,
            top: 50,
            child: Assets.images.intro.circles.svg(
              width: 10,
              height: 10,
            ),
          ),
          Positioned(
            right: 230,
            top: 320,
            child: Assets.images.intro.circles.svg(
              width: 10,
              height: 10,
            ),
          ),
          Positioned(
            right: 120,
            top: 500,
            child: Assets.images.intro.circles.svg(
              width: 10,
              height: 10,
            ),
          ),
          Positioned(
            right: 100,
            top: 900,
            child: Assets.images.intro.circles.svg(
              width: 10,
              height: 10,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const IntroBadges(),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(l10n.introTitlePrefix, style: _titleStyle),
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                _vgvGradient.createShader(
                                  Rect.fromLTWH(
                                    0,
                                    0,
                                    bounds.width,
                                    bounds.height,
                                  ),
                                ),
                            child: const Text('VGV', style: _titleStyle),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 1000,
                  child: Text(
                    l10n.introDescription,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xB3FFFFFF),
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: 400,
                  child: GetStartedButton(
                    onPressed: onGetStarted,
                    label: l10n.introGetStartedLabel.toUpperCase(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
