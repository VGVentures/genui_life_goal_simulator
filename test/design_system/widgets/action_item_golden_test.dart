import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(ActionItem, () {
    for (final themeType in ThemeType.values) {
      unawaited(
        goldenTest(
          'renders variants - ${themeType.name}',
          fileName: 'action_item_${themeType.name}',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 520),
            children: [
              GoldenTestScenario(
                name: 'simple',
                child: themedApp(
                  themeType: themeType,
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
                  themeType: themeType,
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
                  themeType: themeType,
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

    for (final themeType in ThemeType.values) {
      unawaited(
        goldenTest(
          'renders list - ${themeType.name}',
          fileName: 'action_items_group_${themeType.name}',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 520),
            children: [
              GoldenTestScenario(
                name: 'multiple items',
                child: themedApp(
                  themeType: themeType,
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
