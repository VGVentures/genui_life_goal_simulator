import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';

/// {@template action_item_catalog_page}
/// Catalog page showcasing all [ActionItem] variants and [ActionItemsGroup].
/// {@endtemplate}
class ActionItemCatalogPage extends StatelessWidget {
  /// {@macro action_item_catalog_page}
  const ActionItemCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('ActionItem')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionLabel('With trailing button'),
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
            const SizedBox(height: Spacing.xl),
            const _SectionLabel('Without trailing'),
            const ActionItem(
              title: 'Restaurant',
              subtitle: 'Dining • Feb 18',
              amount: r'$87',
            ),
            const SizedBox(height: Spacing.xl),
            const _SectionLabel('ActionItemsGroup'),
            ActionItemsGroup(
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
                  title: 'Restaurant',
                  subtitle: 'Dining • Feb 18',
                  amount: r'$87',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.xs),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).extension<AppColors>()?.onSurfaceMuted,
        ),
      ),
    );
  }
}
