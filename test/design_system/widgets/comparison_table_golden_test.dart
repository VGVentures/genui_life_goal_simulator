import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(ComparisonTable, () {
    for (final appTheme in AppThemes.values) {
      final name = appTheme.name;
      unawaited(
        goldenTest(
          'renders - $name',
          fileName: 'comparison_table_$name',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 520),
            children: [
              GoldenTestScenario(
                name: 'default',
                child: themedApp(
                  appTheme: appTheme,
                  child: const ComparisonTable(
                    items: [
                      ComparisonTableItem(
                        label: 'Groceries',
                        lastMonthAmount: 300,
                        actualMonthAmount: 315,
                      ),
                      ComparisonTableItem(
                        label: 'Dining',
                        lastMonthAmount: 450,
                        actualMonthAmount: 400,
                      ),
                      ComparisonTableItem(
                        label: 'Transport',
                        lastMonthAmount: 120,
                        actualMonthAmount: 95,
                      ),
                    ],
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
