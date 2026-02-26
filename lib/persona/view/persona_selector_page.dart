import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/financials/mock/mock.dart';
import 'package:finance_app/onboarding/want_to_focus/want_to_focus.dart';
import 'package:finance_app/persona/persona.dart';
import 'package:flutter/material.dart';

class PersonaSelectorPage extends StatelessWidget {
  const PersonaSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: Spacing.md),
      itemCount: scenarios.length,
      itemBuilder: (context, index) {
        final scenario = scenarios[index];
        return PersonaCard(
          scenario: scenario,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const WantToFocusPage(),
            ),
          ),
        );
      },
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
