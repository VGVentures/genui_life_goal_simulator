import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

void main() {
  group(LoadingOverlay, () {
    testWidgets('renders with colored background', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoadingOverlay()),
        ),
      );

      expect(find.byType(LoadingOverlay), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(LoadingOverlay),
          matching: find.byType(ColoredBox),
        ),
        findsOneWidget,
      );
    });

    testWidgets('degrades gracefully when Rive is unavailable', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoadingOverlay()),
        ),
      );

      // Should not throw — renders a colored background fallback.
      expect(tester.takeException(), isNull);
      expect(find.byType(LoadingOverlay), findsOneWidget);
    });

    testWidgets('calls onAnimationComplete after animationDuration', (
      tester,
    ) async {
      var completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              animationDuration: const Duration(seconds: 1),
              onAnimationComplete: () => completed = true,
            ),
          ),
        ),
      );

      expect(completed, isFalse);

      // Advance past the fallback timer.
      await tester.pump(const Duration(seconds: 1));

      expect(completed, isTrue);
    });

    testWidgets('applies custom background color and opacity', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              backgroundColor: Colors.blue,
              backgroundOpacity: 0.8,
            ),
          ),
        ),
      );

      final coloredBox = tester.widget<ColoredBox>(
        find.descendant(
          of: find.byType(LoadingOverlay),
          matching: find.byType(ColoredBox),
        ),
      );
      expect(coloredBox.color, Colors.blue.withValues(alpha: 0.8));
    });
  });
}
