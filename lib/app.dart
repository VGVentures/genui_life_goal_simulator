import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/l10n/l10n.dart';
import 'package:genui_life_goal_simulator/onboarding/intro/intro.dart';

class App extends StatelessWidget {
  const App({
    this.showDevMenu = false,
    super.key,
  });

  final bool showDevMenu;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appName,
      themeMode: ThemeMode.light,
      builder: (context, child) {
        return Theme(
          data: AppThemes.light.themeData.getThemeData(context),
          child: child ?? const SizedBox.shrink(),
        );
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: IntroPage(showDevMenu: showDevMenu),
    );
  }
}
