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

    testWidgets('renders all five section labels', (tester) async {
      await _pumpPage(tester);

      expect(find.text('Plain'), findsOneWidget);
      expect(find.text('Delta+ (positive)'), findsOneWidget);
      expect(find.text('Delta- (negative)'), findsOneWidget);
      expect(find.text('Delta+Text'), findsOneWidget);
      expect(find.text('Selected'), findsOneWidget);
    });

    testWidgets('renders Responsive Layout section label', (tester) async {
      await _pumpPage(tester);
      await tester.scrollUntilVisible(
        find.text('Responsive Layout'),
        100,
      );

      expect(find.text('Responsive Layout'), findsOneWidget);
    });

    testWidgets('renders multiple MetricCard widgets', (tester) async {
      await _pumpPage(tester);

      // At least the 5 individual variant cards are visible
      expect(find.byType(MetricCard), findsWidgets);
    });

    testWidgets('renders MetricCardLayout for responsive section',
        (tester) async {
      await _pumpPage(tester);
      await tester.scrollUntilVisible(
        find.byType(MetricCardLayout),
        100,
      );

      expect(find.byType(MetricCardLayout), findsOneWidget);
    });
  });
}
