import 'package:finance_app/financials/mock/mock_scenario.dart';
import 'package:finance_app/financials/models/models.dart';

/// Composes the full system prompt for the financial advisor LLM.
class PromptBuilder {
  const PromptBuilder();

  /// Builds a prompt from the given [scenario].
  static String build(MockScenario scenario) {
    final accounts = _formatAccounts(scenario.accounts);
    final transactions = _formatTransactions(
      scenario.transactions,
      scenario.accounts,
    );

    return '''
You are a knowledgeable, empathetic financial advisor analyzing a specific person's financial data and providing personalized advice.

RULES:
1. Reference specific accounts, transactions, and patterns when giving advice.
2. Be encouraging but honest about financial concerns.
3. You MUST use the UserSummaryCard widget in your FIRST response to show a financial overview.
4. Tailor your tone to the person's situation.
5. All monetary values are in USD.
6. Today is February 12, 2026. Transactions marked pending are not yet finalized.
7. Positive amounts = money leaving the account (spending); negative = money entering (income, refunds).

PERSONA:
Name: ${scenario.name}
Description: ${scenario.description}

ACCOUNTS:
$accounts

TRANSACTIONS (Dec 1, 2025 - Feb 5, 2026):
$transactions

WIDGET INSTRUCTIONS:
When populating the UserSummaryCard, calculate the following from the data above:
- totalAssets: Sum of current balances for depository + investment accounts.
- totalDebt: Sum of current balances for credit + loan accounts (these represent amounts owed).
- netWorth: totalAssets minus totalDebt.
- monthlyIncome: Sum of all negative-amount (income) transactions in January 2026.
- monthlyExpenses: Sum of all positive-amount non-transfer transactions in January 2026.
- financialHealthScore: Your overall assessment based on all the data. Must be one of: Excellent, Good, Fair, Poor, Critical.
- recommendation: A concise, specific, actionable recommendation referencing their actual data.
''';
  }

  static String _formatAccounts(List<Account> accounts) {
    final buffer = StringBuffer();
    for (final account in accounts) {
      buffer
        ..writeln('- ${account.name} (****${account.mask})')
        ..writeln(
          '  Type: ${account.type.name} / ${account.subtype.name}',
        )
        ..writeln(
          '  Current Balance: '
          '\$${account.balance.current.toStringAsFixed(2)}',
        );
      if (account.balance.available != null) {
        buffer.writeln(
          '  Available: '
          '\$${account.balance.available!.toStringAsFixed(2)}',
        );
      }
      if (account.balance.limit != null) {
        buffer.writeln(
          '  Credit Limit: '
          '\$${account.balance.limit!.toStringAsFixed(2)}',
        );
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String _formatTransactions(
    List<Transaction> transactions,
    List<Account> accounts,
  ) {
    final accountNames = {
      for (final a in accounts) a.id: '${a.name} (****${a.mask})',
    };

    final buffer = StringBuffer();
    for (final txn in transactions) {
      final sign = txn.amount >= 0 ? '+' : '';
      final pending = txn.pending ? ' [PENDING]' : '';
      final merchant = txn.merchantName != null ? ' (${txn.merchantName})' : '';
      final date =
          '${txn.date.year}-'
          '${txn.date.month.toString().padLeft(2, '0')}-'
          '${txn.date.day.toString().padLeft(2, '0')}';
      buffer.writeln(
        '- $date | '
        '$sign\$${txn.amount.toStringAsFixed(2)} | '
        '${txn.name}$merchant | '
        '${txn.category.name} | '
        '${accountNames[txn.accountId] ?? txn.accountId}'
        '$pending',
      );
    }
    return buffer.toString();
  }
}
