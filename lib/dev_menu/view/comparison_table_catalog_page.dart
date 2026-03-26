import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// {@template comparison_table_catalog_page}
/// A dev-menu page that showcases the [ComparisonTable] widget with sample
/// data.
/// {@endtemplate}
class ComparisonTableCatalogPage extends StatelessWidget {
  /// {@macro comparison_table_catalog_page}
  const ComparisonTableCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();

    return Scaffold(
      appBar: AppBar(title: const Text('Comparison Table')),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: Spacing.xxxl,
            vertical: Spacing.xxxl,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors?.onPrimary,
              borderRadius: BorderRadius.circular(Spacing.xxxl),
            ),
            child: const Padding(
              padding: EdgeInsets.all(Spacing.xxxl),
              child: ComparisonTable(
                items: [
                  ComparisonTableItem(
                    label: 'Groceries',
                    lastMonthAmount: 300,
                    actualMonthAmount: 315,
                  ),
                  ComparisonTableItem(
                    label: 'Dining',
                    lastMonthAmount: 190,
                    actualMonthAmount: 140,
                  ),
                  ComparisonTableItem(
                    label: 'Groceries',
                    lastMonthAmount: 300,
                    actualMonthAmount: 315,
                  ),
                  ComparisonTableItem(
                    label: 'Dining',
                    lastMonthAmount: 190,
                    actualMonthAmount: 140,
                  ),
                  ComparisonTableItem(
                    label: 'Grocery Spending',
                    lastMonthAmount: 300,
                    actualMonthAmount: 315,
                  ),
                  ComparisonTableItem(
                    label: 'Total Debt Surplus',
                    lastMonthAmount: 190,
                    actualMonthAmount: 140,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
