import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// {@template section_header_catalog_page}
/// Catalog page showcasing [SectionHeader] variants.
/// {@endtemplate}
class SectionHeaderCatalogPage extends StatefulWidget {
  /// {@macro section_header_catalog_page}
  const SectionHeaderCatalogPage({super.key});

  @override
  State<SectionHeaderCatalogPage> createState() =>
      _SectionHeaderCatalogPageState();
}

class _SectionHeaderCatalogPageState extends State<SectionHeaderCatalogPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
    return Scaffold(
      backgroundColor: colors?.surfaceVariant,
      appBar: AppBar(title: const Text('SectionHeader')),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.md),
        children: [
          const Text(
            'Without selector',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: Spacing.xs),
          const SectionHeader(
            title: 'Your spending this month',
            subtitle: 'February 2026 • 19 days tracked',
          ),
          const SizedBox(height: Spacing.xl),
          const Text(
            'With selector',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: Spacing.xs),
          SectionHeader(
            title: 'Your spending this month',
            subtitle: 'February 2026 • 19 days tracked',
            selectorOptions: const ['1M', '3M', '6M'],
            selectedIndex: _selectedIndex,
            onSelectorChanged: (i) => setState(() => _selectedIndex = i),
          ),
        ],
      ),
    );
  }
}
