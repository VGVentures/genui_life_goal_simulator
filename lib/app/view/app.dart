import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/intro/intro.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:finance_app/onboarding/pick_profile/view/pick_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:wiredash/wiredash.dart';

class App extends StatelessWidget {
  const App({
    required this.navigatorObservers,
    super.key,
  });

  final List<NavigatorObserver> navigatorObservers;

  @override
  Widget build(BuildContext context) {
    return Wiredash(
      projectId: 'gcn26-finance-app-j9k7f4b',
      secret: 'p_iCQvLnrp18LEacxg6JYRtV5g-FbvfA',
      child: MaterialApp(
        theme: AppThemes.light.themeData.themeData,
        darkTheme: AppThemes.dark.themeData.themeData,
        themeMode: ThemeMode.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        navigatorObservers: navigatorObservers,
        home: const _IntroPage(),
        // home: const _IntroPage(),
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  const _IntroPage();

  @override
  Widget build(BuildContext context) {
    return IntroPage(
      // TODO(dev): migrate to go_router
      onGetStarted: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const PickProfilePage()),
      ),
    );
  }
}
