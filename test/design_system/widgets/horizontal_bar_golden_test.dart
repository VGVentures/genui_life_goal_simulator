import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(HorizontalBar, () {
    for (final themeType in ThemeType.values) {
      unawaited(
        goldenTest(
          'renders - ${themeType.name}',
          fileName: 'horizontal_bar_${themeType.name}',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 520),
            children: [
              GoldenTestScenario(
                name: 'partial progress',
                child: themedApp(
                  themeType: themeType,
                  child: const HorizontalBar(
                    category: 'Dining',
                    amount: r'$420',
                    progress: 0.6,
                    comparisonLabel: 'vs last month',
                    comparisonValue: '-5%',
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'near full',
                child: themedApp(
                  themeType: themeType,
                  child: const HorizontalBar(
                    category: 'Shopping',
                    amount: r'$980',
                    progress: 0.95,
                    comparisonLabel: 'vs last month',
                    comparisonValue: '+22%',
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
