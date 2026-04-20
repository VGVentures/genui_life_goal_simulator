import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

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

void main() {
  group(LineChart, () {
    for (final themeType in ThemeType.values) {
      unawaited(
        goldenTest(
          'renders - ${themeType.name}',
          fileName: 'line_chart_${themeType.name}',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 700),
            children: [
              GoldenTestScenario(
                name: 'six months',
                child: themedApp(
                  themeType: themeType,
                  child: const SizedBox(
                    width: 660,
                    height: 240,
                    child: LineChart(
                      points: _points,
                      yAxisLabels: [
                        r'$0.0k',
                        r'$1.5k',
                        r'$3.0k',
                        r'$4.5k',
                        r'$6.0k',
                      ],
                      minValue: 0,
                      maxValue: 6000,
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
