import 'package:flutter/material.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

/// {@template metric_card_catalog_page}
/// Catalog page showcasing all five [MetricCard] variants.
/// {@endtemplate}
class MetricCardCatalogPage extends StatefulWidget {
  /// {@macro metric_card_catalog_page}
  const MetricCardCatalogPage({super.key});

  @override
  State<MetricCardCatalogPage> createState() => _MetricCardCatalogPageState();
}

class _MetricCardCatalogPageState extends State<MetricCardCatalogPage> {
  final _selected = <int>{};

  void _toggle(int index) => setState(() {
    if (!_selected.remove(index)) _selected.add(index);
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('MetricCard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MetricCardsLayout(
              cards: [
                MetricCard(
                  label: 'Fixed costs',
                  value: r'$4,319',
                  delta: r'$4,319',
                  deltaDirection: MetricDeltaDirection.negative,
                  subtitle: 'vs last month',
                  isSelected: _selected.contains(5),
                  onTap: () => _toggle(5),
                ),
                MetricCard(
                  label: '% of income',
                  value: r'$45%',
                  delta: '+1.2%',
                  deltaDirection: MetricDeltaDirection.negative,
                  subtitle: 'benchmark 38%',
                  isSelected: _selected.contains(6),
                  onTap: () => _toggle(6),
                ),
                MetricCard(
                  label: 'Negotiable',
                  value: r'$645',
                  delta: '+12%',
                  deltaDirection: MetricDeltaDirection.positive,
                  subtitle: r'+$40 above 3mo avg',
                  isSelected: _selected.contains(7),
                  onTap: () => _toggle(7),
                ),
                MetricCard(
                  label: 'Potential Savings',
                  value: r'$94/mo',
                  subtitle: 'vs benchmarks',
                  isSelected: _selected.contains(8),
                  onTap: () => _toggle(8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
