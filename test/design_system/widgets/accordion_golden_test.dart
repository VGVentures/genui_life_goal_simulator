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

    for (final themeType in ThemeType.values) {
      unawaited(
        goldenTest(
          'renders states - ${themeType.name}',
          fileName: 'accordion_${themeType.name}',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 520),
            children: [
              GoldenTestScenario(
                name: 'collapsed',
                child: themedApp(
                  themeType: themeType,
                  child: AppAccordion(
                    title: 'Spending breakdown',
                    content: content,
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'expanded',
                child: themedApp(
                  themeType: themeType,
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
