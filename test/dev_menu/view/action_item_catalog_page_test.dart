import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/dev_menu/dev_menu.dart';

Future<void> _pumpPage(WidgetTester tester) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: const ActionItemCatalogPage(),
    ),
  );
}

void main() {
  group('ActionItemCatalogPage', () {
    group('renders', () {
      testWidgets('ActionItem app bar title', (tester) async {
        await _pumpPage(tester);

        expect(find.text('ActionItem'), findsOneWidget);
      });

      testWidgets('section labels', (tester) async {
        await _pumpPage(tester);

        expect(find.text('With trailing button'), findsOneWidget);
        expect(find.text('Without trailing'), findsOneWidget);
        expect(find.text('ActionItemsGroup'), findsOneWidget);
      });

      testWidgets('ActionItem widgets', (tester) async {
        await _pumpPage(tester);

        expect(find.byType(ActionItem), findsNWidgets(5));
      });

      testWidgets('ActionItemsGroup widget', (tester) async {
        await _pumpPage(tester);

        expect(find.byType(ActionItemsGroup), findsOneWidget);
      });

      testWidgets('trailing buttons', (tester) async {
        await _pumpPage(tester);

        expect(find.text('Details'), findsNWidgets(2));
        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('tapping trailing buttons does not throw', (tester) async {
        await _pumpPage(tester);

        // Tap standalone Details button
        await tester.tap(find.text('Details').first);
        await tester.pump();

        // Scroll to reveal Cancel button inside ActionItemsGroup
        await tester.scrollUntilVisible(
          find.text('Cancel'),
          100,
        );

        await tester.tap(find.text('Cancel'));
        await tester.pump();

        // Tap Details inside ActionItemsGroup
        await tester.tap(find.text('Details').last);
        await tester.pump();
      });
    });
  });
}
