import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/feature_flags/repository/feature_flags_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class MockStreamingSharedPreferences extends Mock
    implements StreamingSharedPreferences {}

/// A fake [Preference] backed by a [StreamController] so that
/// standard [Stream] operations like `.map()` work correctly.
class FakePreference extends StreamView<bool> implements Preference<bool> {
  FakePreference({
    required this.key,
    required this.defaultValue,
    required bool initialValue,
    required StreamController<bool> controller,
  }) : _value = initialValue,
       _controller = controller,
       super(controller.stream);

  final StreamController<bool> _controller;
  bool _value;

  @override
  final String key;

  @override
  final bool defaultValue;

  @override
  bool getValue() => _value;

  @override
  Future<bool> setValue(bool value) async {
    _value = value;
    _controller.add(value);
    return true;
  }

  @override
  Future<bool> clear() async {
    _value = defaultValue;
    _controller.add(defaultValue);
    return true;
  }
}

/// Returns a matcher that checks a [FeatureFlag] has the given [id] and
/// [value].
Matcher _isFlag({required String id, required bool value}) {
  return predicate<FeatureFlag>(
    (flag) => flag.id == id && flag.value == value,
    'is FeatureFlag(id: $id, value: $value)',
  );
}

void main() {
  const testFlag = FeatureFlag(
    id: 'test_flag',
    name: 'Test Flag',
    description: 'A flag for testing',
    value: false,
    defaultValue: false,
  );

  const anotherFlag = FeatureFlag(
    id: 'another_flag',
    name: 'Another Flag',
    description: 'Another flag for testing',
    value: true,
    defaultValue: true,
  );

  late MockStreamingSharedPreferences mockPreferences;

  setUp(() {
    mockPreferences = MockStreamingSharedPreferences();
  });

  group(FeatureFlagsRepository, () {
    group('getFeatureFlagIds', () {
      test('returns all feature flag IDs', () {
        final repository = FeatureFlagsRepository(
          streamingSharedPreferences: mockPreferences,
          featureFlags: [testFlag, anotherFlag],
        );

        expect(
          repository.getFeatureFlagIds(),
          equals(['test_flag', 'another_flag']),
        );
      });

      test('returns empty list when no flags are defined', () {
        final repository = FeatureFlagsRepository(
          streamingSharedPreferences: mockPreferences,
          featureFlags: [],
        );

        expect(repository.getFeatureFlagIds(), isEmpty);
      });
    });

    group('toggleFeatureFlag', () {
      test('reads current value and writes the negation', () async {
        final controller = StreamController<bool>.broadcast();
        addTearDown(controller.close);

        final fakePreference = FakePreference(
          key: 'feature_flag_test_flag',
          defaultValue: false,
          initialValue: false,
          controller: controller,
        );

        when(
          () => mockPreferences.getBool(
            'feature_flag_test_flag',
            defaultValue: false,
          ),
        ).thenAnswer((_) => fakePreference);

        when(
          () => mockPreferences.setBool('feature_flag_test_flag', any()),
        ).thenAnswer((_) async => true);

        final repository = FeatureFlagsRepository(
          streamingSharedPreferences: mockPreferences,
          featureFlags: [testFlag],
        );

        await repository.toggleFeatureFlag('test_flag');

        verify(
          () => mockPreferences.setBool('feature_flag_test_flag', true),
        ).called(1);
      });

      test('toggles from true to false', () async {
        final controller = StreamController<bool>.broadcast();
        addTearDown(controller.close);

        final fakePreference = FakePreference(
          key: 'feature_flag_test_flag',
          defaultValue: false,
          initialValue: true,
          controller: controller,
        );

        when(
          () => mockPreferences.getBool(
            'feature_flag_test_flag',
            defaultValue: false,
          ),
        ).thenAnswer((_) => fakePreference);

        when(
          () => mockPreferences.setBool('feature_flag_test_flag', any()),
        ).thenAnswer((_) async => true);

        final repository = FeatureFlagsRepository(
          streamingSharedPreferences: mockPreferences,
          featureFlags: [testFlag],
        );

        await repository.toggleFeatureFlag('test_flag');

        verify(
          () => mockPreferences.setBool('feature_flag_test_flag', false),
        ).called(1);
      });

      test('throws FeatureFlagNotFoundException for unknown flag ID', () {
        final repository = FeatureFlagsRepository(
          streamingSharedPreferences: mockPreferences,
          featureFlags: [testFlag],
        );

        expect(
          () => repository.toggleFeatureFlag('unknown'),
          throwsA(isA<FeatureFlagNotFoundException>()),
        );
      });
    });

    group('watchFeatureFlag', () {
      test('emits FeatureFlag with resolved value', () async {
        final controller = StreamController<bool>.broadcast();
        addTearDown(controller.close);

        final fakePreference = FakePreference(
          key: 'feature_flag_test_flag',
          defaultValue: false,
          initialValue: false,
          controller: controller,
        );

        when(
          () => mockPreferences.getBool(
            'feature_flag_test_flag',
            defaultValue: false,
          ),
        ).thenAnswer((_) => fakePreference);

        when(
          () => mockPreferences.setBool('feature_flag_test_flag', any()),
        ).thenAnswer((invocation) async {
          final value = invocation.positionalArguments[1] as bool;
          await fakePreference.setValue(value);
          return true;
        });

        final repository = FeatureFlagsRepository(
          streamingSharedPreferences: mockPreferences,
          featureFlags: [testFlag],
        );

        final future = expectLater(
          repository.watchFeatureFlag('test_flag'),
          emits(_isFlag(id: 'test_flag', value: true)),
        );

        await repository.toggleFeatureFlag('test_flag');

        await future;
      });

      test('emits updated FeatureFlag when value changes', () async {
        final controller = StreamController<bool>.broadcast();
        addTearDown(controller.close);

        final fakePreference = FakePreference(
          key: 'feature_flag_test_flag',
          defaultValue: false,
          initialValue: false,
          controller: controller,
        );

        when(
          () => mockPreferences.getBool(
            'feature_flag_test_flag',
            defaultValue: false,
          ),
        ).thenAnswer((_) => fakePreference);

        when(
          () => mockPreferences.setBool('feature_flag_test_flag', any()),
        ).thenAnswer((invocation) async {
          final value = invocation.positionalArguments[1] as bool;
          await fakePreference.setValue(value);
          return true;
        });

        final repository = FeatureFlagsRepository(
          streamingSharedPreferences: mockPreferences,
          featureFlags: [testFlag],
        );

        final future = expectLater(
          repository.watchFeatureFlag('test_flag'),
          emitsInOrder([
            _isFlag(id: 'test_flag', value: true),
            _isFlag(id: 'test_flag', value: false),
          ]),
        );

        await repository.toggleFeatureFlag('test_flag');
        await repository.toggleFeatureFlag('test_flag');

        await future;
      });

      test('preserves defaultValue when value is overridden', () async {
        final controller = StreamController<bool>.broadcast();
        addTearDown(controller.close);

        final fakePreference = FakePreference(
          key: 'feature_flag_test_flag',
          defaultValue: false,
          initialValue: false,
          controller: controller,
        );

        when(
          () => mockPreferences.getBool(
            'feature_flag_test_flag',
            defaultValue: false,
          ),
        ).thenAnswer((_) => fakePreference);

        when(
          () => mockPreferences.setBool('feature_flag_test_flag', any()),
        ).thenAnswer((invocation) async {
          final value = invocation.positionalArguments[1] as bool;
          await fakePreference.setValue(value);
          return true;
        });

        final repository = FeatureFlagsRepository(
          streamingSharedPreferences: mockPreferences,
          featureFlags: [testFlag],
        );

        final future = expectLater(
          repository.watchFeatureFlag('test_flag'),
          emits(
            predicate<FeatureFlag>(
              (flag) => flag.value && !flag.defaultValue,
              'has value=true but defaultValue=false',
            ),
          ),
        );

        await repository.toggleFeatureFlag('test_flag');

        await future;
      });

      test('throws FeatureFlagNotFoundException for unknown flag ID', () {
        final repository = FeatureFlagsRepository(
          streamingSharedPreferences: mockPreferences,
          featureFlags: [testFlag],
        );

        expect(
          () => repository.watchFeatureFlag('unknown'),
          throwsA(isA<FeatureFlagNotFoundException>()),
        );
      });
    });
  });
}
