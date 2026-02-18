import 'dart:async';

import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:wiredash/wiredash.dart';

class App extends StatelessWidget {
  const App({super.key});

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
        home: Builder(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: Text(context.l10n.appName),
              ),
              body: const Placeholder(),
              floatingActionButton: FloatingActionButton(
                onPressed: () => unawaited(Wiredash.of(context).show()),
                child: const Icon(Icons.camera),
              ),
            );
          },
        ),
      ),
    );
  }
}
