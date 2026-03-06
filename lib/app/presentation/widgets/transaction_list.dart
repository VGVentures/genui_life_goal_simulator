import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Data for a single row in a [TransactionList].
class TransactionListItem {
  /// Creates a [TransactionListItem].
  const TransactionListItem({
    required this.title,
    required this.description,
    required this.amount,
    this.onViewDetails,
  });

  /// The transaction name (e.g. "Nobu Restaurant").
  final String title;

  /// The transaction category (e.g. "Dining").
  final String description;

  /// Formatted amount string (e.g. "\$450").
  final String amount;

  /// Optional callback to view transaction details.
  ///
  /// When provided, a "View" button is displayed at the trailing end of the
  /// row.
  final VoidCallback? onViewDetails;
}

/// {@template transaction_list}
/// A list that displays [TransactionListItem]s with their title, description,
/// amount, and an optional "View" button for transaction details.
/// {@endtemplate}
class TransactionList extends StatelessWidget {
  /// {@macro transaction_list}
  const TransactionList({
    required this.items,
    super.key,
  });

  /// The transactions to display.
  final List<TransactionListItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: Spacing.md,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _TransactionListRow(
            item: items[i],
            colors: colors,
            textTheme: textTheme,
          ),
          if (i < items.length)
            Divider(
              height: 1,
              color: colors?.outlineVariant,
            ),
        ],
      ],
    );
  }
}

class _TransactionListRow extends StatelessWidget {
  const _TransactionListRow({
    required this.item,
    required this.colors,
    required this.textTheme,
  });

  final TransactionListItem item;
  final AppColors? colors;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.only(
        top: Spacing.lg,
      ),
      child: Row(
        spacing: Spacing.md,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: textTheme.titleSmall?.copyWith(
                    color: colors?.onSurface,
                  ),
                ),
                Text(
                  item.description,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors?.onSurfaceMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            item.amount,
            style: textTheme.bodyLarge?.copyWith(
              color: colors?.onSurface,
            ),
          ),
          if (item.onViewDetails != null) ...[
            // TODO(juanRodriguez17): Replace with custom button widget
            //when gets merged
            FilledButton(
              onPressed: item.onViewDetails,
              style: FilledButton.styleFrom(
                backgroundColor: colors?.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                ),
              ),
              child: Text(
                l10n.viewLabel,
                style: textTheme.labelLarge?.copyWith(
                  color: colors?.onInverseSurface,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
