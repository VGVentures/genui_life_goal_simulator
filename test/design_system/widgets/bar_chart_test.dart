import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/widgets/bar_chart.dart';
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

const _yLabels = [r'$0.0k', r'$2.0k', r'$4.0k', r'$6.0k', r'$8.0k'];

const _series = [
  BarChartSeries(
    label: 'Reference 1',
    color: Color(0xFF6D92F5),
    points: [
      BarChartPoint(
        xLabel: 'Sep',
        value: 4200,
        tooltipLabel: 'Sep',
        tooltipValue: r'Spend: $4200',
      ),
      BarChartPoint(
        xLabel: 'Oct',
        value: 3500,
        tooltipLabel: 'Oct',
        tooltipValue: r'Spend: $3500',
      ),
      BarChartPoint(
        xLabel: 'Nov',
        value: 4500,
        tooltipLabel: 'Nov',
        tooltipValue: r'Spend: $4500',
      ),
      BarChartPoint(
        xLabel: 'Dec',
        value: 3800,
        tooltipLabel: 'Dec',
        tooltipValue: r'Spend: $3800',
      ),
      BarChartPoint(
        xLabel: 'Jan',
        value: 4700,
        tooltipLabel: 'Jan',
        tooltipValue: r'Spend: $4700',
      ),
      BarChartPoint(
        xLabel: 'Feb',
        value: 5000,
        tooltipLabel: 'Feb',
        tooltipValue: r'Spend: $5000',
      ),
    ],
  ),
  BarChartSeries(
    label: 'Reference 2',
    color: Color(0xFFE98AD4),
    points: [
      BarChartPoint(
        xLabel: 'Sep',
        value: 5200,
        tooltipLabel: 'Sep',
        tooltipValue: r'Spend: $5200',
      ),
      BarChartPoint(
        xLabel: 'Oct',
        value: 1580,
        tooltipLabel: 'Oct',
        tooltipValue: r'Spend: $1580',
      ),
      BarChartPoint(
        xLabel: 'Nov',
        value: 3200,
        tooltipLabel: 'Nov',
        tooltipValue: r'Spend: $3200',
      ),
      BarChartPoint(
        xLabel: 'Dec',
        value: 4100,
        tooltipLabel: 'Dec',
        tooltipValue: r'Spend: $4100',
      ),
      BarChartPoint(
        xLabel: 'Jan',
        value: 4900,
        tooltipLabel: 'Jan',
        tooltipValue: r'Spend: $4900',
      ),
      BarChartPoint(
        xLabel: 'Feb',
        value: 6200,
        tooltipLabel: 'Feb',
        tooltipValue: r'Spend: $6200',
      ),
    ],
  ),
];

const _chart = AppBarChart(
  series: _series,
  yAxisLabels: _yLabels,
  minValue: 0,
  maxValue: 8000,
);

void main() {
  group(AppBarChart, () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: SizedBox(width: 617, height: 291, child: _chart),
        ),
      );

      expect(find.byType(AppBarChart), findsOneWidget);
    });

    testWidgets('renders x-axis labels', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: SizedBox(width: 617, height: 291, child: _chart),
        ),
      );

      expect(find.text('Sep'), findsOneWidget);
      expect(find.text('Oct'), findsOneWidget);
      expect(find.text('Feb'), findsOneWidget);
    });

    testWidgets('renders y-axis labels', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: SizedBox(width: 617, height: 291, child: _chart),
        ),
      );

      expect(find.text(r'$0.0k'), findsOneWidget);
      expect(find.text(r'$8.0k'), findsOneWidget);
    });

    testWidgets('renders legend labels', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: SizedBox(width: 617, height: 291, child: _chart),
        ),
      );

      expect(find.text('Reference 1'), findsOneWidget);
      expect(find.text('Reference 2'), findsOneWidget);
    });

    testWidgets('default state shows no tooltip', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: SizedBox(width: 617, height: 291, child: _chart),
        ),
      );

      expect(
        find.textContaining(r'Spend: $4200', findRichText: true),
        findsNothing,
      );
    });

    testWidgets('tapping chart does not throw', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      await tester.pumpApp(
        const Scaffold(
          body: SizedBox(width: 617, height: 291, child: _chart),
        ),
      );

      final chartPos = tester.getTopLeft(find.byType(AppBarChart));
      await tester.tapAt(chartPos + const Offset(80, 160));
      await tester.pumpAndSettle();

      debugDefaultTargetPlatformOverride = null;

      expect(find.byType(AppBarChart), findsOneWidget);
    });

    testWidgets('renders with empty series list without error', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: SizedBox(
            width: 617,
            height: 291,
            child: AppBarChart(
              series: [],
              yAxisLabels: _yLabels,
              minValue: 0,
              maxValue: 8000,
            ),
          ),
        ),
      );

      expect(find.byType(AppBarChart), findsOneWidget);
    });

    testWidgets('renders with single series without error', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: SizedBox(
            width: 617,
            height: 291,
            child: AppBarChart(
              series: [
                BarChartSeries(
                  label: 'Reference 1',
                  color: Color(0xFF6D92F5),
                  points: [
                    BarChartPoint(
                      xLabel: 'Jan',
                      value: 4000,
                      tooltipLabel: 'Jan',
                      tooltipValue: r'Spend: $4000',
                    ),
                  ],
                ),
              ],
              yAxisLabels: _yLabels,
              minValue: 0,
              maxValue: 8000,
            ),
          ),
        ),
      );

      expect(find.byType(AppBarChart), findsOneWidget);
      expect(find.text('Reference 1'), findsOneWidget);
    });
  });

  group(BarChartPoint, () {
    test('equality holds for identical values', () {
      const a = BarChartPoint(
        xLabel: 'Jan',
        value: 1000,
        tooltipLabel: 'Jan',
        tooltipValue: r'$1000',
      );
      const b = BarChartPoint(
        xLabel: 'Jan',
        value: 1000,
        tooltipLabel: 'Jan',
        tooltipValue: r'$1000',
      );
      expect(a, equals(b));
    });

    test('equality fails when values differ', () {
      const a = BarChartPoint(
        xLabel: 'Jan',
        value: 1000,
        tooltipLabel: 'Jan',
        tooltipValue: r'$1000',
      );
      const b = BarChartPoint(
        xLabel: 'Feb',
        value: 1000,
        tooltipLabel: 'Feb',
        tooltipValue: r'$1000',
      );
      expect(a, isNot(equals(b)));
    });
  });

  group(BarChartSeries, () {
    test('equality holds for identical values', () {
      const a = BarChartSeries(
        label: 'Series A',
        color: Color(0xFF6D92F5),
        points: [
          BarChartPoint(
            xLabel: 'Jan',
            value: 1000,
            tooltipLabel: 'Jan',
            tooltipValue: r'$1000',
          ),
        ],
      );
      const b = BarChartSeries(
        label: 'Series A',
        color: Color(0xFF6D92F5),
        points: [
          BarChartPoint(
            xLabel: 'Jan',
            value: 1000,
            tooltipLabel: 'Jan',
            tooltipValue: r'$1000',
          ),
        ],
      );
      expect(a, equals(b));
    });

    test('equality fails when label differs', () {
      const a = BarChartSeries(
        label: 'Series A',
        color: Color(0xFF6D92F5),
        points: [],
      );
      const b = BarChartSeries(
        label: 'Series B',
        color: Color(0xFF6D92F5),
        points: [],
      );
      expect(a, isNot(equals(b)));
    });
  });
}
