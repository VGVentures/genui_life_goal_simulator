import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/dev_menu/dev_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpPage(WidgetTester tester) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: const AiButtonCatalogPage(),
    ),
  );
}

void main() {
  group('AiButtonCatalogPage', () {
    testWidgets('renders AiButton app bar title', (tester) async {
      await _pumpPage(tester);

      expect(find.text('AiButton'), findsOneWidget);
    });

    testWidgets('renders AiButton widget', (tester) async {
      await _pumpPage(tester);

      expect(find.byType(AiButton), findsOneWidget);
    });
  });
}
