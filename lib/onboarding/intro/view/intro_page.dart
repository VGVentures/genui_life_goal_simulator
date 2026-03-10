import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/onboarding/intro/view/intro_desktop_view.dart';
import 'package:finance_app/onboarding/intro/view/intro_mobile_view.dart';
import 'package:flutter/material.dart';

/// {@template intro_page}
/// Entry point for the intro screen.
///
/// Uses [ResponsiveScaffold] to switch between [IntroMobileView]
/// and [IntroDesktopView] based on available width.
/// {@endtemplate}
class IntroPage extends StatelessWidget {
  /// {@macro intro_page}
  const IntroPage({this.onGetStarted, super.key});

  /// Called when the "Get started" button is pressed.
  final VoidCallback? onGetStarted;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      mobile: IntroMobileView(onGetStarted: onGetStarted),
      desktop: IntroDesktopView(onGetStarted: onGetStarted),
    );
  }
}
