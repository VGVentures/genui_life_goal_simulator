import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/onboarding/pick_profile/models/profile_type.dart';
import 'package:genui_life_goal_simulator/onboarding/want_to_focus/models/focus_option.dart';
import 'package:genui_life_goal_simulator/simulator/bloc/bloc.dart';
import 'package:genui_life_goal_simulator/simulator/repository/simulator_conversation_event.dart';
import 'package:genui_life_goal_simulator/simulator/repository/simulator_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockSimulatorRepository extends Mock implements SimulatorRepository {}

const _simulatorStarted = SimulatorStarted(
  profileType: ProfileType.beginner,
  focusOptions: {FocusOption.everydaySpending},
);

void main() {
  setUpAll(() {
    registerFallbackValue(ProfileType.beginner);
    registerFallbackValue(<FocusOption>{});
  });

  late SimulatorRepository repository;
  late StreamController<SimulatorConversationEvent> eventsController;

  setUp(() {
    repository = _MockSimulatorRepository();
    eventsController = StreamController<SimulatorConversationEvent>.broadcast();

    when(() => repository.events).thenAnswer((_) => eventsController.stream);
    when(() => repository.startConversation()).thenAnswer((_) async {});
    when(() => repository.sendMessage(any())).thenAnswer((_) async {});
    when(() => repository.dispose()).thenAnswer((_) async {});
  });

  tearDown(() async {
    await eventsController.close();
  });

  group(SimulatorState, () {
    test('has correct defaults', () {
      const state = SimulatorState();
      expect(state.status, SimulatorStatus.initial);
      expect(state.pages, isEmpty);
      expect(state.currentPageIndex, 0);
      expect(state.isLoading, isFalse);
      expect(state.showLoadingOverlay, isFalse);
      expect(state.error, isNull);
    });

    test('copyWith returns new instance with overridden values', () {
      const state = SimulatorState();
      final updated = state.copyWith(
        status: SimulatorStatus.error,
        pages: [
          [const UserDisplayMessage('hi')],
        ],
        isLoading: true,
        error: 'oops',
      );
      expect(updated.status, SimulatorStatus.error);
      expect(updated.pages, hasLength(1));
      expect(updated.currentPageIndex, 0);
      expect(updated.isLoading, isTrue);
      expect(updated.error, 'oops');
    });

    test('copyWith preserves values when not overridden', () {
      const state = SimulatorState(
        status: SimulatorStatus.active,
        pages: [
          [UserDisplayMessage('hi')],
        ],
        isLoading: true,
        error: 'err',
      );
      final copy = state.copyWith();
      expect(copy.status, SimulatorStatus.active);
      expect(copy.pages, hasLength(1));
      expect(copy.currentPageIndex, 0);
      expect(copy.isLoading, isTrue);
      expect(copy.error, 'err');
    });
  });

  group(SimulatorStatus, () {
    test('has all expected values', () {
      expect(
        SimulatorStatus.values,
        containsAll([
          SimulatorStatus.initial,
          SimulatorStatus.loading,
          SimulatorStatus.active,
          SimulatorStatus.error,
        ]),
      );
    });
  });

  group(SimulatorEvent, () {
    test('$SimulatorStarted holds onboarding data', () {
      const event = SimulatorStarted(
        profileType: ProfileType.optimizer,
        focusOptions: {FocusOption.mortgage},
        customOption: 'custom',
      );
      expect(event.profileType, ProfileType.optimizer);
      expect(event.focusOptions, {FocusOption.mortgage});
      expect(event.customOption, 'custom');
    });

    test('$SimulatorMessageSent holds text', () {
      const event = SimulatorMessageSent('hello');
      expect(event.text, 'hello');
    });

    test('$SimulatorSurfaceReceived holds surfaceId', () {
      const event = SimulatorSurfaceReceived('surface_1');
      expect(event.surfaceId, 'surface_1');
    });

    test('$SimulatorContentReceived holds message', () {
      const event = SimulatorContentReceived(AiTextDisplayMessage('hi'));
      expect(event.message, isA<AiTextDisplayMessage>());
    });

    test('$SimulatorLoading holds isLoading', () {
      const event = SimulatorLoading(isLoading: true);
      expect(event.isLoading, isTrue);
    });

    test('$SimulatorErrorOccurred holds message', () {
      const event = SimulatorErrorOccurred('fail');
      expect(event.message, 'fail');
    });
  });

  group(SimulatorBloc, () {
    test('initial state is {$SimulatorState()}', () {
      final bloc = SimulatorBloc(simulatorRepository: repository);
      expect(bloc.state.status, SimulatorStatus.initial);
      expect(bloc.state.pages, isEmpty);
      expect(bloc.state.isLoading, isFalse);
      addTearDown(bloc.close);
    });

    blocTest<SimulatorBloc, SimulatorState>(
      '$SimulatorStarted emits loading, then active',
      build: () => SimulatorBloc(simulatorRepository: repository),
      act: (bloc) => bloc.add(_simulatorStarted),
      verify: (bloc) {
        expect(bloc.state.status, SimulatorStatus.active);
        verify(() => repository.startConversation()).called(1);
        verify(
          () => repository.sendMessage(any()),
        ).called(1);
      },
    );

    blocTest<SimulatorBloc, SimulatorState>(
      'repository text event emits content received',
      build: () => SimulatorBloc(simulatorRepository: repository),
      seed: () => const SimulatorState(
        status: SimulatorStatus.active,
        pages: [[]],
      ),
      act: (bloc) async {
        bloc.add(_simulatorStarted);
        await Future<void>.delayed(Duration.zero);
        eventsController.add(
          const SimulatorConversationTextReceived('hello'),
        );
      },
      verify: (bloc) {
        final page = bloc.state.pages.first;
        expect(page, isNotEmpty);
        expect(page.last, isA<AiTextDisplayMessage>());
      },
    );

    blocTest<SimulatorBloc, SimulatorState>(
      'repository surface event creates a new page',
      build: () => SimulatorBloc(simulatorRepository: repository),
      act: (bloc) async {
        bloc.add(_simulatorStarted);
        await Future<void>.delayed(Duration.zero);
        eventsController.add(
          const SimulatorConversationSurfaceAdded('surface_1'),
        );
      },
      verify: (bloc) {
        expect(bloc.state.pages, hasLength(1));
        expect(bloc.state.pages.first.first, isA<AiSurfaceDisplayMessage>());
      },
    );

    blocTest<SimulatorBloc, SimulatorState>(
      'repository error event emits error status',
      build: () => SimulatorBloc(simulatorRepository: repository),
      act: (bloc) async {
        bloc.add(_simulatorStarted);
        await Future<void>.delayed(Duration.zero);
        eventsController.add(const SimulatorConversationError('oops'));
      },
      verify: (bloc) {
        expect(bloc.state.status, SimulatorStatus.error);
        expect(bloc.state.error, 'oops');
      },
    );

    blocTest<SimulatorBloc, SimulatorState>(
      'repository waiting event emits loading state',
      build: () => SimulatorBloc(simulatorRepository: repository),
      act: (bloc) async {
        bloc.add(_simulatorStarted);
        await Future<void>.delayed(Duration.zero);
        eventsController.add(
          const SimulatorConversationWaiting(isWaiting: true),
        );
      },
      verify: (bloc) {
        expect(bloc.state.isLoading, isTrue);
      },
    );

    blocTest<SimulatorBloc, SimulatorState>(
      '$SimulatorSurfaceReceived creates a new page for a new surface',
      build: () => SimulatorBloc(simulatorRepository: repository),
      act: (bloc) => bloc.add(const SimulatorSurfaceReceived('surface_1')),
      expect: () => [
        isA<SimulatorState>()
            .having((s) => s.pages, 'pages', hasLength(1))
            .having((s) => s.pages.first, 'first page', hasLength(1))
            .having((s) => s.currentPageIndex, 'currentPageIndex', 0),
      ],
    );

    blocTest<SimulatorBloc, SimulatorState>(
      '$SimulatorSurfaceReceived stays on existing page for known surface',
      build: () => SimulatorBloc(simulatorRepository: repository),
      seed: () => const SimulatorState(
        pages: [
          [AiSurfaceDisplayMessage('surface_1')],
          [AiSurfaceDisplayMessage('surface_2')],
        ],
        currentPageIndex: 1,
      ),
      act: (bloc) => bloc.add(const SimulatorSurfaceReceived('surface_1')),
      expect: () => [
        isA<SimulatorState>()
            .having((s) => s.pages, 'pages', hasLength(2))
            .having((s) => s.currentPageIndex, 'currentPageIndex', 0),
      ],
    );

    blocTest<SimulatorBloc, SimulatorState>(
      '$SimulatorContentReceived appends message to current page',
      build: () => SimulatorBloc(simulatorRepository: repository),
      seed: () => const SimulatorState(
        pages: [[]],
      ),
      act: (bloc) =>
          bloc.add(const SimulatorContentReceived(AiTextDisplayMessage('hi'))),
      expect: () => [
        isA<SimulatorState>().having(
          (s) => s.pages.first,
          'first page',
          hasLength(1),
        ),
      ],
    );

    blocTest<SimulatorBloc, SimulatorState>(
      '$SimulatorContentReceived creates a page if none exist',
      build: () => SimulatorBloc(simulatorRepository: repository),
      act: (bloc) =>
          bloc.add(const SimulatorContentReceived(AiTextDisplayMessage('hi'))),
      expect: () => [
        isA<SimulatorState>()
            .having((s) => s.pages, 'pages', hasLength(1))
            .having((s) => s.pages.first, 'first page', hasLength(1)),
      ],
    );

    blocTest<SimulatorBloc, SimulatorState>(
      '$SimulatorLoading emits state with isLoading',
      build: () => SimulatorBloc(simulatorRepository: repository),
      act: (bloc) => bloc.add(const SimulatorLoading(isLoading: true)),
      expect: () => [
        isA<SimulatorState>().having((s) => s.isLoading, 'isLoading', isTrue),
      ],
    );

    blocTest<SimulatorBloc, SimulatorState>(
      '$SimulatorLoadingOverlayRequested sets showLoadingOverlay to true',
      build: () => SimulatorBloc(simulatorRepository: repository),
      act: (bloc) => bloc.add(const SimulatorLoadingOverlayRequested()),
      expect: () => [
        isA<SimulatorState>().having(
          (s) => s.showLoadingOverlay,
          'showLoadingOverlay',
          isTrue,
        ),
      ],
    );

    blocTest<SimulatorBloc, SimulatorState>(
      '$SimulatorSurfaceReceived clears showLoadingOverlay',
      build: () => SimulatorBloc(simulatorRepository: repository),
      seed: () => const SimulatorState(showLoadingOverlay: true),
      act: (bloc) => bloc.add(const SimulatorSurfaceReceived('surface_1')),
      expect: () => [
        isA<SimulatorState>().having(
          (s) => s.showLoadingOverlay,
          'showLoadingOverlay',
          isFalse,
        ),
      ],
    );

    blocTest<SimulatorBloc, SimulatorState>(
      'defers navigation when surface arrives while loading',
      build: () => SimulatorBloc(simulatorRepository: repository),
      seed: () => const SimulatorState(
        status: SimulatorStatus.active,
        pages: [
          [AiSurfaceDisplayMessage('surface_1')],
        ],
        isLoading: true,
      ),
      act: (bloc) => bloc.add(const SimulatorSurfaceReceived('surface_2')),
      expect: () => [
        isA<SimulatorState>()
            .having((s) => s.pages, 'pages', hasLength(2))
            .having((s) => s.currentPageIndex, 'currentPageIndex', 0)
            .having(
              (s) => s.pendingPageIndex,
              'pendingPageIndex',
              1,
            ),
      ],
    );

    blocTest<SimulatorBloc, SimulatorState>(
      'navigates to pending page when loading finishes',
      build: () => SimulatorBloc(simulatorRepository: repository),
      seed: () => const SimulatorState(
        status: SimulatorStatus.active,
        pages: [
          [AiSurfaceDisplayMessage('surface_1')],
        ],
        isLoading: true,
        showLoadingOverlay: true,
      ),
      act: (bloc) {
        // Surface arrives while loading → deferred.
        // Then loading finishes → pending navigation flushes.
        bloc
          ..add(const SimulatorSurfaceReceived('surface_2'))
          ..add(const SimulatorLoading(isLoading: false));
      },
      skip: 1,
      expect: () => [
        // Loading set to false.
        isA<SimulatorState>().having((s) => s.isLoading, 'isLoading', isFalse),
        // Pending navigation flushed.
        isA<SimulatorState>()
            .having((s) => s.currentPageIndex, 'currentPageIndex', 1)
            .having(
              (s) => s.pendingPageIndex,
              'pendingPageIndex',
              isNull,
            )
            .having(
              (s) => s.showLoadingOverlay,
              'showLoadingOverlay',
              isFalse,
            ),
      ],
    );

    blocTest<SimulatorBloc, SimulatorState>(
      '$SimulatorErrorOccurred emits error status with message',
      build: () => SimulatorBloc(simulatorRepository: repository),
      act: (bloc) => bloc.add(const SimulatorErrorOccurred('something failed')),
      expect: () => [
        isA<SimulatorState>()
            .having((s) => s.status, 'status', SimulatorStatus.error)
            .having((s) => s.error, 'error', 'something failed'),
      ],
    );

    blocTest<SimulatorBloc, SimulatorState>(
      '$SimulatorMessageSent calls repository.sendMessage',
      build: () => SimulatorBloc(simulatorRepository: repository),
      act: (bloc) => bloc.add(const SimulatorMessageSent('hello')),
      verify: (_) {
        verify(() => repository.sendMessage('hello')).called(1);
      },
    );

    blocTest<SimulatorBloc, SimulatorState>(
      '$SimulatorRetried resets to last page with content and clears error',
      build: () => SimulatorBloc(simulatorRepository: repository),
      seed: () => const SimulatorState(
        status: SimulatorStatus.error,
        error: 'something failed',
        pages: [
          [AiTextDisplayMessage('Welcome')],
          [AiSurfaceDisplayMessage('surface_1')],
        ],
        currentPageIndex: 1,
      ),
      act: (bloc) => bloc.add(const SimulatorRetried()),
      expect: () => [
        isA<SimulatorState>()
            .having((s) => s.status, 'status', SimulatorStatus.active)
            .having((s) => s.isLoading, 'isLoading', isTrue)
            .having((s) => s.currentPageIndex, 'currentPageIndex', 0)
            .having((s) => s.error, 'error', isNull),
      ],
      verify: (_) {
        verify(
          () => repository.sendMessage('Please continue where you left off.'),
        ).called(1);
      },
    );

    blocTest<SimulatorBloc, SimulatorState>(
      '$SimulatorContentReceived merges consecutive text messages with space',
      build: () => SimulatorBloc(simulatorRepository: repository),
      seed: () => const SimulatorState(
        pages: [
          [AiTextDisplayMessage('Hello')],
        ],
      ),
      act: (bloc) => bloc.add(
        const SimulatorContentReceived(AiTextDisplayMessage('world')),
      ),
      expect: () => [
        isA<SimulatorState>().having(
          (s) => (s.pages.first.first as AiTextDisplayMessage).text,
          'merged text',
          'Hello world',
        ),
      ],
    );

    blocTest<SimulatorBloc, SimulatorState>(
      '$SimulatorContentReceived skips space when text ends with newline',
      build: () => SimulatorBloc(simulatorRepository: repository),
      seed: () => const SimulatorState(
        pages: [
          [AiTextDisplayMessage('Hello\n')],
        ],
      ),
      act: (bloc) => bloc.add(
        const SimulatorContentReceived(AiTextDisplayMessage('world')),
      ),
      expect: () => [
        isA<SimulatorState>().having(
          (s) => (s.pages.first.first as AiTextDisplayMessage).text,
          'merged text',
          'Hello\nworld',
        ),
      ],
    );

    blocTest<SimulatorBloc, SimulatorState>(
      '$SimulatorContentReceived does not merge surface with text',
      build: () => SimulatorBloc(simulatorRepository: repository),
      seed: () => const SimulatorState(
        pages: [
          [AiSurfaceDisplayMessage('s1')],
        ],
      ),
      act: (bloc) =>
          bloc.add(const SimulatorContentReceived(AiTextDisplayMessage('hi'))),
      expect: () => [
        isA<SimulatorState>().having(
          (s) => s.pages.first,
          'first page',
          hasLength(2),
        ),
      ],
    );

    test('close disposes repository', () async {
      final bloc = SimulatorBloc(simulatorRepository: repository);
      await bloc.close();
      verify(() => repository.dispose()).called(1);
    });
  });
}
