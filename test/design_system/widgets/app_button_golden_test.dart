import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(AppButton, () {
    for (final themeType in ThemeType.values) {
      unawaited(
        goldenTest(
          'renders all variants - ${themeType.name}',
          fileName: 'app_button_${themeType.name}',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 320),
            children: [
              GoldenTestScenario(
                name: 'filled enabled',
                child: themedApp(
                  themeType: themeType,
                  child: AppButton(label: 'Continue', onPressed: () {}),
                ),
              ),
              GoldenTestScenario(
                name: 'filled disabled',
                child: themedApp(
                  themeType: themeType,
                  child: const AppButton(label: 'Continue'),
                ),
              ),
              GoldenTestScenario(
                name: 'filled loading',
                child: themedApp(
                  themeType: themeType,
                  child: const AppButton(label: 'Continue', isLoading: true),
                ),
              ),
              GoldenTestScenario(
                name: 'filled with icons',
                child: themedApp(
                  themeType: themeType,
                  child: AppButton(
                    label: 'Next',
                    leadingIcon: const Icon(Icons.add),
                    trailingIcon: const Icon(Icons.arrow_forward),
                    onPressed: () {},
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'outlined enabled',
                child: themedApp(
                  themeType: themeType,
                  child: AppButton(
                    label: 'Cancel',
                    variant: AppButtonVariant.outlined,
                    onPressed: () {},
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'outlined disabled',
                child: themedApp(
                  themeType: themeType,
                  child: const AppButton(
                    label: 'Cancel',
                    variant: AppButtonVariant.outlined,
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'gradient enabled',
                child: themedApp(
                  themeType: themeType,
                  child: AppButton(
                    label: 'Get started',
                    variant: AppButtonVariant.gradient,
                    onPressed: () {},
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'small filled',
                child: themedApp(
                  themeType: themeType,
                  child: AppButton(
                    label: 'Small',
                    size: AppButtonSize.small,
                    onPressed: () {},
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
