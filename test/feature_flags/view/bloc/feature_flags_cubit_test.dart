import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/feature_flags/feature_flags.dart';
import 'package:mocktail/mocktail.dart';

class _MockFeatureFlagsRepository extends Mock
    implements FeatureFlagsRepository {}

void main() {
  group(FeatureFlagsCubit, () {
    late FeatureFlagsRepository repository;

    const flag = FeatureFlag(
      id: 'flag_1',
      name: 'Flag 1',
      description: 'Description',
      value: true,
      defaultValue: false,
    );

    const flag1On = FeatureFlag(
      id: 'flag_1',
      name: 'Flag 1',
      description: 'Description',
      value: true,
      defaultValue: false,
    );

    const flag1Off = FeatureFlag(
      id: 'flag_1',
      name: 'Flag 1',
      description: 'Description',
      value: false,
      defaultValue: false,
    );

    setUp(() {
      repository = _MockFeatureFlagsRepository();
    });

    test('initial state is $FeatureFlagsInitial', () {
      final cubit = FeatureFlagsCubit(featureFlagsRepository: repository);
      addTearDown(cubit.close);
      expect(cubit.state, const FeatureFlagsInitial());
    });

    blocTest<FeatureFlagsCubit, FeatureFlagsState>(
      'init emits [$FeatureFlagsInProgress, $FeatureFlagsSuccess]'
      ' when stream emits flags',
      setUp: () {
        when(
          () => repository.getFeatureFlagIds(),
        ).thenReturn([flag.id]);
        when(
          () => repository.watchFeatureFlag(flag.id),
        ).thenAnswer((_) => Stream.fromIterable([flag1On, flag1Off]));
      },
      build: () => FeatureFlagsCubit(featureFlagsRepository: repository),
      act: (cubit) => cubit.init(),
      expect: () => [
        const FeatureFlagsInProgress(),
        const FeatureFlagsSuccess(featureFlags: [flag1On]),
        const FeatureFlagsSuccess(featureFlags: [flag1Off]),
      ],
      verify: (_) {
        verify(() => repository.getFeatureFlagIds()).called(1);
        verify(() => repository.watchFeatureFlag(flag.id)).called(1);
        verifyNoMoreInteractions(repository);
      },
    );

    blocTest<FeatureFlagsCubit, FeatureFlagsState>(
      'init emits [$FeatureFlagsInProgress, $FeatureFlagsFailure] when '
      'stream errors',
      setUp: () {
        when(() => repository.getFeatureFlagIds()).thenReturn([flag.id]);
        when(
          () => repository.watchFeatureFlag(flag.id),
        ).thenAnswer((_) => Stream.error('ERROR'));
      },
      build: () => FeatureFlagsCubit(featureFlagsRepository: repository),
      act: (cubit) => cubit.init(),
      expect: () => [
        const FeatureFlagsInProgress(),
        isA<FeatureFlagsFailure>(),
      ],
    );

    blocTest<FeatureFlagsCubit, FeatureFlagsState>(
      'init emits [$FeatureFlagsInProgress, $FeatureFlagsFailure] when '
      'getFeatureFlagIds throws an error',
      setUp: () {
        when(
          () => repository.getFeatureFlagIds(),
        ).thenThrow(Exception('unexpected'));
      },
      build: () => FeatureFlagsCubit(featureFlagsRepository: repository),
      act: (cubit) => cubit.init(),
      expect: () => [
        const FeatureFlagsInProgress(),
        isA<FeatureFlagsFailure>(),
      ],
    );

    blocTest<FeatureFlagsCubit, FeatureFlagsState>(
      'onToggleFeatureFlag call the repository',
      setUp: () {
        when(
          () => repository.toggleFeatureFlag(flag.id),
        ).thenAnswer((_) async {});
      },
      build: () => FeatureFlagsCubit(featureFlagsRepository: repository),
      act: (cubit) => cubit.onToggleFeatureFlag(flag.id),
      verify: (_) =>
          verify(() => repository.toggleFeatureFlag(flag.id)).called(1),
    );
  });
}
