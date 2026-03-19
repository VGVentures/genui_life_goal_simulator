import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgv_genui_financial_advisor/onboarding/pick_profile/pick_profile.dart';

void main() {
  group(PickProfileState, () {
    test('has correct defaults', () {
      const state = PickProfileState();
      expect(state.selectedProfile, isNull);
      expect(state.hasSelection, isFalse);
    });

    test('hasSelection returns true when profile is selected', () {
      const state = PickProfileState(selectedProfile: ProfileType.beginner);
      expect(state.hasSelection, isTrue);
    });

    test('supports value equality', () {
      const state1 = PickProfileState(selectedProfile: ProfileType.beginner);
      const state2 = PickProfileState(selectedProfile: ProfileType.beginner);
      expect(state1, equals(state2));
    });

    test('different profiles are not equal', () {
      const state1 = PickProfileState(selectedProfile: ProfileType.beginner);
      const state2 = PickProfileState(selectedProfile: ProfileType.optimizer);
      expect(state1, isNot(equals(state2)));
    });
  });

  group(PickProfileCubit, () {
    test('initial state has no selection', () {
      final cubit = PickProfileCubit();
      expect(cubit.state.selectedProfile, isNull);
      expect(cubit.state.hasSelection, isFalse);
      addTearDown(cubit.close);
    });

    blocTest<PickProfileCubit, PickProfileState>(
      'selectProfile emits state with selected profile',
      build: PickProfileCubit.new,
      act: (cubit) => cubit.selectProfile(ProfileType.beginner),
      expect: () => [
        isA<PickProfileState>().having(
          (s) => s.selectedProfile,
          'selectedProfile',
          ProfileType.beginner,
        ),
      ],
    );

    blocTest<PickProfileCubit, PickProfileState>(
      'selectProfile can change selection',
      build: PickProfileCubit.new,
      act: (cubit) {
        cubit
          ..selectProfile(ProfileType.beginner)
          ..selectProfile(ProfileType.optimizer);
      },
      expect: () => [
        const PickProfileState(selectedProfile: ProfileType.beginner),
        const PickProfileState(selectedProfile: ProfileType.optimizer),
      ],
    );
  });

  group(ProfileType, () {
    test('has all expected values', () {
      expect(
        ProfileType.values,
        containsAll([
          ProfileType.beginner,
          ProfileType.optimizer,
        ]),
      );
    });
  });
}
