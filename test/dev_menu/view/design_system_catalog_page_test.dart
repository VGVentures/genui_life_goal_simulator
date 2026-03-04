import 'package:finance_app/dev_menu/dev_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpPage(WidgetTester tester) {
  return tester.pumpWidget(
    const MaterialApp(home: DesignSystemCatalogPage()),
  );
}

void main() {
  group('DesignSystemCatalogPage', () {
    testWidgets('renders Design System app bar title', (tester) async {
      await _pumpPage(tester);

      expect(find.text('Design System'), findsOneWidget);
    });

    testWidgets('renders MetricCard list tile', (tester) async {
      await _pumpPage(tester);

      expect(find.text('MetricCard'), findsOneWidget);
    });

    testWidgets('tapping MetricCard navigates to MetricCardCatalogPage', (
      tester,
    ) async {
      await _pumpPage(tester);

      await tester.tap(find.text('MetricCard'));
      await tester.pumpAndSettle();

      expect(find.byType(MetricCardCatalogPage), findsOneWidget);
    });

    testWidgets('renders EmojiCard list tile', (tester) async {
      await _pumpPage(tester);

      expect(find.text('EmojiCard'), findsOneWidget);
    });

    testWidgets('tapping EmojiCard navigates to EmojiCardCatalogPage', (
      tester,
    ) async {
      await _pumpPage(tester);

      await tester.tap(find.text('EmojiCard'));
      await tester.pumpAndSettle();

      expect(find.byType(EmojiCardCatalogPage), findsOneWidget);
    });
  });
}
