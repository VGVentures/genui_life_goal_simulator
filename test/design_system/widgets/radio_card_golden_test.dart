import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(RadioCard, () {
    for (final appTheme in AppThemes.values) {
      final name = appTheme.name;
      unawaited(
        goldenTest(
          'renders - $name',
          fileName: 'radio_card_$name',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 360),
            children: [
              GoldenTestScenario(
                name: 'unselected',
                child: themedApp(
                  appTheme: appTheme,
                  child: RadioCard(
                    label: 'Aggressive growth',
                    isSelected: false,
                    onTap: () {},
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'selected',
                child: themedApp(
                  appTheme: appTheme,
                  child: RadioCard(
                    label: 'Balanced',
                    isSelected: true,
                    onTap: () {},
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
