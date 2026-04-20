import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(TransactionList, () {
    for (final appTheme in AppThemes.values) {
      final name = appTheme.name;
      unawaited(
        goldenTest(
          'renders - $name',
          fileName: 'transaction_list_$name',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 520),
            children: [
              GoldenTestScenario(
                name: 'multiple items',
                child: themedApp(
                  appTheme: appTheme,
                  child: TransactionList(
                    items: [
                      TransactionListItem(
                        title: 'Nobu Restaurant',
                        description: 'Dining',
                        amount: r'$450',
                        onViewDetails: () {},
                      ),
                      TransactionListItem(
                        title: 'Whole Foods',
                        description: 'Groceries',
                        amount: r'$212',
                        onViewDetails: () {},
                      ),
                      const TransactionListItem(
                        title: 'Netflix',
                        description: 'Subscriptions',
                        amount: r'$18',
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
