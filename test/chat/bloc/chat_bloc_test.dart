import 'package:bloc_test/bloc_test.dart';
import 'package:dartantic_firebase_ai/dartantic_firebase_ai.dart';
import 'package:finance_app/chat/bloc/bloc.dart';
import 'package:finance_app/onboarding/pick_profile/models/profile_type.dart';
import 'package:finance_app/onboarding/want_to_focus/models/focus_option.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:mocktail/mocktail.dart';

class _MockFirebaseAIChatModel extends Mock implements FirebaseAIChatModel {}

const _chatStarted = ChatStarted(
  profileType: ProfileType.beginner,
  focusOptions: {FocusOption.everydaySpending},
);

ChatBloc _buildBloc() {
  final mockModel = _MockFirebaseAIChatModel();
  when(() => mockModel.sendStream(any())).thenAnswer(
    (_) => const Stream.empty(),
  );
  return ChatBloc(chatModelFactory: () => mockModel);
}

void main() {
  setUpAll(() {
    registerFallbackValue(<ChatMessage>[]);
  });

  group(ChatState, () {
    test('has correct defaults', () {
      const state = ChatState();
      expect(state.status, ChatStatus.initial);
      expect(state.pages, isEmpty);
      expect(state.currentPageIndex, 0);
      expect(state.isLoading, isFalse);
      expect(state.host, isNull);
      expect(state.error, isNull);
    });

    test('copyWith returns new instance with overridden values', () {
      const state = ChatState();
      final updated = state.copyWith(
        status: ChatStatus.error,
        pages: [
          [const UserDisplayMessage('hi')],
        ],
        isLoading: true,
        error: 'oops',
      );
      expect(updated.status, ChatStatus.error);
      expect(updated.pages, hasLength(1));
      expect(updated.currentPageIndex, 0);
      expect(updated.isLoading, isTrue);
      expect(updated.error, 'oops');
    });

    test('copyWith preserves values when not overridden', () {
      const state = ChatState(
        status: ChatStatus.active,
        pages: [
          [UserDisplayMessage('hi')],
        ],
        isLoading: true,
        error: 'err',
      );
      final copy = state.copyWith();
      expect(copy.status, ChatStatus.active);
      expect(copy.pages, hasLength(1));
      expect(copy.currentPageIndex, 0);
      expect(copy.isLoading, isTrue);
      expect(copy.error, 'err');
    });
  });

  group(ChatStatus, () {
    test('has all expected values', () {
      expect(
        ChatStatus.values,
        containsAll([
          ChatStatus.initial,
          ChatStatus.loading,
          ChatStatus.active,
          ChatStatus.error,
        ]),
      );
    });
  });

  group(ChatEvent, () {
    test('$ChatStarted holds onboarding data', () {
      const event = ChatStarted(
        profileType: ProfileType.optimizer,
        focusOptions: {FocusOption.mortgage},
        customOption: 'custom',
      );
      expect(event.profileType, ProfileType.optimizer);
      expect(event.focusOptions, {FocusOption.mortgage});
      expect(event.customOption, 'custom');
    });

    test('$ChatMessageSent holds text', () {
      const event = ChatMessageSent('hello');
      expect(event.text, 'hello');
    });

    test('$ChatSurfaceReceived holds surfaceId', () {
      const event = ChatSurfaceReceived('surface_1');
      expect(event.surfaceId, 'surface_1');
    });

    test('$ChatContentReceived holds message', () {
      const event = ChatContentReceived(AiTextDisplayMessage('hi'));
      expect(event.message, isA<AiTextDisplayMessage>());
    });

    test('$ChatLoading holds isLoading', () {
      const event = ChatLoading(isLoading: true);
      expect(event.isLoading, isTrue);
    });

    test('$ChatErrorOccurred holds message', () {
      const event = ChatErrorOccurred('fail');
      expect(event.message, 'fail');
    });
  });

  group(ChatBloc, () {
    test('initial state is {$ChatState()}', () {
      final bloc = _buildBloc();
      expect(bloc.state.status, ChatStatus.initial);
      expect(bloc.state.pages, isEmpty);
      expect(bloc.state.isLoading, isFalse);
      addTearDown(bloc.close);
    });

    blocTest<ChatBloc, ChatState>(
      '$ChatStarted emits loading, then active with host',
      build: _buildBloc,
      act: (bloc) => bloc.add(_chatStarted),
      verify: (bloc) {
        expect(bloc.state.status, ChatStatus.active);
        expect(bloc.state.host, isNotNull);
      },
    );

    blocTest<ChatBloc, ChatState>(
      '$ChatSurfaceReceived creates a new page for a new surface',
      build: _buildBloc,
      act: (bloc) => bloc.add(const ChatSurfaceReceived('surface_1')),
      expect: () => [
        isA<ChatState>()
            .having((s) => s.pages, 'pages', hasLength(1))
            .having((s) => s.pages.first, 'first page', hasLength(1))
            .having((s) => s.currentPageIndex, 'currentPageIndex', 0),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      '$ChatSurfaceReceived stays on existing page for known surface',
      build: _buildBloc,
      seed: () => const ChatState(
        pages: [
          [AiSurfaceDisplayMessage('surface_1')],
          [AiSurfaceDisplayMessage('surface_2')],
        ],
        currentPageIndex: 1,
      ),
      act: (bloc) => bloc.add(const ChatSurfaceReceived('surface_1')),
      expect: () => [
        isA<ChatState>()
            .having((s) => s.pages, 'pages', hasLength(2))
            .having((s) => s.currentPageIndex, 'currentPageIndex', 0),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      '$ChatContentReceived appends message to current page',
      build: _buildBloc,
      seed: () => const ChatState(
        pages: [[]],
      ),
      act: (bloc) =>
          bloc.add(const ChatContentReceived(AiTextDisplayMessage('hi'))),
      expect: () => [
        isA<ChatState>().having(
          (s) => s.pages.first,
          'first page',
          hasLength(1),
        ),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      '$ChatContentReceived creates a page if none exist',
      build: _buildBloc,
      act: (bloc) =>
          bloc.add(const ChatContentReceived(AiTextDisplayMessage('hi'))),
      expect: () => [
        isA<ChatState>()
            .having((s) => s.pages, 'pages', hasLength(1))
            .having((s) => s.pages.first, 'first page', hasLength(1)),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      '$ChatLoading emits state with isLoading',
      build: _buildBloc,
      act: (bloc) => bloc.add(const ChatLoading(isLoading: true)),
      expect: () => [
        isA<ChatState>().having((s) => s.isLoading, 'isLoading', isTrue),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      '$ChatErrorOccurred emits error status with message',
      build: _buildBloc,
      act: (bloc) => bloc.add(const ChatErrorOccurred('something failed')),
      expect: () => [
        isA<ChatState>()
            .having((s) => s.status, 'status', ChatStatus.error)
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
