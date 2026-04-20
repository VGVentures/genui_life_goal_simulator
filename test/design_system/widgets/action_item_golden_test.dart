import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(ActionItem, () {
    for (final appTheme in AppThemes.values) {
      final name = appTheme.name;
      unawaited(
        goldenTest(
          'renders variants - $name',
          fileName: 'action_item_$name',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 520),
            children: [
              GoldenTestScenario(
                name: 'simple',
                child: themedApp(
                  appTheme: appTheme,
                  child: const ActionItem(
                    title: 'Restaurant',
                    subtitle: 'Dining • Feb 18',
                    amount: r'$87',
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'with delta',
                child: themedApp(
                  appTheme: appTheme,
                  child: const ActionItem(
                    title: 'Restaurant',
                    subtitle: 'Dining • Feb 18',
                    amount: r'$450',
                    delta: '+28%',
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'with trailing',
                child: themedApp(
                  appTheme: appTheme,
                  child: ActionItem(
                    title: 'Netflix',
                    subtitle: 'Subscriptions • Feb 15',
                    amount: r'$18',
                    trailing: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Cancel'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    for (final appTheme in AppThemes.values) {
      final name = appTheme.name;
      unawaited(
        goldenTest(
          'renders list - $name',
          fileName: 'action_items_group_$name',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 520),
            children: [
              GoldenTestScenario(
                name: 'multiple items',
                child: themedApp(
                  appTheme: appTheme,
                  child: ActionItemsGroup(
                    items: [
                      ActionItem(
                        title: 'Restaurant',
                        subtitle: 'Dining • Feb 18',
                        amount: r'$450',
                        delta: '+28%',
                        trailing: FilledButton(
                          onPressed: () {},
                          child: const Text('Details'),
                        ),
                      ),
                      ActionItem(
                        title: 'Netflix',
                        subtitle: 'Subscriptions • Feb 15',
                        amount: r'$18',
                        trailing: OutlinedButton(
                          onPressed: () {},
                          child: const Text('Cancel'),
                        ),
                      ),
                      const ActionItem(
                        title: 'Lunch',
                        subtitle: 'Dining • Feb 18',
                        amount: r'$14',
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
