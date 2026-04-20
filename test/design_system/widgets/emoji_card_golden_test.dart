import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

import '../../helpers/helpers.dart';

void main() {
  group(EmojiCard, () {
    for (final themeType in ThemeType.values) {
      unawaited(
        goldenTest(
          'renders - ${themeType.name}',
          fileName: 'emoji_card_${themeType.name}',
          pumpBeforeTest: pumpOnce,
          builder: () => GoldenTestGroup(
            scenarioConstraints: const BoxConstraints(maxWidth: 360),
            children: [
              GoldenTestScenario(
                name: 'unselected',
                child: themedApp(
                  themeType: themeType,
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
                  themeType: themeType,
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
                  themeType: themeType,
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
