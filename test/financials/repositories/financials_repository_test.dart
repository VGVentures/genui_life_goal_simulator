import 'package:finance_app/financials/mock/older_stable.dart';
import 'package:finance_app/financials/mock/older_struggling.dart';
import 'package:finance_app/financials/mock/young_reckless.dart';
import 'package:finance_app/financials/mock/young_responsible.dart';
import 'package:finance_app/financials/models/persona_type_enum.dart';
import 'package:finance_app/financials/repositories/financials_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FinancialsRepository repository;

  setUp(() {
    repository = FinancialsRepository();
  });

  group('getFinancialData', () {
    test('returns correct data for youngReckless', () {
      final result = repository.getFinancialData(PersonaTypeEnum.youngReckless);

      expect(result.personaType, PersonaTypeEnum.youngReckless);
      expect(result.description, youngRecklessScenario.description);
      expect(result.accounts, youngRecklessScenario.accounts);
      expect(result.transactions, youngRecklessScenario.transactions);
    });

    test('returns correct data for youngResponsible', () {
      final result = repository.getFinancialData(
        PersonaTypeEnum.youngResponsible,
      );

      expect(result.personaType, PersonaTypeEnum.youngResponsible);
      expect(result.description, youngResponsibleScenario.description);
      expect(result.accounts, youngResponsibleScenario.accounts);
      expect(result.transactions, youngResponsibleScenario.transactions);
    });

    test('returns correct data for olderStable', () {
      final result = repository.getFinancialData(PersonaTypeEnum.olderStable);

      expect(result.personaType, PersonaTypeEnum.olderStable);
      expect(result.description, olderStableScenario.description);
      expect(result.accounts, olderStableScenario.accounts);
      expect(result.transactions, olderStableScenario.transactions);
    });

    test('returns correct data for olderStruggling', () {
      final result = repository.getFinancialData(
        PersonaTypeEnum.olderStruggling,
      );

      expect(result.personaType, PersonaTypeEnum.olderStruggling);
      expect(result.description, olderStrugglingScenario.description);
      expect(result.accounts, olderStrugglingScenario.accounts);
      expect(result.transactions, olderStrugglingScenario.transactions);
    });

    test('all persona types return unique data when calling the method', () {
      final results = PersonaTypeEnum.values
          .map(repository.getFinancialData)
          .toList();

      final descriptions = results.map((r) => r.description).toSet();
      expect(descriptions.length, PersonaTypeEnum.values.length);
    });
  });
}
