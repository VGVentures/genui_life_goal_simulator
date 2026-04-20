import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(SectionHeader, () {
    for (final appTheme in AppThemes.values) {
      final name = appTheme.name;
      unawaited(
        goldenTest(
          'renders - $name',
          fileName: 'section_header_$name',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 520),
            children: [
              GoldenTestScenario(
                name: 'title and subtitle only',
                child: themedApp(
                  appTheme: appTheme,
                  child: const SectionHeader(
                    title: 'Your spending this month',
                    subtitle: 'February 2026 • 19 days tracked',
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'with selector',
                child: themedApp(
                  appTheme: appTheme,
                  child: SectionHeader(
                    title: 'Spending trends',
                    subtitle: 'Last 6 months',
                    selectorOptions: const ['1M', '3M', '6M'],
                    onSelectorChanged: (_) {},
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
