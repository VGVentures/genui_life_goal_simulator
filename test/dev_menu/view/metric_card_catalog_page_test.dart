import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/dev_menu/dev_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpPage(WidgetTester tester) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: const MetricCardCatalogPage(),
    ),
  );
}

void main() {
  group('MetricCardCatalogPage', () {
    testWidgets('renders MetricCard app bar title', (tester) async {
      await _pumpPage(tester);

      expect(find.text('MetricCard'), findsOneWidget);
    });

    testWidgets('renders MetricCardsLayout', (tester) async {
      await _pumpPage(tester);

      expect(find.byType(MetricCardsLayout), findsOneWidget);
    });

    testWidgets('renders multiple MetricCard widgets', (tester) async {
      await _pumpPage(tester);

      expect(find.byType(MetricCard), findsWidgets);
    });
  });
}
