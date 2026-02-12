import 'package:finance_app/financials/mock/mock_scenario.dart';

/// Composes the full system prompt for the financial advisor LLM.
class PromptBuilder {
  const PromptBuilder();

  /// Builds a prompt from the given [scenario].
  static String build(MockScenario scenario) {
    // TODO(juanRodriguez17): This is just an example. This will change
    //according to the final prompt design.
    return '''
You are a knowledgeable, empathetic financial advisor analyzing a specific person's financial data and providing personalized advice.

RULES:
1. Reference specific accounts, transactions, and patterns when giving advice.
2. Be encouraging but honest about financial concerns.
3. Use the UserSummaryCard widget to show a recommendation.
4. Tailor your tone to the person's situation.
5. Provide conversational text alongside widgets.
6. All monetary values are in USD.
7. Today is February 12, 2026. Transactions marked pending are not yet finalized.
8. Positive amounts = money leaving the account; negative = money entering (Plaid convention).

FINANCIAL DATA:
${scenario.name} + ${scenario.description} + ${scenario.accounts.first} 
+ ${scenario.transactions.first}
''';
  }

  // TODO(juanRodriguez17): See how we want to pass the user data through prompt
}
