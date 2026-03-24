import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// {@template header_selector_catalog_page}
/// Catalog page showcasing [HeaderSelector] variants.
/// {@endtemplate}
class HeaderSelectorCatalogPage extends StatefulWidget {
  /// {@macro header_selector_catalog_page}
  const HeaderSelectorCatalogPage({super.key});

  @override
  State<HeaderSelectorCatalogPage> createState() =>
      _HeaderSelectorCatalogPageState();
}

class _HeaderSelectorCatalogPageState extends State<HeaderSelectorCatalogPage> {
  int _horizontalIndex = 0;
  int _verticalIndex = 2;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
    return Scaffold(
      backgroundColor: colors?.surfaceVariant,
      appBar: AppBar(title: const Text('HeaderSelector')),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.md),
        children: [
          const Text(
            'Horizontal — 1M selected',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: Spacing.xs),
          HeaderSelector(
            options: const ['1M', '3M', '6M'],
            selectedIndex: _horizontalIndex,
            onChanged: (i) => setState(() => _horizontalIndex = i),
          ),
          const SizedBox(height: Spacing.xl),
          const Text(
            'Vertical (wrapped) — 6M selected',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: Spacing.xs),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 70,
              child: HeaderSelector(
                options: const ['1M', '3M', '6M'],
                selectedIndex: _verticalIndex,
                onChanged: (i) => setState(() => _verticalIndex = i),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
