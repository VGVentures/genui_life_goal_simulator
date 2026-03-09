import 'package:finance_app/onboarding/pick_profile/models/profile_type.dart';
import 'package:finance_app/onboarding/want_to_focus/models/focus_option.dart';

/// Composes the full system prompt for the financial advisor LLM.
class PromptBuilder {
  const PromptBuilder();

  /// Builds a prompt from the user's onboarding selections.
  static String build({
    required ProfileType profileType,
    Set<FocusOption> focusOptions = const {},
    String customOption = '',
  }) {
    final focusAreas = [
      for (final option in focusOptions) _focusLabel(option),
      if (customOption.isNotEmpty) customOption,
    ];

    final focusSection = focusAreas.isEmpty
        ? 'No specific focus areas selected.'
        : focusAreas.map((a) => '- $a').join('\n');

    return '''
You are a knowledgeable, empathetic financial advisor providing personalized advice.

RULES:
1. Be encouraging but honest about financial concerns.
2. Tailor your tone to the person's experience level.
3. All monetary values are in USD.

USER PROFILE:
Experience level: ${_profileLabel(profileType)}

FOCUS AREAS:
$focusSection

WIDGET INSTRUCTIONS:
When populating the UserSummaryCard, ask the user for the information you need to populate the card, or provide reasonable example values and invite the user to correct them.
- totalAssets: Total value of depository + investment accounts.
- totalDebt: Total value of credit + loan balances owed.
- netWorth: totalAssets minus totalDebt.
- monthlyIncome: Estimated monthly income.
- monthlyExpenses: Estimated monthly expenses.
- financialHealthScore: Your overall assessment. Must be one of: Excellent, Good, Fair, Poor, Critical.
- recommendation: A concise, specific, actionable recommendation based on their profile and focus areas.
''';
  }

  static String _profileLabel(ProfileType type) {
    return switch (type) {
      ProfileType.beginner => 'Beginner - new to financial planning',
      ProfileType.optimizer =>
        'Optimizer - experienced and looking to fine-tune',
    };
  }

  static String _focusLabel(FocusOption option) {
    return switch (option) {
      FocusOption.everydaySpending => 'Everyday spending',
      FocusOption.saveForRetirement => 'Saving for retirement',
      FocusOption.mortgage => 'Mortgage',
      FocusOption.housingAndFixedCosts => 'Housing and fixed costs',
      FocusOption.healthcareAndInsurance => 'Healthcare and insurance',
    };
  }
}
