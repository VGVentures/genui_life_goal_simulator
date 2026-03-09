import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';

/// {@template ranked_table_page}
/// A dev-menu page that showcases the [RankedTable] widget with sample data.
/// {@endtemplate}
class RankedTablePage extends StatelessWidget {
  /// {@macro ranked_table_page}
  const RankedTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();

    return Scaffold(
      appBar: AppBar(title: const Text('Ranked Table')),
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
          child: const Padding(
            padding: EdgeInsets.all(Spacing.xxxl),
            child: RankedTable(
              items: [
                RankedTableItem(
                  title: 'The French Laundry',
                  amount: r'$350',
                  delta: '+15%',
                ),
                RankedTableItem(
                  title: 'Osteria Francescana',
                  amount: r'$310',
                  delta: '-10%',
                ),
                RankedTableItem(
                  title: 'Alinea',
                  amount: r'$300',
                  delta: '+30%',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
