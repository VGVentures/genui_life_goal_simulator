import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/feature_flags/view/view.dart';
import 'package:genui_life_goal_simulator/l10n/l10n.dart';
import 'package:genui_life_goal_simulator/onboarding/intro/view/intro_desktop_view.dart';
import 'package:genui_life_goal_simulator/onboarding/intro/view/intro_mobile_view.dart';
import 'package:genui_life_goal_simulator/onboarding/kick_off/view/kick_off_page.dart';

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
          builder: (_) => _IntroView(showDevMenu: showDevMenu),
        ),
      );
    }

    return ResponsiveScaffold(
      mobile: IntroMobileView(
        onGetStarted: onGetStarted ?? backupOnGetStarted,
      ),
      desktop: IntroDesktopView(
        onGetStarted: onGetStarted ?? backupOnGetStarted,
      ),
    );
  }
}

class _IntroView extends StatelessWidget {
  const _IntroView({this.showDevMenu = false});

  final bool showDevMenu;

  @override
  Widget build(BuildContext context) {
    if (!showDevMenu) {
      return const Scaffold(body: KickOffPage());
    }

    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeAppBarTitle),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.bug_report),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              );
            },
          ),
        ],
      ),
      endDrawer: const DevMenuDrawer(),
      body: const KickOffPage(),
    );
  }
}
