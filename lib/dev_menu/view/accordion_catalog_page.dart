import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';

/// {@template accordion_catalog_page}
/// Catalog page showcasing [AppAccordion] in collapsed and expanded states.
/// {@endtemplate}
class AccordionCatalogPage extends StatelessWidget {
  /// {@macro accordion_catalog_page}
  const AccordionCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final actionItems = ActionItemsGroup(
      items: [
        for (var i = 0; i < 5; i++)
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
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Accordion')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionLabel('Collapsed state (tap to expand)'),
            AppAccordion(
              title: 'Drawer Title',
              content: actionItems,
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
