import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(SparklineCard, () {
    for (final themeType in ThemeType.values) {
      unawaited(
        goldenTest(
          'renders - ${themeType.name}',
          fileName: 'sparkline_card_${themeType.name}',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 520),
            children: [
              GoldenTestScenario(
                name: 'positive trend',
                child: themedApp(
                  themeType: themeType,
                  child: const SparklineCard(
                    label: 'Savings',
                    amount: r'$12,500',
                    trend: TrendType.positive,
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'negative trend',
                child: themedApp(
                  themeType: themeType,
                  child: const SparklineCard(
                    label: 'Spending',
                    amount: r'$3,200',
                    trend: TrendType.negative,
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'stable trend',
                child: themedApp(
                  themeType: themeType,
                  child: const SparklineCard(
                    label: 'Dining',
                    amount: r'$421',
                    trend: TrendType.stable,
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'layout',
                child: themedApp(
                  themeType: themeType,
                  child: const SparklineCardsLayout(
                    cards: [
                      SparklineCard(
                        label: 'Savings',
                        amount: r'$12,500',
                        trend: TrendType.positive,
                      ),
                      SparklineCard(
                        label: 'Spending',
                        amount: r'$3,200',
                        trend: TrendType.negative,
                      ),
                      SparklineCard(
                        label: 'Dining',
                        amount: r'$421',
                        trend: TrendType.stable,
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
