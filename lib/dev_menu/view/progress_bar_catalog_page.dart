import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';

/// {@template progress_bar_catalog_page}
/// Catalog page showcasing [ProgressBar] with all three threshold variants.
/// {@endtemplate}
class ProgressBarCatalogPage extends StatelessWidget {
  /// {@macro progress_bar_catalog_page}
  const ProgressBarCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('ProgressBar')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Error variant (> 85%)
            ProgressBar(
              title: 'Dining',
              value: 420,
              total: 400,
            ),
            SizedBox(height: Spacing.xl),
            // Warning variant (65–85%)
            ProgressBar(
              title: 'Groceries',
              value: 75,
              total: 100,
            ),
            SizedBox(height: Spacing.xl),
            // Success variant (< 65%)
            ProgressBar(
              title: 'Transport',
              value: 50,
              total: 100,
            ),
          ],
        ),
      ),
    );
  }
}
