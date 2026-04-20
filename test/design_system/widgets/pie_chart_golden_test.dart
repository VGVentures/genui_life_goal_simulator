import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

const _items = [
  PieChartItem(
    label: 'Groceries',
    value: 1420,
    amount: r'$1,420',
    color: Color(0xFFE98AD4),
  ),
  PieChartItem(
    label: 'Dining',
    value: 980,
    amount: r'$980',
    color: Color(0xFF6D92F5),
  ),
  PieChartItem(
    label: 'Transport',
    value: 560,
    amount: r'$560',
    color: Color(0xFF00A65F),
  ),
  PieChartItem(
    label: 'Shopping',
    value: 1300,
    amount: r'$1,300',
    color: Color(0xFFF69426),
  ),
];

void main() {
  group(PieChartComponent, () {
    for (final appTheme in AppThemes.values) {
      final name = appTheme.name;
      unawaited(
        goldenTest(
          'renders - $name',
          fileName: 'pie_chart_$name',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 720),
            children: [
              GoldenTestScenario(
                name: 'none selected',
                child: themedApp(
                  appTheme: appTheme,
                  mediaQuerySize: const Size(1200, 800),
                  child: const SizedBox(
                    width: 680,
                    height: 280,
                    child: PieChartComponent(
                      items: _items,
                      totalLabel: 'Total',
                      totalAmount: r'$4,260',
                    ),
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'first selected',
                child: themedApp(
                  appTheme: appTheme,
                  mediaQuerySize: const Size(1200, 800),
                  child: const SizedBox(
                    width: 680,
                    height: 280,
                    child: PieChartComponent(
                      items: _items,
                      totalLabel: 'Total',
                      totalAmount: r'$4,260',
                      selectedIndex: 0,
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
