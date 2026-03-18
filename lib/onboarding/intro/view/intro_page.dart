import 'package:flutter/material.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';
import 'package:vgv_genui_financial_advisor/onboarding/intro/view/intro_desktop_view.dart';
import 'package:vgv_genui_financial_advisor/onboarding/intro/view/intro_mobile_view.dart';
import 'package:vgv_genui_financial_advisor/onboarding/kick_off/view/kick_off_page.dart';

/// {@template intro_page}
/// Entry point for the intro screen.
///
/// Uses [ResponsiveScaffold] to switch between [IntroMobileView]
/// and [IntroDesktopView] based on available width.
/// {@endtemplate}
class IntroPage extends StatelessWidget {
  /// {@macro intro_page}
  const IntroPage({this.onGetStarted, super.key});

  final VoidCallback? onGetStarted;

  @override
  Widget build(BuildContext context) {
    Future<void> backupOnGetStarted() {
      return Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const KickOffPage(),
        ),
      );
    }

    return ResponsiveScaffold(
      mobile: IntroMobileView(onGetStarted: onGetStarted ?? backupOnGetStarted),
      desktop: IntroDesktopView(
        onGetStarted: onGetStarted ?? backupOnGetStarted,
      ),
    );
  }
}
