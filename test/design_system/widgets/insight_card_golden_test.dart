import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(InsightCard, () {
    for (final appTheme in AppThemes.values) {
      final name = appTheme.name;
      unawaited(
        goldenTest(
          'renders - $name',
          fileName: 'insight_card_$name',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 420),
            children: [
              GoldenTestScenario(
                name: 'neutral',
                child: themedApp(
                  appTheme: appTheme,
                  child: const InsightCard(
                    title: 'You spent less this week',
                    description: 'Weekly dining down 12% vs 3mo average.',
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'neutral with custom emoji',
                child: themedApp(
                  appTheme: appTheme,
                  child: const InsightCard(
                    emoji: '📈',
                    title: 'Savings on track',
                    description: 'You hit 64% of your monthly savings target.',
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'success',
                child: themedApp(
                  appTheme: appTheme,
                  child: const InsightCard(
                    variant: InsightCardVariant.success,
                    title: 'Goal reached',
                    description: r'You saved $1,200 this month — nice work!',
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'warning',
                child: themedApp(
                  appTheme: appTheme,
                  child: const InsightCard(
                    variant: InsightCardVariant.warning,
                    title: 'Spending trending up',
                    description: 'Dining is 30% above your average this month.',
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'error',
                child: themedApp(
                  appTheme: appTheme,
                  child: const InsightCard(
                    variant: InsightCardVariant.error,
                    title: 'Over budget',
                    description: r'You exceeded your shopping budget by $240.',
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
