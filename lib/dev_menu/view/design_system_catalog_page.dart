import 'package:finance_app/app/presentation/app_colors.dart';
import 'package:finance_app/dev_menu/dev_menu.dart';
import 'package:flutter/material.dart';

/// {@template design_system_catalog_page}
/// Index screen listing all design system components available for preview.
///
/// Accessible from the Dev Menu drawer. Each entry navigates to a dedicated
/// catalog page for that component.
/// {@endtemplate}
class DesignSystemCatalogPage extends StatelessWidget {
  /// {@macro design_system_catalog_page}
  const DesignSystemCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors?.onPrimary,
      appBar: AppBar(title: const Text('Design System')),
      body: ListView(
        children: [
          ListTile(
            title: const Text(
              'ActionItem',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: const Text(
              'Task/recommendation row with primary, secondary, and no-button variants',
              style: TextStyle(color: Colors.black),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ActionItemCatalogPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'AiButton',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: const Text(
              'AI suggestion button with gradient border',
              style: TextStyle(color: Colors.black),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const AiButtonCatalogPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'AppButton',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: const Text(
              'Filled and outlined button variants with two sizes',
              style: TextStyle(color: Colors.black),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const AppButtonCatalogPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'CategoryFilterChip',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: const Text(
              'Color category filter chips',
              style: TextStyle(color: Colors.black),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const CategoryFilterChipCatalogPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'Accordion',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: const Text(
              'Expandable content panel with collapsed and open states',
              style: TextStyle(color: Colors.black),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const AccordionCatalogPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'EmojiCard',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: const Text(
              'Category card with emoji and label',
              style: TextStyle(color: Colors.black),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const EmojiCardCatalogPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'FilterBar',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: const Text(
              'Filter bar with category chips and All toggle',
              style: TextStyle(color: Colors.black),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const FilterBarCatalogPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'ProgressBar',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: const Text(
              'Threshold-based color-coded progress bar',
              style: TextStyle(color: Colors.black),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ProgressBarCatalogPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'HeaderSelector',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: const Text(
              'Pill-shaped chip group for selecting time periods',
              style: TextStyle(color: Colors.black),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const HeaderSelectorCatalogPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'HorizontalBar',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: const Text(
              'Pill-shaped chip group for selecting time periods',
              style: TextStyle(color: Colors.black),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const HorizontalBarCatalogPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'MetricCard',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: const Text(
              'Key metric display with delta variants',
              style: TextStyle(color: Colors.black),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const MetricCardCatalogPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'RadioCard',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: const Text(
              'Selectable card with radio indicator',
              style: TextStyle(color: Colors.black),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const RadioCardCatalogPage(),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Ranked Table',
              style: textTheme.titleSmall,
            ),
            subtitle: Text(
              'Ranked Table for different items with delta variants',
              style: textTheme.bodyMedium,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const RankedTablePage(),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'LineChart',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: const Text(
              'Line chart with tooltip on data point tap',
              style: TextStyle(color: Colors.black),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const LineChartCatalogPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'SectionHeader',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: const Text(
              'Section label with optional subtitle and selector',
              style: TextStyle(color: Colors.black),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const SectionHeaderCatalogPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'Transaction List',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: const Text(
              'Transaction rows with optional View button',
              style: TextStyle(color: Colors.black),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const TransactionListCatalogPage(),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Pie Chart',
              style: textTheme.titleSmall,
            ),
            subtitle: Text(
              'Interactive donut chart with legend',
              style: textTheme.bodyMedium,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const PieChartCatalogPage(),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Comparison Table',
              style: textTheme.titleSmall,
            ),
            subtitle: Text(
              'Monthly spending comparison with calculated delta',
              style: textTheme.bodyMedium,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ComparisonTableCatalogPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
