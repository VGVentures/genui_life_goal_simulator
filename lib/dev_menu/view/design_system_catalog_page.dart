import 'package:finance_app/dev_menu/view/metric_card_catalog_page.dart';
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
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(title: const Text('Design System')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('MetricCard'),
            subtitle: const Text('Key metric display with delta variants'),
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
