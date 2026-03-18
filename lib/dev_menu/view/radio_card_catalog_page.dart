import 'package:flutter/material.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

/// {@template radio_card_catalog_page}
/// Catalog page showcasing [RadioCard] in selected and unselected states.
/// {@endtemplate}
class RadioCardCatalogPage extends StatefulWidget {
  /// {@macro radio_card_catalog_page}
  const RadioCardCatalogPage({super.key});

  @override
  State<RadioCardCatalogPage> createState() => _RadioCardCatalogPageState();
}

class _RadioCardCatalogPageState extends State<RadioCardCatalogPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();

    return Scaffold(
      backgroundColor: colors?.surfaceVariant,
      appBar: AppBar(title: const Text('RadioCard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: RadioCard(
                    label: 'Monthly',
                    isSelected: _selectedIndex == 0,
                    onTap: () => setState(() => _selectedIndex = 0),
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: RadioCard(
                    label: 'Yearly',
                    isSelected: _selectedIndex == 1,
                    onTap: () => setState(() => _selectedIndex = 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
