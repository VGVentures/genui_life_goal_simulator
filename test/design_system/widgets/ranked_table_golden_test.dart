import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(RankedTable, () {
    for (final themeType in ThemeType.values) {
      unawaited(
        goldenTest(
          'renders - ${themeType.name}',
          fileName: 'ranked_table_${themeType.name}',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 520),
            children: [
              GoldenTestScenario(
                name: 'default',
                child: themedApp(
                  themeType: themeType,
                  child: const RankedTable(
                    items: [
                      RankedTableItem(
                        title: 'The French Laundry',
                        amount: r'$350',
                        delta: '+15%',
                      ),
                      RankedTableItem(
                        title: 'Whole Foods',
                        amount: r'$212',
                        delta: '+4%',
                      ),
                      RankedTableItem(
                        title: 'Shell Gas',
                        amount: r'$85',
                        delta: '-12%',
                      ),
                      RankedTableItem(
                        title: 'Netflix',
                        amount: r'$18',
                        delta: '0%',
                      ),
                    ],
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
