import 'package:finance_app/app/presentation/app_colors.dart';
import 'package:finance_app/app/presentation/app_text_styles.dart';
import 'package:finance_app/app/presentation/spacing.dart';
import 'package:finance_app/app/presentation/widgets/category_filter_chip.dart';
import 'package:flutter/material.dart';

/// A model representing a filter category.
class FilterCategory {
  const FilterCategory({
    required this.label,
    required this.color,
    this.isSelected = false,
    this.isEnabled = true,
  });

  final String label;
  final FilterChipColor color;
  final bool isSelected;
  final bool isEnabled;

  FilterCategory copyWith({bool? isSelected, bool? isEnabled}) {
    return FilterCategory(
      label: label,
      color: color,
      isSelected: isSelected ?? this.isSelected,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

/// A filter bar molecule component for filtering data views.
///
/// Displays an "All" toggle chip followed by a collection of category filter
/// chips arranged in a wrapped layout. Shows a summary of selected categories
/// below the chips.
class FilterBar extends StatelessWidget {
  const FilterBar({
    required this.categories,
    required this.onCategoryToggled,
    required this.onAllToggled,
    this.allChipColor = FilterChipColor.pink,
    this.allLabel = 'All',
    this.isAllEnabled = true,
    super.key,
  });

  /// The list of filter categories to display.
  final List<FilterCategory> categories;

  /// Called when a category chip is toggled.
  /// Receives the index of the toggled category.
  final ValueChanged<int> onCategoryToggled;

  /// Called when the "All" chip is toggled.
  final VoidCallback onAllToggled;

  /// The color for the "All" chip.
  final FilterChipColor allChipColor;

  /// The label for the "All" chip.
  final String allLabel;

  /// Whether the "All" chip is enabled.
  final bool isAllEnabled;

  int get _selectedCount => categories.where((c) => c.isSelected).length;

  bool get _allSelected =>
      categories.isNotEmpty && categories.every((c) => c.isSelected);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildChipsSection(),
          const SizedBox(height: Spacing.md),
          Text(
            '$_selectedCount of ${categories.length} categories selected',
            style: AppTextStyles.bodyMediumDesktop.copyWith(
              color: colors?.onSurfaceMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipsSection() {
    return Wrap(
      spacing: Spacing.xs,
      runSpacing: Spacing.xs,
      children: [
        CategoryFilterChip(
          color: allChipColor,
          label: allLabel,
          isSelected: _allSelected,
          isEnabled: isAllEnabled,
          onTap: onAllToggled,
        ),
        for (var i = 0; i < categories.length; i++)
          CategoryFilterChip(
            color: categories[i].color,
            label: categories[i].label,
            isSelected: categories[i].isSelected,
            isEnabled: categories[i].isEnabled,
            onTap: () => onCategoryToggled(i),
          ),
      ],
    );
  }
}
