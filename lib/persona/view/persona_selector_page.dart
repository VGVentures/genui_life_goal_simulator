import 'package:finance_app/chat/chat.dart';
import 'package:finance_app/financials/mock/mock.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:finance_app/persona/persona.dart';
import 'package:flutter/material.dart';

class PersonaSelectorPage extends StatelessWidget {
  const PersonaSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.homeAppBarTitle)),
      body: ListView.builder(
        //TODO(juanRodriguez17): Uses styles app when gets merged
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: scenarios.length,
        itemBuilder: (context, index) {
          final scenario = scenarios[index];
          return PersonaCard(
            scenario: scenario,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ChatPage(scenario: scenario),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// All available personas for the financial advisor.
final scenarios = <MockScenario>[
  youngResponsibleScenario,
  youngRecklessScenario,
  olderStableScenario,
  olderStrugglingScenario,
];
