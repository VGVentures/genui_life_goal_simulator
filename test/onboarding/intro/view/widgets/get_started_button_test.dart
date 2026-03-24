import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/onboarding/intro/view/widgets/get_started_button.dart';

Future<void> _pump(
  WidgetTester tester, {
  required String label,
  VoidCallback? onPressed,
  double height = 65,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: GetStartedButton(
          label: label,
          onPressed: onPressed,
          height: height,
        ),
      ),
    ),
  );
}

void main() {
  group(GetStartedButton, () {
    testWidgets('renders label text', (tester) async {
      await _pump(tester, label: 'Get started');

      expect(find.text('Get started'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var called = false;
      await _pump(tester, label: 'Get started', onPressed: () => called = true);

      await tester.tap(find.byType(GetStartedButton));
      await tester.pump();

      expect(called, isTrue);
    });

    testWidgets('does not throw when onPressed is null', (tester) async {
      await _pump(tester, label: 'Get started');

      await tester.tap(find.byType(GetStartedButton));
      await tester.pump();
    });

    testWidgets('respects custom height', (tester) async {
      await _pump(tester, label: 'Get started', height: 72);

      final sizedBox = tester
          .widgetList<SizedBox>(find.byType(SizedBox))
          .firstWhere((w) => w.height == 72);

      expect(sizedBox.height, 72);
    });

    testWidgets('renders uppercase label when provided', (tester) async {
      await _pump(tester, label: 'GET STARTED');

      expect(find.text('GET STARTED'), findsOneWidget);
    });
  });
}
