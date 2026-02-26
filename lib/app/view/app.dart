import 'dart:async';

import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/feature_flag/feature_flag.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:finance_app/persona/persona.dart';
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
        home: const _HomePage(),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.homeAppBarTitle),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          unawaited(Wiredash.of(context).show());
        },
        child: const Icon(Icons.feedback),
      ),
      endDrawer: const DevMenuDrawer(),
      body: const PersonaSelectorPage(),
    );
  }
}
