import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(GCNSlider, () {
    const size = Size(520, 220);

    for (final themeType in ThemeType.values) {
      unawaited(
        goldenTest(
          'renders - ${themeType.name}',
          fileName: 'gcn_slider_${themeType.name}',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: BoxConstraints.tight(size),
            children: [
              GoldenTestScenario(
                name: 'continuous',
                child: themedAppWithOverlay(
                  themeType: themeType,
                  size: size,
                  child: GCNSlider(
                    title: 'Monthly budget',
                    subtitle: 'Dining • Feb 18',
                    value: 450,
                    min: 0,
                    max: 1000,
                    valueLabel: r'$450',
                    onChanged: (_) {},
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'discrete with splits',
                child: themedAppWithOverlay(
                  themeType: themeType,
                  size: size,
                  child: GCNSlider(
                    title: 'Time horizon',
                    subtitle: 'Years until retirement',
                    value: 3,
                    min: 1,
                    max: 6,
                    divisions: 5,
                    splitLabels: const ['1', '2', '3', '4', '5', '6'],
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
