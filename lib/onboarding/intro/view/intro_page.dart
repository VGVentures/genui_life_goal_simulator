import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/feature_flags/view/view.dart';
import 'package:genui_life_goal_simulator/onboarding/intro/view/intro_desktop_view.dart';
import 'package:genui_life_goal_simulator/onboarding/intro/view/intro_mobile_view.dart';
import 'package:genui_life_goal_simulator/onboarding/pick_profile/view/pick_profile_page.dart';

/// {@template intro_page}
/// Entry point for the intro screen.
///
/// Uses [ResponsiveScaffold] to switch between [IntroMobileView]
/// and [IntroDesktopView] based on available width.
/// {@endtemplate}
class IntroPage extends StatelessWidget {
  /// {@macro intro_page}
  const IntroPage({
    this.onGetStarted,
    this.showDevMenu = false,
    super.key,
  });

  final VoidCallback? onGetStarted;
  final bool showDevMenu;

  @override
  Widget build(BuildContext context) {
    Future<void> backupOnGetStarted() {
      return Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const PickProfilePage(),
        ),
      );
    }

    final introContent = Theme(
      data: AppThemes.light.themeData.getThemeData(context),
      child: ResponsiveScaffold(
        mobile: IntroMobileView(
          onGetStarted: onGetStarted ?? backupOnGetStarted,
        ),
        desktop: IntroDesktopView(
          onGetStarted: onGetStarted ?? backupOnGetStarted,
        ),
      ),
    );

    if (!showDevMenu) return introContent;

    return Scaffold(
      endDrawer: const DevMenuDrawer(),
      body: Stack(
        children: [
          introContent,
          Positioned(
            top: MediaQuery.paddingOf(context).top + Spacing.xs,
            right: Spacing.xs,
            child: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.bug_report, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
