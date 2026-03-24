import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/widgets/horizontal_bar.dart';

import '../../helpers/helpers.dart';

void main() {
  group(HorizontalBar, () {
    const negativeBar = HorizontalBar(
      category: 'Dining',
      amount: r'$420',
      progress: 0.6,
      comparisonLabel: 'Groceries',
      comparisonValue: '-5%',
    );

    const positiveBar = HorizontalBar(
      category: 'Dining',
      amount: r'$420',
      progress: 0.65,
      comparisonLabel: 'Groceries',
      comparisonValue: '+10%',
    );

    testWidgets('renders category and amount', (tester) async {
      await tester.pumpApp(const Scaffold(body: negativeBar));

      expect(find.text('Dining'), findsOneWidget);
      expect(find.text(r'$420'), findsOneWidget);
    });

    testWidgets('renders comparison label', (tester) async {
      await tester.pumpApp(const Scaffold(body: negativeBar));

      expect(find.text('Groceries'), findsOneWidget);
    });

    testWidgets('negative variant shows value with minus sign and % suffix', (
      tester,
    ) async {
      await tester.pumpApp(const Scaffold(body: negativeBar));

      expect(find.text('-5%'), findsOneWidget);
    });

    testWidgets('positive variant shows value with plus sign and % suffix', (
      tester,
    ) async {
      await tester.pumpApp(const Scaffold(body: positiveBar));

      expect(find.text('+10%'), findsOneWidget);
    });

    testWidgets('negative comparison text renders in red', (tester) async {
      await tester.pumpApp(const Scaffold(body: negativeBar));

      final text = tester.widget<Text>(find.text('-5%'));
      expect(text.style?.color, isNotNull);
      expect(
        text.style?.color,
        isNot(equals(const Color(0xFF4CAF50))),
      );
    });

    testWidgets('positive comparison text renders in green', (tester) async {
      await tester.pumpApp(const Scaffold(body: positiveBar));

      final text = tester.widget<Text>(find.text('+10%'));
      expect(text.style?.color, isNotNull);
      expect(
        text.style?.color,
        isNot(equals(const Color(0xFFF0524D))),
      );
    });

    testWidgets('renders progress bar track and fill', (tester) async {
      await tester.pumpApp(const Scaffold(body: negativeBar));

      expect(find.byType(Stack), findsWidgets);
      expect(find.byType(FractionallySizedBox), findsOneWidget);
    });

    testWidgets('clamps progress above 1.0 without error', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: HorizontalBar(
            category: 'Dining',
            amount: r'$420',
            progress: 1.5,
            comparisonLabel: 'Groceries',
            comparisonValue: '+5%',
          ),
        ),
      );

      expect(find.byType(FractionallySizedBox), findsOneWidget);
      final box = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      expect(box.widthFactor, 1.0);
    });

    testWidgets('clamps progress below 0.0 without error', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: HorizontalBar(
            category: 'Dining',
            amount: r'$420',
            progress: -0.5,
            comparisonLabel: 'Groceries',
            comparisonValue: '+5%',
          ),
        ),
      );

      final box = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      expect(box.widthFactor, 0.0);
    });

    testWidgets('zero comparisonValue is treated as positive', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: HorizontalBar(
            category: 'Dining',
            amount: r'$420',
            progress: 0.5,
            comparisonLabel: 'Groceries',
            comparisonValue: '+0%',
          ),
        ),
      );

      expect(find.text('+0%'), findsOneWidget);
    });
  });
}
