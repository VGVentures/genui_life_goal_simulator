import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/app_colors.dart';
import 'package:genui_life_goal_simulator/design_system/app_theme.dart';
import 'package:genui_life_goal_simulator/design_system/widgets/progress_bar.dart';

Future<void> _pump(
  WidgetTester tester, {
  required String title,
  required double value,
  required double total,
  String Function(double)? formatValue,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: Scaffold(
        body: ProgressBar(
          title: title,
          value: value,
          total: total,
          formatValue: formatValue,
        ),
      ),
    ),
  );
}

Color _barColor(WidgetTester tester) {
  final indicator = tester.widget<LinearProgressIndicator>(
    find.byType(LinearProgressIndicator),
  );
  return indicator.valueColor!.value!;
}

void main() {
  group(ProgressBar, () {
    group('renders', () {
      testWidgets('renders title', (tester) async {
        await _pump(tester, title: 'Dining', value: 200, total: 400);

        expect(find.text('Dining'), findsOneWidget);
      });

      testWidgets('renders default formatted current value', (tester) async {
        await _pump(tester, title: 'Dining', value: 200, total: 400);

        expect(find.text(r'$200'), findsOneWidget);
      });

      testWidgets('renders default formatted budget value', (tester) async {
        await _pump(tester, title: 'Dining', value: 200, total: 400);

        expect(find.text(r' / $400'), findsOneWidget);
      });

      testWidgets('uses custom formatValue for both amounts', (tester) async {
        await _pump(
          tester,
          title: 'Dining',
          value: 200,
          total: 400,
          formatValue: (v) => '€${v.toStringAsFixed(0)}',
        );

        expect(find.text('€200'), findsOneWidget);
        expect(find.text(' / €400'), findsOneWidget);
      });
    });

    group('bar color', () {
      testWidgets('is success when progress is below 65%', (tester) async {
        await _pump(tester, title: 'x', value: 60, total: 100);

        expect(_barColor(tester), LightThemeColors().success);
      });

      group('is warning', () {
        testWidgets('when progress is at 65%', (tester) async {
          await _pump(tester, title: 'x', value: 65, total: 100);

          expect(_barColor(tester), LightThemeColors().warning);
        });

        testWidgets('when progress is between 65% and 85%', (tester) async {
          await _pump(tester, title: 'x', value: 75, total: 100);

          expect(_barColor(tester), LightThemeColors().warning);
        });

        testWidgets('when progress is at 85%', (tester) async {
          await _pump(tester, title: 'x', value: 85, total: 100);

          expect(_barColor(tester), LightThemeColors().warning);
        });
      });

      group('is error', () {
        testWidgets('when progress is above 85%', (tester) async {
          await _pump(tester, title: 'x', value: 90, total: 100);

          expect(_barColor(tester), LightThemeColors().error);
        });

        testWidgets('when over budget', (tester) async {
          await _pump(tester, title: 'x', value: 420, total: 400);

          expect(_barColor(tester), LightThemeColors().error);
        });
      });
    });

    group('bar indicator value', () {
      testWidgets('reflects progress ratio', (tester) async {
        await _pump(tester, title: 'x', value: 50, total: 100);

        final indicator = tester.widget<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator),
        );
        expect(indicator.value, 0.5);
      });

      testWidgets('is clamped to 1.0 when over budget', (tester) async {
        await _pump(tester, title: 'x', value: 420, total: 400);

        final indicator = tester.widget<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator),
        );
        expect(indicator.value, 1.0);
      });

      testWidgets('is 0.0 when total is zero', (tester) async {
        await _pump(tester, title: 'x', value: 0, total: 0);

        final indicator = tester.widget<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator),
        );
        expect(indicator.value, 0.0);
      });
    });
  });
}
