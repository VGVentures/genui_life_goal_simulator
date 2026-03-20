import 'package:flutter/material.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';
import 'package:vgv_genui_financial_advisor/l10n/l10n.dart';
import 'package:vgv_genui_financial_advisor/onboarding/intro/intro.dart';

class App extends StatelessWidget {
  const App({
    this.showDevMenu = false,
    super.key,
  });

  final bool showDevMenu;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
