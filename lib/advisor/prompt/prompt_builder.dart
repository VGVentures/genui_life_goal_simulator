import 'package:finance_app/onboarding/pick_profile/models/profile_type.dart';
import 'package:finance_app/onboarding/want_to_focus/models/focus_option.dart';

/// Composes prompts for the financial advisor LLM.
class PromptBuilder {
  const PromptBuilder();

  /// Builds the system prompt that defines the AI's persona and rules.
  static String buildSystemPrompt() {
    return '''
You are a knowledgeable, empathetic financial advisor providing personalized advice.

RULES:
1. Be encouraging but honest about financial concerns.
2. Tailor your tone to the person's experience level.
3. All monetary values are in USD.

WIDGET INSTRUCTIONS:
When populating the UserSummaryCard, ask the user for the information you need to populate the card, or provide reasonable example values and invite the user to correct them.
- totalAssets: Total value of depository + investment accounts.
- totalDebt: Total value of credit + loan balances owed.
- netWorth: totalAssets minus totalDebt.
- monthlyIncome: Estimated monthly income.
- monthlyExpenses: Estimated monthly expenses.
- financialHealthScore: Your overall assessment. Must be one of: Excellent, Good, Fair, Poor, Critical.
- recommendation: A concise, specific, actionable recommendation based on their profile and focus areas.

HorizontalBar — spending categories compared against a reference (e.g. last month, category average).
Use when the reference is a prior period or an external benchmark, not a fixed budget limit. All items must use the same type of reference.
- items: Array of objects (at least one), each with:
  - category: Category name (e.g. "Dining").
  - amount: Formatted spend string (e.g. "\$420").
  - progress: actual ÷ reference as a decimal (e.g. \$420 ÷ \$400 = 1.05). The bar clamps at 1.0 visually.
  - comparisonLabel: Short label for the reference row (e.g. "vs last month", "vs category avg").
  - comparisonValue: Signed % change vs the reference. Positive = spent more than reference → shown in red. Negative = spent less → shown in green. Always include the sign (e.g. "+5%", "-12%").

ProgressBar — spending categories vs. a fixed budget limit.
Use when the user has a defined budget per category and wants to see how much of each they have used. Color codes automatically: green < 65 %, orange 65–85 %, red > 85 %.
- items: Array of objects (at least one), each with:
  - title: Category name (e.g. "Dining").
  - value: Actual amount spent (numeric, e.g. 420).
  - total: Budget limit for that category (numeric, e.g. 400).
''';
  }

  /// Builds the initial user message from the user's onboarding selections.
  static String buildInitialUserMessage({
    required ProfileType profileType,
    Set<FocusOption> focusOptions = const {},
    String customOption = '',
  }) {
    final focusAreas = [
      for (final option in focusOptions) _focusLabel(option),
      if (customOption.isNotEmpty) customOption,
    ];

    final focusSection = focusAreas.isEmpty
        ? "I don't have specific focus areas yet."
        : 'I want to focus on:\n'
              '${focusAreas.map((a) => '- $a').join('\n')}';

    return '''
Hi! I'm ${_profileLabel(profileType)}. $focusSection

What advice do you have for me?
''';
  }

  static String _profileLabel(ProfileType type) {
    return switch (type) {
      ProfileType.beginner => 'new to financial planning',
      ProfileType.optimizer =>
        'experienced with finances and looking to optimize',
    };
  }

  static String _focusLabel(FocusOption option) {
    return switch (option) {
      FocusOption.everydaySpending => 'everyday spending',
      FocusOption.saveForRetirement => 'saving for retirement',
      FocusOption.mortgage => 'mortgage',
      FocusOption.housingAndFixedCosts => 'housing and fixed costs',
      FocusOption.healthcareAndInsurance => 'healthcare and insurance',
    };
  }
}
