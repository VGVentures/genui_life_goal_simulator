import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// {@template insight_card_catalog_page}
/// Catalog page showcasing all four [InsightCard] variants.
/// {@endtemplate}
class InsightCardCatalogPage extends StatelessWidget {
  /// {@macro insight_card_catalog_page}
  const InsightCardCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('InsightCard')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InsightCard(
              title: 'Neutral insight',
              description:
                  'You have reviewed all your recurring subscriptions'
                  ' this month.',
            ),
            SizedBox(height: Spacing.md),
            InsightCard(
              title: "You're on track",
              description:
                  'Your savings rate is 22%, above the recommended'
                  ' 20% benchmark.',
              variant: InsightCardVariant.success,
            ),
            SizedBox(height: Spacing.md),
            InsightCard(
              title: 'Spending spike',
              description:
                  'Dining out is 34% higher than your 3-month average.'
                  ' Consider adjusting.',
              variant: InsightCardVariant.warning,
            ),
            SizedBox(height: Spacing.md),
            InsightCard(
              title: 'Over budget',
              description:
                  'You have exceeded your monthly entertainment'
                  r' budget by $120.',
              variant: InsightCardVariant.error,
            ),
          ],
        ),
      ),
    );
  }
}
