import 'package:finance_app/app/presentation.dart';
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
    final colorExtension = Theme.of(context).extension<AppColors>();

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.xs,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            scenario.description.characters.first.toUpperCase(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        title: Text(
          scenario.name,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: colorExtension?.primary.shade900,
          ),
        ),
        subtitle: Text(
          scenario.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colorExtension?.secondary.shade500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
