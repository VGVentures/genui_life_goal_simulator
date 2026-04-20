import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(MetricCard, () {
    for (final appTheme in AppThemes.values) {
      final name = appTheme.name;
      unawaited(
        goldenTest(
          'renders - $name',
          fileName: 'metric_card_$name',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 520),
            children: [
              GoldenTestScenario(
                name: 'plain',
                child: themedApp(
                  appTheme: appTheme,
                  child: const MetricCard(
                    label: 'Fixed costs',
                    value: r'$4,319',
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'positive delta',
                child: themedApp(
                  appTheme: appTheme,
                  child: const MetricCard(
                    label: 'Negotiable',
                    value: r'$645',
                    subtitle: r'+$40 above 3mo avg',
                    delta: '+12%',
                    deltaDirection: MetricDeltaDirection.positive,
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'negative delta',
                child: themedApp(
                  appTheme: appTheme,
                  child: const MetricCard(
                    label: 'Discretionary',
                    value: r'$312',
                    subtitle: r'-$88 vs 3mo avg',
                    delta: '-22%',
                    deltaDirection: MetricDeltaDirection.negative,
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'layout',
                child: themedApp(
                  appTheme: appTheme,
                  child: const MetricCardsLayout(
                    cards: [
                      MetricCard(label: 'Fixed costs', value: r'$4,319'),
                      MetricCard(label: '% of income', value: '45%'),
                      MetricCard(label: 'Savings', value: r'$1,820'),
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
