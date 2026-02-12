import 'package:finance_app/financials/models/balance.dart';

/// {@template account_type}
/// Top-level account type classification, based on Plaid's taxonomy.
/// {@endtemplate}
enum AccountType {
  /// Checking and savings accounts.
  depository,

  /// Credit cards.
  credit,

  /// Loans (mortgage, auto, student, personal).
  loan,

  /// Investment and retirement accounts.
  investment,
}

/// {@template account_subtype}
/// Detailed account subtype classification.
/// {@endtemplate}
enum AccountSubtype {
  /// Standard checking account.
  checking,

  /// Savings account.
  savings,

  /// Credit card.
  creditCard,

  /// Home mortgage.
  mortgage,

  /// Student loan.
  studentLoan,

  /// Auto loan.
  autoLoan,

  /// Personal loan.
  personalLoan,

  /// 401(k) retirement account.
  fourOhOneK,

  /// Brokerage / taxable investment account.
  brokerage,

  /// Roth IRA.
  roth,
}

/// {@template account}
/// Represents a financial account (bank, credit, loan, or investment).
/// {@endtemplate}
class Account {
  /// {@macro account}
  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.subtype,
    required this.mask,
    required this.balance,
  });

  /// Unique identifier for this account.
  final String id;

  /// Display name (e.g. "Chase Total Checking").
  final String name;

  /// Top-level account classification.
  final AccountType type;

  /// Detailed account classification.
  final AccountSubtype subtype;

  /// Last 4 digits of the account number.
  final String mask;

  /// Current balance information.
  final Balance balance;
}
