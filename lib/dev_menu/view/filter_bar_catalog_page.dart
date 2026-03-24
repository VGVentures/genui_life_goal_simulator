import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// {@template filter_bar_catalog_page}
/// Catalog page showcasing [FilterBar] interactions.
/// {@endtemplate}
class FilterBarCatalogPage extends StatefulWidget {
  /// {@macro filter_bar_catalog_page}
  const FilterBarCatalogPage({super.key});

  @override
  State<FilterBarCatalogPage> createState() => _FilterBarCatalogPageState();
}

class _FilterBarCatalogPageState extends State<FilterBarCatalogPage> {
  late List<FilterCategory> _categories;

  @override
  void initState() {
    super.initState();
    _categories = _createCategories();
  }

  List<FilterCategory> _createCategories() {
    const categoryData = [
      (label: 'Category 1', color: FilterChipColor.mustard),
      (label: 'Category 1', color: FilterChipColor.lightBlue),
      (label: 'Category 1', color: FilterChipColor.brightOrange),
      (label: 'Category 1', color: FilterChipColor.lightOlive),
      (label: 'Category 1', color: FilterChipColor.aqua),
      (label: 'Category 1', color: FilterChipColor.emerald),
      (label: 'Category 1', color: FilterChipColor.darkOlive),
      (label: 'Category 1', color: FilterChipColor.deepRed),
      (label: 'Category 1', color: FilterChipColor.plum),
    ];

    return categoryData
        .map(
          (data) => FilterCategory(
            label: data.label,
            color: data.color,
          ),
        )
        .toList();
  }

  void _toggleCategory(int index) {
    setState(() {
      final category = _categories[index];
      _categories[index] = category.copyWith(isSelected: !category.isSelected);
    });
  }

  void _toggleAll() {
    setState(() {
      final allSelected = _categories.every((c) => c.isSelected);
      for (var i = 0; i < _categories.length; i++) {
        _categories[i] = _categories[i].copyWith(isSelected: !allSelected);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Filter Bar')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interactive',
              style: AppTextStyles.titleSmallDesktop,
            ),
            const SizedBox(height: Spacing.sm),
            Container(
              padding: const EdgeInsets.all(Spacing.md),
              child: FilterBar(
                categories: _categories,
                onCategoryToggled: _toggleCategory,
                onAllToggled: _toggleAll,
              ),
            ),
            const SizedBox(height: Spacing.xl),
            const Text(
              'Disabled All Chip',
              style: AppTextStyles.titleSmallDesktop,
            ),
            const SizedBox(height: Spacing.sm),
            Container(
              padding: const EdgeInsets.all(Spacing.md),
              child: FilterBar(
                categories: _categories,
                onCategoryToggled: _toggleCategory,
                onAllToggled: _toggleAll,
                isAllEnabled: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
