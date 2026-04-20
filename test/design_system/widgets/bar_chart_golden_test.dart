import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

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
    ],
  ),
];

void main() {
  group(AppBarChart, () {
    for (final appTheme in AppThemes.values) {
      final name = appTheme.name;
      unawaited(
        goldenTest(
          'renders - $name',
          fileName: 'bar_chart_$name',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 640),
            children: [
              GoldenTestScenario(
                name: 'grouped series',
                child: themedApp(
                  appTheme: appTheme,
                  child: const SizedBox(
                    width: 600,
                    height: 280,
                    child: AppBarChart(
                      series: _series,
                      yAxisLabels: _yLabels,
                      minValue: 0,
                      maxValue: 8000,
                    ),
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'empty series',
                child: themedApp(
                  appTheme: appTheme,
                  child: const SizedBox(
                    width: 600,
                    height: 280,
                    child: AppBarChart(
                      series: [],
                      yAxisLabels: _yLabels,
                      minValue: 0,
                      maxValue: 8000,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  });
}
