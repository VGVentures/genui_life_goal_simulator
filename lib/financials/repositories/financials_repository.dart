import 'package:finance_app/financials/mock/mock_scenario.dart';
import 'package:finance_app/financials/mock/older_stable.dart';
import 'package:finance_app/financials/mock/older_struggling.dart';
import 'package:finance_app/financials/mock/young_reckless.dart';
import 'package:finance_app/financials/mock/young_responsible.dart';
import 'package:finance_app/financials/models/persona_type_enum.dart';
import 'package:finance_app/financials/repositories/models/financial_result.dart';

/// Repository for accessing financial data.
///
/// Provides methods to retrieve mock financial data for different personas.
/// Can be injected into Blocs/Cubits for dependency injection and testing.
class FinancialsRepository {
  /// Maps each persona type to its mock data scenario.
  static final Map<PersonaTypeEnum, MockScenario> _personasWithScenarios = {
    PersonaTypeEnum.youngReckless: youngRecklessScenario,
    PersonaTypeEnum.youngResponsible: youngResponsibleScenario,
    PersonaTypeEnum.olderStable: olderStableScenario,
    PersonaTypeEnum.olderStruggling: olderStrugglingScenario,
  };

  /// Returns a [FinancialResult] with all accounts and transactions
  /// for the given [PersonaTypeEnum].
  FinancialResult getFinancialData(PersonaTypeEnum type) {
    final scenario = _personasWithScenarios[type]!;
    return FinancialResult(
      personaType: type,
      description: scenario.description,
      accounts: scenario.accounts,
      transactions: scenario.transactions,
    );
  }
}
