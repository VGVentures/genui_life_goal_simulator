import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(EmojiCard, () {
    for (final appTheme in AppThemes.values) {
      final name = appTheme.name;
      unawaited(
        goldenTest(
          'renders - $name',
          fileName: 'emoji_card_$name',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 360),
            children: [
              GoldenTestScenario(
                name: 'unselected',
                child: themedApp(
                  appTheme: appTheme,
                  child: EmojiCard(
                    emoji: '📊',
                    label: 'Fixed costs',
                    onTap: () {},
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'selected',
                child: themedApp(
                  appTheme: appTheme,
                  child: EmojiCard(
                    emoji: '💰',
                    label: '% of income',
                    isSelected: true,
                    onTap: () {},
                  ),
                ),
              ),
              GoldenTestScenario(
                name: 'layout',
                child: themedApp(
                  appTheme: appTheme,
                  child: EmojiCardLayout(
                    cards: [
                      EmojiCard(
                        emoji: '📊',
                        label: 'Fixed costs',
                        onTap: () {},
                      ),
                      EmojiCard(
                        emoji: '💰',
                        label: '% of income',
                        isSelected: true,
                        onTap: () {},
                      ),
                      EmojiCard(emoji: '🏦', label: 'Savings', onTap: () {}),
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
