import 'package:bloc_test/bloc_test.dart';
import 'package:dartantic_firebase_ai/dartantic_firebase_ai.dart';
import 'package:finance_app/advisor/bloc/bloc.dart';
import 'package:finance_app/onboarding/pick_profile/models/profile_type.dart';
import 'package:finance_app/onboarding/want_to_focus/models/focus_option.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:mocktail/mocktail.dart';

class _MockFirebaseAIChatModel extends Mock implements FirebaseAIChatModel {}

const _chatStarted = AdvisorStarted(
  profileType: ProfileType.beginner,
  focusOptions: {FocusOption.everydaySpending},
);

AdvisorBloc _buildBloc() {
  final mockModel = _MockFirebaseAIChatModel();
  when(() => mockModel.sendStream(any())).thenAnswer(
    (_) => const Stream.empty(),
  );
  return AdvisorBloc(chatModelFactory: () => mockModel);
}

void main() {
  setUpAll(() {
    registerFallbackValue(<ChatMessage>[]);
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
      final bloc = _buildBloc();
      expect(bloc.state.status, AdvisorStatus.initial);
      expect(bloc.state.pages, isEmpty);
      expect(bloc.state.isLoading, isFalse);
      addTearDown(bloc.close);
    });

    blocTest<AdvisorBloc, AdvisorState>(
      '$AdvisorStarted emits loading, then active with host',
      build: _buildBloc,
      act: (bloc) => bloc.add(_chatStarted),
      verify: (bloc) {
        expect(bloc.state.status, AdvisorStatus.active);
        expect(bloc.state.host, isNotNull);
      },
    );

    blocTest<AdvisorBloc, AdvisorState>(
      '$AdvisorSurfaceReceived creates a new page for a new surface',
      build: _buildBloc,
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
      build: _buildBloc,
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
      build: _buildBloc,
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
      build: _buildBloc,
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
      build: _buildBloc,
      act: (bloc) => bloc.add(const AdvisorLoading(isLoading: true)),
      expect: () => [
        isA<AdvisorState>().having((s) => s.isLoading, 'isLoading', isTrue),
      ],
    );

    blocTest<AdvisorBloc, AdvisorState>(
      '$AdvisorErrorOccurred emits error status with message',
      build: _buildBloc,
      act: (bloc) => bloc.add(const AdvisorErrorOccurred('something failed')),
      expect: () => [
        isA<AdvisorState>()
            .having((s) => s.status, 'status', AdvisorStatus.error)
            .having((s) => s.error, 'error', 'something failed'),
      ],
    );

    test('close disposes conversation resources', () async {
      final bloc = _buildBloc()..add(_chatStarted);
      await Future<void>.delayed(Duration.zero);
      // Should not throw when closing after starting.
      await bloc.close();
    });

    test('close without starting does not throw', () async {
      final bloc = _buildBloc();
      await bloc.close();
    });
  });
}
