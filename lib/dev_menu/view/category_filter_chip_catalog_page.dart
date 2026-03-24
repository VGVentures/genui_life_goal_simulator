import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// {@template category_filter_chip_catalog_page}
/// Catalog page showcasing all [CategoryFilterChip] colors and states.
/// {@endtemplate}
class CategoryFilterChipCatalogPage extends StatefulWidget {
  /// {@macro category_filter_chip_catalog_page}
  const CategoryFilterChipCatalogPage({super.key});

  @override
  State<CategoryFilterChipCatalogPage> createState() =>
      _CategoryFilterChipCatalogPageState();
}

class _CategoryFilterChipCatalogPageState
    extends State<CategoryFilterChipCatalogPage> {
  final _selected = <FilterChipColor>{};

  void _toggle(FilterChipColor color) {
    setState(() {
      if (!_selected.remove(color)) {
        _selected.add(color);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Category Filter Chip')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interactive',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Wrap(
              spacing: Spacing.xs,
              runSpacing: Spacing.xs,
              children: FilterChipColor.values.map((color) {
                return CategoryFilterChip(
                  color: color,
                  label: 'Category 1',
                  isSelected: _selected.contains(color),
                  onTap: () => _toggle(color),
                );
              }).toList(),
            ),
            const SizedBox(height: Spacing.xl),
            const Text(
              'Disabled',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            const Wrap(
              spacing: Spacing.xs,
              runSpacing: Spacing.xs,
              children: [
                CategoryFilterChip(
                  color: FilterChipColor.pink,
                  label: 'Category 1',
                  isSelected: false,
                  isEnabled: false,
                ),
                CategoryFilterChip(
                  color: FilterChipColor.mustard,
                  label: 'Category 1',
                  isSelected: true,
                  isEnabled: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
