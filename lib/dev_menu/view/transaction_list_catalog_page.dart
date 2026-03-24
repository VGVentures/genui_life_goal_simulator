import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// A dev-menu page that showcases the [TransactionList] widget with sample
/// data.
class TransactionListCatalogPage extends StatelessWidget {
  /// Creates a [TransactionListCatalogPage].
  const TransactionListCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction List')),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: Spacing.xxxl,
          vertical: Spacing.xxxl,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors?.onPrimary,
            borderRadius: BorderRadius.circular(Spacing.xxxl),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.xxxl),
            child: TransactionList(
              items: [
                const TransactionListItem(
                  title: 'Nobu Restaurant',
                  description: 'Dining',
                  amount: r'$450',
                ),
                TransactionListItem(
                  title: 'Nobu Restaurant',
                  description: 'Dining',
                  amount: r'$450',
                  onViewDetails: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
