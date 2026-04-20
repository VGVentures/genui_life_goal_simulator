import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(AppAccordion, () {
    final content = ActionItemsGroup(
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
        const ActionItem(
          title: 'Netflix',
          subtitle: 'Subscriptions • Feb 15',
          amount: r'$18',
        ),
      ],
    );

    for (final appTheme in AppThemes.values) {
      final name = appTheme.name;
      unawaited(
        goldenTest(
          'renders states - $name',
          fileName: 'accordion_$name',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 520),
            children: [
              GoldenTestScenario(
                name: 'collapsed',
                child: themedApp(
                  appTheme: appTheme,
                  child: AppAccordion(
                    title: 'Spending breakdown',
                    content: content,
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'expanded',
                child: themedApp(
                  appTheme: appTheme,
                  child: AppAccordion(
                    title: 'Spending breakdown',
                    content: content,
                    isExpanded: true,
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
