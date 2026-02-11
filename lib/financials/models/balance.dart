/// {@template currency_code}
/// ISO 4217 currency codes.
/// {@endtemplate}
enum CurrencyCode {
  /// United States Dollar.
  usd,

  /// Euro.
  eur,

  /// British Pound Sterling.
  gbp,
}

/// {@template balance}
/// Represents the balance information for a financial account.
/// {@endtemplate}
class Balance {
  /// {@macro balance}
  const Balance({
    required this.current,
    required this.currencyCode,
    this.available,
    this.limit,
  });

  /// The total amount of funds in the account, or total amount owed
  /// for credit/loan accounts.
  final double current;

  /// The amount of funds available for spending or withdrawal.
  /// For depository accounts: current minus pending debits.
  /// Null for credit/loan accounts.
  final double? available;

  /// The credit limit. Only applicable to credit accounts.
  final double? limit;

  /// ISO 4217 currency code.
  final CurrencyCode currencyCode;
}
