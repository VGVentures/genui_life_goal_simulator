import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';

/// {@template horizontal_bar_catalog_page}
/// Catalog page showcasing all [HorizontalBar] variants.
/// {@endtemplate}
class HorizontalBarCatalogPage extends StatelessWidget {
  /// {@macro horizontal_bar_catalog_page}
  const HorizontalBarCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('HorizontalBar')),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.md),
        children: const [
          SizedBox(height: Spacing.xs),
          HorizontalBar(
            category: 'Dining',
            amount: r'$420',
            progress: 0.6,
            comparisonLabel: 'Groceries',
            comparisonValue: '-5%',
          ),
          SizedBox(height: Spacing.md),
          SizedBox(height: Spacing.xs),
          HorizontalBar(
            category: 'Dining',
            amount: r'$420',
            progress: 0.65,
            comparisonLabel: 'Groceries',
            comparisonValue: '+10%',
          ),
        ],
      ),
    );
  }
}
