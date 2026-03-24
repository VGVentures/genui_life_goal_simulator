import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/widgets/line_chart.dart';
import 'package:genui_life_goal_simulator/l10n/l10n.dart';

extension _PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
      ),
    );
  }
}

const _yLabels = [r'$0.0k', r'$1.5k', r'$3.0k', r'$4.5k', r'$6.0k'];

const _points = [
  LineChartPoint(
    xLabel: 'Sep',
    value: 4200,
    tooltipLabel: 'Sep',
    tooltipValue: r'Spend: $4200',
  ),
  LineChartPoint(
    xLabel: 'Oct',
    value: 3500,
    tooltipLabel: 'Oct',
    tooltipValue: r'Spend: $3500',
  ),
  LineChartPoint(
    xLabel: 'Nov',
    value: 4500,
    tooltipLabel: 'Nov',
    tooltipValue: r'Spend: $4500',
  ),
  LineChartPoint(
    xLabel: 'Dec',
    value: 3800,
    tooltipLabel: 'Dec',
    tooltipValue: r'Spend: $3800',
  ),
  LineChartPoint(
    xLabel: 'Jan',
    value: 4700,
    tooltipLabel: 'Jan',
    tooltipValue: r'Spend: $4700',
  ),
  LineChartPoint(
    xLabel: 'Feb',
    value: 5000,
    tooltipLabel: 'Feb',
    tooltipValue: r'Spend: $5000',
  ),
];

const _chart = LineChart(
  points: _points,
  yAxisLabels: _yLabels,
  minValue: 0,
  maxValue: 6000,
);

void main() {
  group(LineChart, () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: SizedBox(width: 670, height: 240, child: _chart),
        ),
      );

      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('renders x-axis labels', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: SizedBox(width: 670, height: 240, child: _chart),
        ),
      );

      expect(find.text('Sep'), findsOneWidget);
      expect(find.text('Oct'), findsOneWidget);
      expect(find.text('Feb'), findsOneWidget);
    });

    testWidgets('renders y-axis labels', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: SizedBox(width: 670, height: 240, child: _chart),
        ),
      );

      expect(find.text(r'$0.0k'), findsOneWidget);
      expect(find.text(r'$6.0k'), findsOneWidget);
    });

    testWidgets('default state shows no tooltip', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: SizedBox(width: 670, height: 240, child: _chart),
        ),
      );

      expect(
        find.textContaining(r'Spend: $4200', findRichText: true),
        findsNothing,
      );
    });

    testWidgets('tapping chart shows tooltip for nearest point', (
      tester,
    ) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      await tester.pumpApp(
        const Scaffold(
          body: SizedBox(width: 670, height: 240, child: _chart),
        ),
      );

      // Tap near the left edge of the chart area to select the first point.
      final chartPos = tester.getTopLeft(find.byType(LineChart));
      await tester.tapAt(chartPos + const Offset(80, 100));
      await tester.pumpAndSettle();

      debugDefaultTargetPlatformOverride = null;

      expect(
        find.textContaining(r'Spend: $4200', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('tapping same point again dismisses tooltip', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      await tester.pumpApp(
        const Scaffold(
          body: SizedBox(width: 670, height: 240, child: _chart),
        ),
      );

      final chartPos = tester.getTopLeft(find.byType(LineChart));
      await tester.tapAt(chartPos + const Offset(80, 100));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(r'Spend: $4200', findRichText: true),
        findsOneWidget,
      );

      await tester.tapAt(chartPos + const Offset(80, 100));
      await tester.pumpAndSettle();

      debugDefaultTargetPlatformOverride = null;

      expect(
        find.textContaining(r'Spend: $4200', findRichText: true),
        findsNothing,
      );
    });

    testWidgets('renders with a single data point without error', (
      tester,
    ) async {
      await tester.pumpApp(
        const Scaffold(
          body: SizedBox(
            width: 670,
            height: 240,
            child: LineChart(
              points: [
                LineChartPoint(
                  xLabel: 'Jan',
                  value: 4000,
                  tooltipLabel: 'Jan',
                  tooltipValue: r'Spend: $4000',
                ),
              ],
              yAxisLabels: _yLabels,
              minValue: 0,
              maxValue: 6000,
            ),
          ),
        ),
      );

      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('renders with empty points list without error', (
      tester,
    ) async {
      await tester.pumpApp(
        const Scaffold(
          body: SizedBox(
            width: 670,
            height: 240,
            child: LineChart(
              points: [],
              yAxisLabels: _yLabels,
              minValue: 0,
              maxValue: 6000,
            ),
          ),
        ),
      );

      expect(find.byType(LineChart), findsOneWidget);
    });
  });

  group(LineChartPoint, () {
    test('equality holds for identical values', () {
      const a = LineChartPoint(
        xLabel: 'Jan',
        value: 1000,
        tooltipLabel: 'Jan',
        tooltipValue: r'$1000',
      );
      const b = LineChartPoint(
        xLabel: 'Jan',
        value: 1000,
        tooltipLabel: 'Jan',
        tooltipValue: r'$1000',
      );
      expect(a, equals(b));
    });

    test('equality fails when values differ', () {
      const a = LineChartPoint(
        xLabel: 'Jan',
        value: 1000,
        tooltipLabel: 'Jan',
        tooltipValue: r'$1000',
      );
      const b = LineChartPoint(
        xLabel: 'Feb',
        value: 1000,
        tooltipLabel: 'Feb',
        tooltipValue: r'$1000',
      );
      expect(a, isNot(equals(b)));
    });
  });
}
