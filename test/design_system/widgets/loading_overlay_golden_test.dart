import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(LoadingOverlay, () {
    for (final themeType in ThemeType.values) {
      unawaited(
        goldenTest(
          'renders - ${themeType.name}',
          fileName: 'loading_overlay_${themeType.name}',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 420),
            children: [
              GoldenTestScenario(
                name: 'default background',
                child: themedApp(
                  themeType: themeType,
                  child: const SizedBox(
                    width: 360,
                    height: 240,
                    child: LoadingOverlay(),
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
