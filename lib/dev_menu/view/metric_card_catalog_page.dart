import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';

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
  final _selected = <int>{4};

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
            const _SectionLabel('Plain'),
            MetricCard(
              label: 'Potential Savings',
              value: r'$94/mo',
              subtitle: 'vs benchmarks',
              isSelected: _selected.contains(0),
              onTap: () => _toggle(0),
            ),
            const _SectionLabel('Delta+ (positive)'),
            MetricCard(
              label: 'Negotiable',
              value: r'$645',
              delta: '+12%',
              deltaDirection: MetricDeltaDirection.positive,
              subtitle: 'vs last month',
              isSelected: _selected.contains(1),
              onTap: () => _toggle(1),
            ),
            const _SectionLabel('Delta- (negative)'),
            MetricCard(
              label: 'Fixed costs',
              value: r'$4,319',
              delta: r'$4,319',
              deltaDirection: MetricDeltaDirection.negative,
              subtitle: 'vs last month',
              isSelected: _selected.contains(2),
              onTap: () => _toggle(2),
            ),
            const _SectionLabel('Delta+Text'),
            MetricCard(
              label: 'Negotiable',
              value: r'$645',
              delta: '+12%',
              deltaDirection: MetricDeltaDirection.positive,
              subtitle: r'+$40 above 3mo avg',
              isSelected: _selected.contains(3),
              onTap: () => _toggle(3),
            ),
            const _SectionLabel('Selected'),
            MetricCard(
              label: 'Fixed costs',
              value: r'$4,319',
              delta: r'$4,319',
              deltaDirection: MetricDeltaDirection.negative,
              subtitle: 'vs last month',
              isSelected: _selected.contains(4),
              onTap: () => _toggle(4),
            ),
            const _SectionLabel('Responsive Layout'),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Spacing.xl,
        bottom: Spacing.xs,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
              letterSpacing: 0.8,
            ),
      ),
    );
  }
}
