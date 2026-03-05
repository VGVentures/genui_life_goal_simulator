import 'package:finance_app/dev_menu/view/ai_button_catalog_page.dart';
import 'package:finance_app/dev_menu/view/category_filter_chip_catalog_page.dart';
import 'package:finance_app/dev_menu/view/emoji_card_catalog_page.dart';
import 'package:finance_app/dev_menu/view/header_selector_catalog_page.dart';
import 'package:finance_app/dev_menu/view/horizontal_bar_catalog_page.dart';
import 'package:finance_app/dev_menu/view/metric_card_catalog_page.dart';
import 'package:finance_app/dev_menu/view/progress_bar_catalog_page.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Design System')),
      body: ListView(
        children: [
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
              'HorizontalBar',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: const Text(
              'Horizontal bar chart for comparisons',
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
        ],
      ),
    );
  }
}
