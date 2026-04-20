import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(CategoryFilterChip, () {
    for (final themeType in ThemeType.values) {
      unawaited(
        goldenTest(
          'renders - ${themeType.name}',
          fileName: 'category_filter_chip_${themeType.name}',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 340),
            children: [
              GoldenTestScenario(
                name: 'all colors selected',
                child: themedApp(
                  themeType: themeType,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final color in FilterChipColor.values)
                        CategoryFilterChip(
                          color: color,
                          label: color.name,
                          isSelected: true,
                          onTap: () {},
                        ),
                    ],
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'unselected',
                child: themedApp(
                  themeType: themeType,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final color in FilterChipColor.values.take(4))
                        CategoryFilterChip(
                          color: color,
                          label: color.name,
                          isSelected: false,
                          onTap: () {},
                        ),
                    ],
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'disabled',
                child: themedApp(
                  themeType: themeType,
                  child: const CategoryFilterChip(
                    color: FilterChipColor.pink,
                    label: 'Disabled',
                    isSelected: false,
                    isEnabled: false,
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
