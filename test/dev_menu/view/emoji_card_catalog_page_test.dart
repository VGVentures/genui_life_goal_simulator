import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/dev_menu/dev_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpPage(WidgetTester tester) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: const EmojiCardCatalogPage(),
    ),
  );
}

void main() {
  group('EmojiCardCatalogPage', () {
    testWidgets('renders EmojiCard app bar title', (tester) async {
      await _pumpPage(tester);

      expect(find.text('EmojiCard'), findsOneWidget);
    });

    testWidgets('renders EmojiCardLayout', (tester) async {
      await _pumpPage(tester);

      expect(find.byType(EmojiCardLayout), findsOneWidget);
    });

    testWidgets('renders multiple EmojiCard widgets', (tester) async {
      await _pumpPage(tester);

      expect(find.byType(EmojiCard), findsWidgets);
    });
  });
}
