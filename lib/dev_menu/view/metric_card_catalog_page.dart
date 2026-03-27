import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// {@template metric_card_catalog_page}
/// Catalog page showcasing all four [MetricCard] variants.
/// {@endtemplate}
class MetricCardCatalogPage extends StatelessWidget {
  /// {@macro metric_card_catalog_page}
  const MetricCardCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('MetricCard')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 800,
              child: MetricCardsLayout(
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
            ),
          ],
        ),
      ),
    );
  }
}
