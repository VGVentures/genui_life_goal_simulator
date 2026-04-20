import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

Widget _coloredBox({required String label, required Color color}) => Container(
  color: color,
  alignment: Alignment.center,
  padding: const EdgeInsets.all(16),
  child: Text(label, style: const TextStyle(color: Colors.white)),
);

void main() {
  group(ResponsiveScaffold, () {
    unawaited(
      goldenTest(
        'picks mobile vs desktop child',
        fileName: 'responsive_scaffold',
        pumpBeforeTest: pumpOnce,
        builder: () => GoldenTestGroup(
          scenarioConstraints: const BoxConstraints(maxWidth: 1000),
          children: [
            GoldenTestScenario(
              name: 'mobile width',
              child: themedApp(
                child: SizedBox(
                  width: 400,
                  height: 80,
                  child: ResponsiveScaffold(
                    mobile: _coloredBox(
                      label: 'Mobile layout',
                      color: Colors.indigo,
                    ),
                    desktop: _coloredBox(
                      label: 'Desktop layout',
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
            ),
            GoldenTestScenario(
              name: 'desktop width',
              child: themedApp(
                child: SizedBox(
                  width: 900,
                  height: 80,
                  child: ResponsiveScaffold(
                    mobile: _coloredBox(
                      label: 'Mobile layout',
                      color: Colors.indigo,
                    ),
                    desktop: _coloredBox(
                      label: 'Desktop layout',
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  });
}
