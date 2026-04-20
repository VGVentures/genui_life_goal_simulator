import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(FilterBar, () {
    for (final themeType in ThemeType.values) {
      unawaited(
        goldenTest(
          'renders - ${themeType.name}',
          fileName: 'filter_bar_${themeType.name}',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 520),
            children: [
              GoldenTestScenario(
                name: 'mixed selections',
                child: themedApp(
                  themeType: themeType,
                  child: FilterBar(
                    categories: const [
                      FilterCategory(
                        label: 'Dining',
                        color: FilterChipColor.mustard,
                        isSelected: true,
                      ),
                      FilterCategory(
                        label: 'Shopping',
                        color: FilterChipColor.pink,
                      ),
                      FilterCategory(
                        label: 'Transport',
                        color: FilterChipColor.lightBlue,
                        isSelected: true,
                      ),
                      FilterCategory(
                        label: 'Entertainment',
                        color: FilterChipColor.emerald,
                      ),
                    ],
                    onCategoryToggled: (_) {},
                    onAllToggled: () {},
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
