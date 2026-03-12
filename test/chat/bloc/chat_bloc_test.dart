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
      expect(state.messages, isEmpty);
      expect(state.isLoading, isFalse);
      expect(state.host, isNull);
      expect(state.error, isNull);
    });

    test('copyWith returns new instance with overridden values', () {
      const state = ChatState();
      final updated = state.copyWith(
        status: ChatStatus.error,
        messages: [const UserDisplayMessage('hi')],
        isLoading: true,
        error: 'oops',
      );
      expect(updated.status, ChatStatus.error);
      expect(updated.messages, hasLength(1));
      expect(updated.isLoading, isTrue);
      expect(updated.error, 'oops');
    });

    test('copyWith preserves values when not overridden', () {
      const state = ChatState(
        status: ChatStatus.active,
        messages: [UserDisplayMessage('hi')],
        isLoading: true,
        error: 'err',
      );
      final copy = state.copyWith();
      expect(copy.status, ChatStatus.active);
      expect(copy.messages, hasLength(1));
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

    test('$ChatConversationUpdated holds messages', () {
      const msgs = <DisplayMessage>[UserDisplayMessage('a')];
      const event = ChatConversationUpdated(msgs);
      expect(event.messages, msgs);
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
      expect(bloc.state.messages, isEmpty);
      expect(bloc.state.isLoading, isFalse);
      addTearDown(bloc.close);
    });

    blocTest<ChatBloc, ChatState>(
      '$ChatStarted emits loading, then active with host and initial '
      'message',
      build: _buildBloc,
      act: (bloc) => bloc.add(_chatStarted),
      verify: (bloc) {
        expect(bloc.state.status, ChatStatus.active);
        expect(bloc.state.host, isNotNull);
        expect(bloc.state.messages, isNotEmpty);
        expect(bloc.state.messages.first, isA<UserDisplayMessage>());
      },
    );

    blocTest<ChatBloc, ChatState>(
      '$ChatConversationUpdated emits state with new messages',
      build: _buildBloc,
      act: (bloc) => bloc.add(
        const ChatConversationUpdated([UserDisplayMessage('msg')]),
      ),
      expect: () => [
        isA<ChatState>().having((s) => s.messages, 'messages', hasLength(1)),
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
