import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/dev_menu/dev_menu.dart';
import 'package:genui_life_goal_simulator/l10n/l10n.dart';

Future<void> _pumpPage(WidgetTester tester) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AppButtonCatalogPage(),
    ),
  );
}

void main() {
  group(AppButtonCatalogPage, () {
    testWidgets('renders AppButton app bar title', (tester) async {
      await _pumpPage(tester);

      expect(find.text('AppButton'), findsOneWidget);
    });

    testWidgets('renders filled button variants', (tester) async {
      await _pumpPage(tester);

      expect(find.byType(FilledButton), findsWidgets);
    });

    testWidgets('renders outlined button variants', (tester) async {
      await _pumpPage(tester);

      expect(find.byType(OutlinedButton), findsWidgets);
    });
  });
}
