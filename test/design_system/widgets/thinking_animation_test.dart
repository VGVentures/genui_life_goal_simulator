import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

void main() {
  group(ThinkingAnimation, () {
    testWidgets('renders with default width', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ThinkingAnimation()),
        ),
      );

      expect(find.byType(ThinkingAnimation), findsOneWidget);

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, 200);
    });

    testWidgets('renders with custom width', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ThinkingAnimation(width: 100)),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, 100);
    });

    testWidgets('degrades gracefully when Rive is unavailable', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ThinkingAnimation()),
        ),
      );

      // Should not throw — renders a fallback SizedBox.
      expect(tester.takeException(), isNull);
      expect(find.byType(ThinkingAnimation), findsOneWidget);
    });
  });
}
