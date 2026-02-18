import 'package:finance_app/financials/models/account.dart';
import 'package:finance_app/financials/models/persona_type_enum.dart';
import 'package:finance_app/financials/models/transaction.dart';

/// Contains complete financial data for a persona.
///
/// Returned by `getFinancialData()` and includes all accounts
/// and transactions for the selected [PersonaTypeEnum].
class FinancialResult {
  const FinancialResult({
    required this.personaType,
    required this.description,
    required this.accounts,
    required this.transactions,
  });
  final PersonaTypeEnum personaType;
  final String description;
  final List<Account> accounts;
  final List<Transaction> transactions;
}
