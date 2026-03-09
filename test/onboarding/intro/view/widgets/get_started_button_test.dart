import 'package:finance_app/onboarding/intro/view/widgets/get_started_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester, {
  required String label,
  VoidCallback? onPressed,
  double height = 80,
  double fontSize = 24,
  FontWeight fontWeight = FontWeight.w600,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: GetStartedButton(
          label: label,
          onPressed: onPressed,
          height: height,
          fontSize: fontSize,
          fontWeight: fontWeight,
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
      await _pump(tester, label: 'Get started', height: 56);

      final sizedBox = tester
          .widgetList<SizedBox>(find.byType(SizedBox))
          .firstWhere((w) => w.height == 56);

      expect(sizedBox.height, 56);
    });

    testWidgets('renders uppercase label when provided', (tester) async {
      await _pump(tester, label: 'GET STARTED');

      expect(find.text('GET STARTED'), findsOneWidget);
    });
  });
}
