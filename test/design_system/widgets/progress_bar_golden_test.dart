import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(ProgressBar, () {
    for (final themeType in ThemeType.values) {
      unawaited(
        goldenTest(
          'renders - ${themeType.name}',
          fileName: 'progress_bar_${themeType.name}',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 520),
            children: [
              GoldenTestScenario(
                name: 'half',
                child: themedApp(
                  themeType: themeType,
                  child: ProgressBar(
                    title: 'Dining',
                    value: 200,
                    total: 400,
                    formatValue: (v) => '\$${v.toStringAsFixed(0)}',
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'full',
                child: themedApp(
                  themeType: themeType,
                  child: ProgressBar(
                    title: 'Shopping',
                    value: 400,
                    total: 400,
                    formatValue: (v) => '\$${v.toStringAsFixed(0)}',
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
