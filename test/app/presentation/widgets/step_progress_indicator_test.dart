import 'package:finance_app/app/presentation/app_colors.dart';
import 'package:finance_app/app/presentation/widgets/step_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(StepProgressIndicator, () {
    Widget buildTestWidget({
      required int currentStep,
      required int totalSteps,
      VoidCallback? onNext,
    }) {
      return MaterialApp(
        theme: ThemeData(
          extensions: [LightThemeColors()],
        ),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: StepProgressIndicator(
              currentStep: currentStep,
              totalSteps: totalSteps,
              onNext: onNext,
            ),
          ),
        ),
      );
    }

    testWidgets('renders progress bar and Next button', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(currentStep: 1, totalSteps: 3),
      );

      // Progress bar container exists
      expect(find.byType(StepProgressIndicator), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('progress bar shows gradient decoration', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(currentStep: 2, totalSteps: 3),
      );

      // Find containers with gradient decoration
      final gradientContainers = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration is BoxDecoration) {
          final decoration = widget.decoration! as BoxDecoration;
          return decoration.gradient is LinearGradient;
        }
        return false;
      });

      expect(gradientContainers, findsOneWidget);
    });

    testWidgets('progress bar width increases with step progress', (
      tester,
    ) async {
      // Step 1 of 3
      await tester.pumpWidget(
        buildTestWidget(currentStep: 1, totalSteps: 3),
      );
      await tester.pumpAndSettle();

      final step1Container = _findGradientContainer(tester);
      final step1Width = tester.getSize(step1Container).width;

      // Step 2 of 3
      await tester.pumpWidget(
        buildTestWidget(currentStep: 2, totalSteps: 3),
      );
      await tester.pumpAndSettle();

      final step2Container = _findGradientContainer(tester);
      final step2Width = tester.getSize(step2Container).width;

      // Step 3 of 3
      await tester.pumpWidget(
        buildTestWidget(currentStep: 3, totalSteps: 3),
      );
      await tester.pumpAndSettle();

      final step3Container = _findGradientContainer(tester);
      final step3Width = tester.getSize(step3Container).width;

      // Verify widths increase proportionally
      expect(step2Width, greaterThan(step1Width));
      expect(step3Width, greaterThan(step2Width));
    });

    testWidgets('onNext callback is triggered when button is pressed', (
      tester,
    ) async {
      var callbackTriggered = false;

      await tester.pumpWidget(
        buildTestWidget(
          currentStep: 1,
          totalSteps: 3,
          onNext: () => callbackTriggered = true,
        ),
      );

      await tester.tap(find.text('Next'));
      await tester.pump();

      expect(callbackTriggered, isTrue);
    });

    testWidgets('button is disabled when onNext is null', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(currentStep: 1, totalSteps: 3),
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('button is enabled when onNext is provided', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          currentStep: 1,
          totalSteps: 3,
          onNext: () {},
        ),
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, isNotNull);
    });
  });
}

Finder _findGradientContainer(WidgetTester tester) {
  return find.byWidgetPredicate((widget) {
    if (widget is Container && widget.decoration is BoxDecoration) {
      final decoration = widget.decoration! as BoxDecoration;
      return decoration.gradient is LinearGradient;
    }
    return false;
  });
}
