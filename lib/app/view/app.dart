import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/feature_flag/feature_flag.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:finance_app/onboarding/intro/intro.dart';
import 'package:finance_app/onboarding/kick_off/view/kick_off_page.dart';
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
        themeMode: ThemeMode.light,
        builder: (context, child) {
          return Theme(
            data: AppThemes.light.themeData.getThemeData(context),
            child: child ?? const SizedBox.shrink(),
          );
        },
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        navigatorObservers: navigatorObservers,
        home: const _IntroPage(),
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  const _IntroPage();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return IntroPage(
      onGetStarted: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          // TODO(juanRodriguez17): Just to see our custom components
          builder: (_) => Scaffold(
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
          ),
        ),
      ),
    );
  }
}
