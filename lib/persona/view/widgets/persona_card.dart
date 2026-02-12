import 'package:finance_app/financials/mock/mock_scenario.dart';
import 'package:flutter/material.dart';

class PersonaCard extends StatelessWidget {
  const PersonaCard({
    required this.scenario,
    required this.onTap,
    super.key,
  });

  final MockScenario scenario;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      //TODO(juanRodriguez17): Uses styles app when gets merged
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            scenario.description.characters.first.toUpperCase(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        title: Text(scenario.name),
        subtitle: Text(
          scenario.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
