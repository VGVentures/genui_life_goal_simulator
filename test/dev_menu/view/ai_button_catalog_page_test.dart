import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/dev_menu/dev_menu.dart';

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
