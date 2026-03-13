import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:intl/intl.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _currencyFormat = NumberFormat.currency(symbol: r'$');

final _schema = S.object(
  description:
      "A structured summary card displaying the user's financial "
      'profile including net worth, assets, debt, cash flow, and a '
      'personalized recommendation.',
  properties: {
    'name': S.string(description: 'The persona display name.'),
    'financialHealthScore': S.string(
      description: 'Overall financial health assessment.',
      enumValues: ['Excellent', 'Good', 'Fair', 'Poor', 'Critical'],
    ),
    'totalAssets': S.number(
      description:
          'Sum of all depository and investment account balances in USD.',
    ),
    'totalDebt': S.number(
      description:
          'Sum of all credit card balances and loan balances owed in USD.',
    ),
    'netWorth': S.number(
      description: 'totalAssets minus totalDebt in USD.',
    ),
    'monthlyIncome': S.number(
      description:
          'Total income for the most recent full month (January 2026) in USD.',
    ),
    'monthlyExpenses': S.number(
      description:
          'Total non-transfer spending for the most recent full month '
          '(January 2026) in USD.',
    ),
    'recommendation': S.string(
      description:
          'A concise, personalized 1-2 sentence financial recommendation.',
    ),
  },
  required: [
    'name',
    'financialHealthScore',
    'totalAssets',
    'totalDebt',
    'netWorth',
    'monthlyIncome',
    'monthlyExpenses',
    'recommendation',
  ],
);

/// CatalogItem that renders a structured financial summary card.
final userSummaryCardItem = CatalogItem(
  name: 'UserSummaryCard',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final context = ctx.buildContext;

    final name = json['name']! as String;
    final healthScore = json['financialHealthScore']! as String;
    final totalAssets = (json['totalAssets']! as num).toDouble();
    final totalDebt = (json['totalDebt']! as num).toDouble();
    final netWorth = (json['netWorth']! as num).toDouble();
    final monthlyIncome = (json['monthlyIncome']! as num).toDouble();
    final monthlyExpenses = (json['monthlyExpenses']! as num).toDouble();
    final recommendation = json['recommendation']! as String;

    final theme = Theme.of(context);
    final colorExtension = theme.extension<AppColors>();
    final healthColor = _healthColor(healthScore);
    final netWorthColor = netWorth >= 0
        ? colorExtension?.success
        : colorExtension?.error;

    return Card(
      elevation: Spacing.xxs,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: Spacing.sm,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.person, color: theme.colorScheme.primary),
                const SizedBox(width: Spacing.xs),
                Expanded(
                  child: Text(
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorExtension?.onSurface,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: healthColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(Spacing.md),
                    border: Border.all(color: healthColor),
                  ),
                  child: Text(
                    healthScore,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: healthColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              height: 2,
              color: colorExtension?.onSurface,
            ),
            // Net Worth
            Text(
              'Net Worth',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorExtension?.onSurface,
              ),
            ),
            Text(
              _currencyFormat.format(netWorth),
              style: theme.textTheme.titleLarge?.copyWith(
                color: netWorthColor,
              ),
            ),
            Row(
              children: [
                Text(
                  'Assets: ${_currencyFormat.format(totalAssets)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorExtension?.onSurface,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Text(
                  'Debt: ${_currencyFormat.format(totalDebt)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorExtension?.onSurface,
                  ),
                ),
              ],
            ),
            Divider(
              height: 2,
              color: colorExtension?.onSurface,
            ),
            // Monthly Cash Flow
            Text(
              'Monthly Cash Flow (Jan 2026)',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorExtension?.onSurface,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Income: ${_currencyFormat.format(monthlyIncome)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorExtension?.onSurface,
                    ),
                  ),
                ),
                Text(
                  'Expenses: ${_currencyFormat.format(monthlyExpenses)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorExtension?.onSurface,
                  ),
                ),
              ],
            ),
            Divider(
              height: 2,
              color: colorExtension?.onSurface,
            ),
            // Recommendation
            Text(
              recommendation,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorExtension?.onSurface,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  },
);

Color _healthColor(String score) {
  return switch (score) {
    'Excellent' => Colors.green,
    'Good' => Colors.lightGreen,
    'Fair' => Colors.orange,
    'Poor' => Colors.deepOrange,
    'Critical' => Colors.red,
    _ => Colors.grey,
  };
}
