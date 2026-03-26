import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/onboarding/pick_profile/models/profile_type.dart';
import 'package:genui_life_goal_simulator/onboarding/want_to_focus/models/focus_option.dart';
import 'package:genui_life_goal_simulator/simulator/prompt/prompt.dart';

void main() {
  group('PromptBuilder', () {
    group('buildSystemPrompt', () {
      test('returns non-empty string', () {
        final prompt = PromptBuilder.buildSystemPrompt();
        expect(prompt, isNotEmpty);
      });

      test('contains key sections', () {
        final prompt = PromptBuilder.buildSystemPrompt();
        expect(prompt, contains('Conversation Flow'));
        expect(prompt, contains('Summary Screen'));
        expect(prompt, contains('Interactive Widgets'));
        expect(prompt, contains('Screen Layout Containers'));
        expect(prompt, contains('Data Model Bindings'));
        expect(prompt, contains('Rules'));
      });
    });

    group('buildInitialUserMessage', () {
      test('with beginner profile', () {
        final message = PromptBuilder.buildInitialUserMessage(
          profileType: ProfileType.beginner,
        );
        expect(message, contains('new to financial planning'));
      });

      test('with optimizer profile', () {
        final message = PromptBuilder.buildInitialUserMessage(
          profileType: ProfileType.optimizer,
        );
        expect(message, contains('experienced with finances'));
        expect(message, contains('looking to optimize'));
      });

      test('with focus options', () {
        final message = PromptBuilder.buildInitialUserMessage(
          profileType: ProfileType.beginner,
          focusOptions: {
            FocusOption.everydaySpending,
            FocusOption.saveForRetirement,
          },
        );
        expect(message, contains('everyday spending'));
        expect(message, contains('saving for retirement'));
        expect(message, contains('I want to focus on:'));
      });

      test('with custom option', () {
        final message = PromptBuilder.buildInitialUserMessage(
          profileType: ProfileType.beginner,
          customOption: 'college savings',
        );
        expect(message, contains('college savings'));
        expect(message, contains('I want to focus on:'));
      });

      test('with empty focus options', () {
        final message = PromptBuilder.buildInitialUserMessage(
          profileType: ProfileType.beginner,
          focusOptions: {},
        );
        expect(
          message,
          contains("I haven't picked specific focus areas yet"),
        );
        expect(message, contains('help me figure out where to start'));
      });
    });
  });
}
