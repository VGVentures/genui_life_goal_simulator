import 'package:bloc_test/bloc_test.dart';
import 'package:finance_app/onboarding/want_to_focus/bloc/want_to_focus_cubit.dart';
import 'package:finance_app/onboarding/want_to_focus/models/focus_option.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(WantToFocusCubit, () {
    test('initial state is $WantToFocusState with empty options '
        'and no custom option', () {
      final cubit = WantToFocusCubit();
      addTearDown(cubit.close);
      expect(cubit.state, const WantToFocusState());
    });

    blocTest<WantToFocusCubit, WantToFocusState>(
      'toggleOption adds option when it was not selected',
      build: WantToFocusCubit.new,
      act: (cubit) => cubit.toggleOption(FocusOption.everydaySpending),
      expect: () => [
        const WantToFocusState(
          selectedOptions: {FocusOption.everydaySpending},
        ),
      ],
    );

    blocTest<WantToFocusCubit, WantToFocusState>(
      'toggleOption removes option when it was already selected',
      build: WantToFocusCubit.new,
      act: (cubit) => cubit
        ..toggleOption(FocusOption.everydaySpending)
        ..toggleOption(FocusOption.everydaySpending),
      expect: () => [
        const WantToFocusState(
          selectedOptions: {FocusOption.everydaySpending},
        ),
        const WantToFocusState(),
      ],
    );

    blocTest<WantToFocusCubit, WantToFocusState>(
      'setCustomOption emits state with the provided custom option',
      build: WantToFocusCubit.new,
      act: (cubit) => cubit.setCustomOption('my goal'),
      expect: () => [
        const WantToFocusState(customOption: 'my goal'),
      ],
    );
  });

  group(WantToFocusState, () {
    test('copyWith with new values returns updated state', () {
      const initial = WantToFocusState();
      final updated = initial.copyWith(
        selectedOptions: {FocusOption.mortgage},
        customOption: 'custom',
      );
      expect(updated.selectedOptions, {FocusOption.mortgage});
      expect(updated.customOption, 'custom');
    });

    test('copyWith without arguments preserves existing values', () {
      const state = WantToFocusState(
        selectedOptions: {FocusOption.mortgage},
        customOption: 'custom',
      );
      expect(state.copyWith(), state);
    });
  });
}
