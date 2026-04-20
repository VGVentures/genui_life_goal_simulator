import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(HeaderSelector, () {
    for (final themeType in ThemeType.values) {
      unawaited(
        goldenTest(
          'renders - ${themeType.name}',
          fileName: 'header_selector_${themeType.name}',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 340),
            children: [
              GoldenTestScenario(
                name: 'first selected',
                child: themedApp(
                  themeType: themeType,
                  child: HeaderSelector(
                    options: const ['1M', '3M', '6M'],
                    selectedIndex: 0,
                    onChanged: (_) {},
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'middle selected',
                child: themedApp(
                  themeType: themeType,
                  child: HeaderSelector(
                    options: const ['1M', '3M', '6M'],
                    selectedIndex: 1,
                    onChanged: (_) {},
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
