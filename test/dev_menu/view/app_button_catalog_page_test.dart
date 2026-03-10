import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/dev_menu/dev_menu.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
