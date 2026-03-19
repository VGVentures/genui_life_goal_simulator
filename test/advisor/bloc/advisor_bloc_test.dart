import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv_genui_financial_advisor/advisor/bloc/bloc.dart';
import 'package:vgv_genui_financial_advisor/advisor/repository/advisor_conversation_event.dart';
import 'package:vgv_genui_financial_advisor/advisor/repository/advisor_repository.dart';
import 'package:vgv_genui_financial_advisor/onboarding/pick_profile/models/profile_type.dart';
import 'package:vgv_genui_financial_advisor/onboarding/want_to_focus/models/focus_option.dart';

class _MockAdvisorRepository extends Mock implements AdvisorRepository {}

class _MockSurfaceHost extends Mock implements SurfaceHost {}

const _advisorStarted = AdvisorStarted(
  profileType: ProfileType.beginner,
  focusOptions: {FocusOption.everydaySpending},
);

void main() {
  setUpAll(() {
    registerFallbackValue(ProfileType.beginner);
    registerFallbackValue(<FocusOption>{});
  });

  late AdvisorRepository repository;
  late StreamController<AdvisorConversationEvent> eventsController;

  setUp(() {
    repository = _MockAdvisorRepository();
    eventsController = StreamController<AdvisorConversationEvent>.broadcast();

    when(() => repository.events).thenAnswer((_) => eventsController.stream);
    when(() => repository.startConversation()).thenAnswer((_) async {});
    when(() => repository.sendMessage(any())).thenAnswer((_) async {});
    when(() => repository.surfaceHost).thenReturn(_MockSurfaceHost());
    when(() => repository.dispose()).thenAnswer((_) async {});
  });

  tearDown(() async {
    await eventsController.close();
  });

  group(AdvisorState, () {
    test('has correct defaults', () {
      const state = AdvisorState();
      expect(state.status, AdvisorStatus.initial);
      expect(state.pages, isEmpty);
      expect(state.currentPageIndex, 0);
      expect(state.isLoading, isFalse);
      expect(state.host, isNull);
      expect(state.error, isNull);
    });

    test('copyWith returns new instance with overridden values', () {
      const state = AdvisorState();
      final updated = state.copyWith(
        status: AdvisorStatus.error,
        pages: [
          [const UserDisplayMessage('hi')],
        ],
        isLoading: true,
        error: 'oops',
      );
      expect(updated.status, AdvisorStatus.error);
      expect(updated.pages, hasLength(1));
      expect(updated.currentPageIndex, 0);
      expect(updated.isLoading, isTrue);
      expect(updated.error, 'oops');
    });

    test('copyWith preserves values when not overridden', () {
      const state = AdvisorState(
        status: AdvisorStatus.active,
        pages: [
          [UserDisplayMessage('hi')],
        ],
        isLoading: true,
        error: 'err',
      );
      final copy = state.copyWith();
      expect(copy.status, AdvisorStatus.active);
      expect(copy.pages, hasLength(1));
      expect(copy.currentPageIndex, 0);
      expect(copy.isLoading, isTrue);
      expect(copy.error, 'err');
    });
  });

  group(AdvisorStatus, () {
    test('has all expected values', () {
      expect(
        AdvisorStatus.values,
        containsAll([
          AdvisorStatus.initial,
          AdvisorStatus.loading,
          AdvisorStatus.active,
          AdvisorStatus.error,
        ]),
      );
    });
  });

  group(AdvisorEvent, () {
    test('$AdvisorStarted holds onboarding data', () {
      const event = AdvisorStarted(
        profileType: ProfileType.optimizer,
        focusOptions: {FocusOption.mortgage},
        customOption: 'custom',
      );
      expect(event.profileType, ProfileType.optimizer);
      expect(event.focusOptions, {FocusOption.mortgage});
      expect(event.customOption, 'custom');
    });

    test('$AdvisorMessageSent holds text', () {
      const event = AdvisorMessageSent('hello');
      expect(event.text, 'hello');
    });

    test('$AdvisorSurfaceReceived holds surfaceId', () {
      const event = AdvisorSurfaceReceived('surface_1');
      expect(event.surfaceId, 'surface_1');
    });

    test('$AdvisorContentReceived holds message', () {
      const event = AdvisorContentReceived(AiTextDisplayMessage('hi'));
      expect(event.message, isA<AiTextDisplayMessage>());
    });

    test('$AdvisorLoading holds isLoading', () {
      const event = AdvisorLoading(isLoading: true);
      expect(event.isLoading, isTrue);
    });

    test('$AdvisorErrorOccurred holds message', () {
      const event = AdvisorErrorOccurred('fail');
      expect(event.message, 'fail');
    });
  });

  group(AdvisorBloc, () {
    test('initial state is {$AdvisorState()}', () {
      final bloc = AdvisorBloc(advisorRepository: repository);
      expect(bloc.state.status, AdvisorStatus.initial);
      expect(bloc.state.pages, isEmpty);
      expect(bloc.state.isLoading, isFalse);
      addTearDown(bloc.close);
    });

    blocTest<AdvisorBloc, AdvisorState>(
      '$AdvisorStarted emits loading, then active with host',
      build: () => AdvisorBloc(advisorRepository: repository),
      act: (bloc) => bloc.add(_advisorStarted),
      verify: (bloc) {
        expect(bloc.state.status, AdvisorStatus.active);
        expect(bloc.state.host, isNotNull);
        verify(() => repository.startConversation()).called(1);
        verify(
          () => repository.sendMessage(any()),
        ).called(1);
      },
    );

    blocTest<AdvisorBloc, AdvisorState>(
      'repository text event emits content received',
      build: () => AdvisorBloc(advisorRepository: repository),
      seed: () => const AdvisorState(
        status: AdvisorStatus.active,
        pages: [[]],
      ),
      act: (bloc) async {
        bloc.add(_advisorStarted);
        await Future<void>.delayed(Duration.zero);
        eventsController.add(
          const AdvisorConversationTextReceived('hello'),
        );
      },
      verify: (bloc) {
        final page = bloc.state.pages.first;
        expect(page, isNotEmpty);
        expect(page.last, isA<AiTextDisplayMessage>());
      },
    );

    blocTest<AdvisorBloc, AdvisorState>(
      'repository surface event creates a new page',
      build: () => AdvisorBloc(advisorRepository: repository),
      act: (bloc) async {
        bloc.add(_advisorStarted);
        await Future<void>.delayed(Duration.zero);
        eventsController.add(
          const AdvisorConversationSurfaceAdded('surface_1'),
        );
      },
      verify: (bloc) {
        expect(bloc.state.pages, hasLength(1));
        expect(bloc.state.pages.first.first, isA<AiSurfaceDisplayMessage>());
      },
    );

    blocTest<AdvisorBloc, AdvisorState>(
      'repository error event emits error status',
      build: () => AdvisorBloc(advisorRepository: repository),
      act: (bloc) async {
        bloc.add(_advisorStarted);
        await Future<void>.delayed(Duration.zero);
        eventsController.add(const AdvisorConversationError('oops'));
      },
      verify: (bloc) {
        expect(bloc.state.status, AdvisorStatus.error);
        expect(bloc.state.error, 'oops');
      },
    );

    blocTest<AdvisorBloc, AdvisorState>(
      'repository waiting event emits loading state',
      build: () => AdvisorBloc(advisorRepository: repository),
      act: (bloc) async {
        bloc.add(_advisorStarted);
        await Future<void>.delayed(Duration.zero);
        eventsController.add(
          const AdvisorConversationWaiting(isWaiting: true),
        );
      },
      verify: (bloc) {
        expect(bloc.state.isLoading, isTrue);
      },
    );

    blocTest<AdvisorBloc, AdvisorState>(
      '$AdvisorSurfaceReceived creates a new page for a new surface',
      build: () => AdvisorBloc(advisorRepository: repository),
      act: (bloc) => bloc.add(const AdvisorSurfaceReceived('surface_1')),
      expect: () => [
        isA<AdvisorState>()
            .having((s) => s.pages, 'pages', hasLength(1))
            .having((s) => s.pages.first, 'first page', hasLength(1))
            .having((s) => s.currentPageIndex, 'currentPageIndex', 0),
      ],
    );

    blocTest<AdvisorBloc, AdvisorState>(
      '$AdvisorSurfaceReceived stays on existing page for known surface',
      build: () => AdvisorBloc(advisorRepository: repository),
      seed: () => const AdvisorState(
        pages: [
          [AiSurfaceDisplayMessage('surface_1')],
          [AiSurfaceDisplayMessage('surface_2')],
        ],
        currentPageIndex: 1,
      ),
      act: (bloc) => bloc.add(const AdvisorSurfaceReceived('surface_1')),
      expect: () => [
        isA<AdvisorState>()
            .having((s) => s.pages, 'pages', hasLength(2))
            .having((s) => s.currentPageIndex, 'currentPageIndex', 0),
      ],
    );

    blocTest<AdvisorBloc, AdvisorState>(
      '$AdvisorContentReceived appends message to current page',
      build: () => AdvisorBloc(advisorRepository: repository),
      seed: () => const AdvisorState(
        pages: [[]],
      ),
      act: (bloc) =>
          bloc.add(const AdvisorContentReceived(AiTextDisplayMessage('hi'))),
      expect: () => [
        isA<AdvisorState>().having(
          (s) => s.pages.first,
          'first page',
          hasLength(1),
        ),
      ],
    );

    blocTest<AdvisorBloc, AdvisorState>(
      '$AdvisorContentReceived creates a page if none exist',
      build: () => AdvisorBloc(advisorRepository: repository),
      act: (bloc) =>
          bloc.add(const AdvisorContentReceived(AiTextDisplayMessage('hi'))),
      expect: () => [
        isA<AdvisorState>()
            .having((s) => s.pages, 'pages', hasLength(1))
            .having((s) => s.pages.first, 'first page', hasLength(1)),
      ],
    );

    blocTest<AdvisorBloc, AdvisorState>(
      '$AdvisorLoading emits state with isLoading',
      build: () => AdvisorBloc(advisorRepository: repository),
      act: (bloc) => bloc.add(const AdvisorLoading(isLoading: true)),
      expect: () => [
        isA<AdvisorState>().having((s) => s.isLoading, 'isLoading', isTrue),
      ],
    );

    blocTest<AdvisorBloc, AdvisorState>(
      '$AdvisorErrorOccurred emits error status with message',
      build: () => AdvisorBloc(advisorRepository: repository),
      act: (bloc) => bloc.add(const AdvisorErrorOccurred('something failed')),
      expect: () => [
        isA<AdvisorState>()
            .having((s) => s.status, 'status', AdvisorStatus.error)
            .having((s) => s.error, 'error', 'something failed'),
      ],
    );

    blocTest<AdvisorBloc, AdvisorState>(
      '$AdvisorMessageSent calls repository.sendMessage',
      build: () => AdvisorBloc(advisorRepository: repository),
      act: (bloc) => bloc.add(const AdvisorMessageSent('hello')),
      verify: (_) {
        verify(() => repository.sendMessage('hello')).called(1);
      },
    );

    test('close disposes repository', () async {
      final bloc = AdvisorBloc(advisorRepository: repository);
      await bloc.close();
      verify(() => repository.dispose()).called(1);
    });
  });
}
