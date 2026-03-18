import 'package:flutter/material.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

/// {@template pie_chart_catalog_page}
/// A dev-menu page that showcases the [PieChartComponent] widget
/// with sample data.
/// {@endtemplate}
class PieChartCatalogPage extends StatelessWidget {
  /// {@macro pie_chart_catalog_page}

  const PieChartCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();

    final items = [
      PieChartItem(
        label: 'Groceries',
        value: 1420,
        amount: r'$1,420',
        color: colors?.pinkColor,
      ),
      PieChartItem(
        label: 'Shopping',
        value: 1420,
        amount: r'$1,420',
        color: colors?.mustardColor,
      ),
      PieChartItem(
        label: 'Dining Out',
        value: 1420,
        amount: r'$1,420',
        color: colors?.orangeColor,
      ),
      PieChartItem(
        label: 'Transport',
        value: 1420,
        amount: r'$1,420',
        color: colors?.plumColor,
      ),
      PieChartItem(
        label: 'Travel',
        value: 1420,
        amount: r'$1,420',
        color: colors?.lightBlueColor,
      ),
    ];

    return Scaffold(
      backgroundColor: colors?.surfaceVariant,
      appBar: AppBar(title: const Text('Pie Chart')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.xxxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Spacing.xxxl,
          children: [
            PieChartComponent(
              items: items,
              totalLabel: 'Total',
              totalAmount: r'$4,225',
            ),
            PieChartComponent(
              items: items,
              totalLabel: 'Total',
              totalAmount: r'$4,225',
              selectedIndex: 0,
            ),
          ],
        ),
      ),
    );
  }
}
