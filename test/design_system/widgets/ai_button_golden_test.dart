import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(AiButton, () {
    for (final appTheme in AppThemes.values) {
      final name = appTheme.name;
      unawaited(
        goldenTest(
          'renders - $name',
          fileName: 'ai_button_$name',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 320),
            children: [
              GoldenTestScenario(
                name: 'default',
                child: themedApp(
                  appTheme: appTheme,
                  child: AiButton(
                    text: 'Ask the AI',
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
