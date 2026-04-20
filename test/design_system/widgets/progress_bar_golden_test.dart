import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(ProgressBar, () {
    for (final appTheme in AppThemes.values) {
      final name = appTheme.name;
      unawaited(
        goldenTest(
          'renders - $name',
          fileName: 'progress_bar_$name',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 520),
            children: [
              GoldenTestScenario(
                name: 'half',
                child: themedApp(
                  appTheme: appTheme,
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
                  appTheme: appTheme,
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
