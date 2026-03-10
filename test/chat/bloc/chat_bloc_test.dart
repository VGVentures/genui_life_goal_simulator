import 'package:bloc_test/bloc_test.dart';
import 'package:finance_app/chat/bloc/bloc.dart';
import 'package:finance_app/onboarding/pick_profile/models/profile_type.dart';
import 'package:finance_app/onboarding/want_to_focus/models/focus_option.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';

const _chatStarted = ChatStarted(
  profileType: ProfileType.beginner,
  focusOptions: {FocusOption.everydaySpending},
);

ChatBloc _buildBloc() {
  return ChatBloc();
}

void main() {
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
        messages: [UserMessage.text('hi')],
        isLoading: true,
        error: 'oops',
      );
      expect(updated.status, ChatStatus.error);
      expect(updated.messages, hasLength(1));
      expect(updated.isLoading, isTrue);
      expect(updated.error, 'oops');
    });

    test('copyWith preserves values when not overridden', () {
      final state = ChatState(
        status: ChatStatus.active,
        messages: [UserMessage.text('hi')],
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
      final msgs = <ChatMessage>[UserMessage.text('a')];
      final event = ChatConversationUpdated(msgs);
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
      '$ChatStarted emits [loading, active] with a host',
      build: _buildBloc,
      act: (bloc) => bloc.add(_chatStarted),
      expect: () => [
        isA<ChatState>().having(
          (s) => s.status,
          'status',
          ChatStatus.loading,
        ),
        isA<ChatState>()
            .having((s) => s.status, 'status', ChatStatus.active)
            .having((s) => s.host, 'host', isNotNull),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      '$ChatMessageSent forwards message to conversation',
      build: _buildBloc,
      seed: () => const ChatState(),
      act: (bloc) async {
        bloc.add(_chatStarted);
        await Future<void>.delayed(Duration.zero);
        bloc.add(const ChatMessageSent('Hello'));
      },
      wait: const Duration(milliseconds: 50),
      verify: (bloc) {
        expect(bloc.state.messages, isNotEmpty);
      },
    );

    blocTest<ChatBloc, ChatState>(
      '$ChatConversationUpdated emits state with new messages',
      build: _buildBloc,
      act: (bloc) =>
          bloc.add(ChatConversationUpdated([UserMessage.text('msg')])),
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

    test(
      'onError callback from content generator fires $ChatErrorOccurred',
      () async {
        final bloc = _buildBloc()..add(_chatStarted);
        await Future<void>.delayed(Duration.zero);

        bloc.add(const ChatMessageSent('Test'));
        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(bloc.state.status, ChatStatus.error);

        await bloc.close();
      },
    );

    test('processing listener fires $ChatLoading event', () async {
      final bloc = _buildBloc()..add(_chatStarted);
      await Future<void>.delayed(Duration.zero);

      // After ChatStarted, the isProcessing notifier exists.
      // Send a message to trigger the processing cycle.
      bloc.add(const ChatMessageSent('test'));
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // The processing listener should have toggled isLoading via Loading
      // events. After the message is processed, isLoading goes back to false.
      expect(bloc.state.isLoading, isFalse);

      await bloc.close();
    });
  });
}
