import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

Future<void> _pumpCard(WidgetTester tester, TrendType trend) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: Scaffold(
        body: SparklineCard(
          label: 'Dining',
          amount: r'$421',
          trend: trend,
        ),
      ),
    ),
  );
}

void main() {
  group(SparklineCard, () {
    group('renders', () {
      testWidgets('label and amount', (tester) async {
        await _pumpCard(tester, TrendType.stable);

        expect(find.text('Dining'), findsOneWidget);
        expect(find.text(r'$421'), findsOneWidget);
      });

      for (final trend in TrendType.values) {
        testWidgets('trend line for ${trend.name}', (tester) async {
          await _pumpCard(tester, trend);

          expect(find.byType(SvgPicture), findsOneWidget);
        });
      }

      testWidgets('without $AppColors extension', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SparklineCard(
                label: 'Test',
                amount: r'$0',
                trend: TrendType.negative,
              ),
            ),
          ),
        );

        expect(find.byType(SparklineCard), findsOneWidget);
      });
    });
  });

  group(SparklineCardsLayout, () {
    const cards = [
      SparklineCard(
        label: 'Savings',
        amount: r'$12,500',
        trend: TrendType.positive,
      ),
      SparklineCard(
        label: 'Spending',
        amount: r'$3,200',
        trend: TrendType.negative,
      ),
    ];

    testWidgets('renders all cards side by side on desktop', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme(LightThemeColors()).themeData,
          home: const Scaffold(body: SparklineCardsLayout(cards: cards)),
        ),
      );

      expect(find.byType(SparklineCard), findsNWidgets(2));
      expect(find.text('Savings'), findsOneWidget);
      expect(find.text('Spending'), findsOneWidget);
    });

    testWidgets('stacks cards vertically on mobile', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme(LightThemeColors()).themeData,
          home: const Scaffold(body: SparklineCardsLayout(cards: cards)),
        ),
      );

      expect(find.byType(SparklineCard), findsNWidgets(2));
      expect(find.text('Savings'), findsOneWidget);
      expect(find.text('Spending'), findsOneWidget);
    });
  });
}
