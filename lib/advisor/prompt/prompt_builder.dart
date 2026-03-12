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
Use CategoryFilterChip to display a toggleable filter chip for category selection (e.g. spending categories or tags). Each chip requires a label and a color. Set isSelected to true to show the chip in its selected state. Set isEnabled to false to render it in a disabled/muted state.

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
