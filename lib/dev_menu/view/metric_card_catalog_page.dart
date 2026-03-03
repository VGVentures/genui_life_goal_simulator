import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';

/// {@template metric_card_catalog_page}
/// Catalog page showcasing all five [MetricCard] variants.
/// {@endtemplate}
class MetricCardCatalogPage extends StatelessWidget {
  /// {@macro metric_card_catalog_page}
  const MetricCardCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(title: const Text('MetricCard')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionLabel('Plain'),
            MetricCard(
              label: 'Potential Savings',
              value: r'$94/mo',
              subtitle: 'vs benchmarks',
            ),
            _SectionLabel('Delta+ (positive)'),
            MetricCard(
              label: 'Negotiable',
              value: r'$645',
              delta: '+12%',
              deltaDirection: MetricDeltaDirection.positive,
              subtitle: 'vs last month',
            ),
            _SectionLabel('Delta- (negative)'),
            MetricCard(
              label: 'Fixed costs',
              value: r'$4,319',
              delta: r'$4,319',
              deltaDirection: MetricDeltaDirection.negative,
              subtitle: 'vs last month',
            ),
            _SectionLabel('Delta+Text'),
            MetricCard(
              label: 'Negotiable',
              value: r'$645',
              delta: '+12%',
              deltaDirection: MetricDeltaDirection.positive,
              subtitle: r'+$40 above 3mo avg',
            ),
            _SectionLabel('Selected'),
            MetricCard(
              label: 'Fixed costs',
              value: r'$4,319',
              delta: r'$4,319',
              deltaDirection: MetricDeltaDirection.negative,
              subtitle: 'vs last month',
              isSelected: true,
            ),
            _SectionLabel('Responsive Layout'),
            MetricCardLayout(
              cards: [
                MetricCard(
                  label: 'Fixed costs',
                  value: r'$4,319',
                  delta: r'$4,319',
                  deltaDirection: MetricDeltaDirection.negative,
                  subtitle: 'vs last month',
                ),
                MetricCard(
                  label: '% of income',
                  value: r'$45%',
                  delta: '+1.2%',
                  deltaDirection: MetricDeltaDirection.negative,
                  subtitle: 'benchmark 38%',
                ),
                MetricCard(
                  label: 'Negotiable',
                  value: r'$645',
                  delta: '+12%',
                  deltaDirection: MetricDeltaDirection.positive,
                  subtitle: r'+$40 above 3mo avg',
                ),
                MetricCard(
                  label: 'Potential Savings',
                  value: r'$94/mo',
                  subtitle: 'vs benchmarks',
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
