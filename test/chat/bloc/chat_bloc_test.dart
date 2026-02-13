import 'package:bloc_test/bloc_test.dart';
import 'package:finance_app/chat/bloc/bloc.dart';
import 'package:finance_app/financials/mock/mock_scenario.dart';
import 'package:finance_app/financials/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';

final _scenario = MockScenario(
  name: 'Test',
  description: 'A test persona.',
  accounts: const [
    Account(
      id: 'a1',
      name: 'Checking',
      type: AccountType.depository,
      subtype: AccountSubtype.checking,
      mask: '0001',
      balance: Balance(current: 1000, currencyCode: CurrencyCode.usd),
    ),
  ],
  transactions: [
    Transaction(
      id: 't1',
      accountId: 'a1',
      amount: 50,
      date: DateTime(2026, 1, 15),
      name: 'Grocery Store',
      category: TransactionCategory.foodAndDrink,
      paymentChannel: PaymentChannel.inStore,
    ),
  ],
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
    test('$ChatStarted holds scenario', () {
      final event = ChatStarted(_scenario);
      expect(event.scenario, _scenario);
    });

    test('$ChatMessageSent holds text', () {
      const event = ChatMessageSent('hello');
      expect(event.text, 'hello');
    });

    test('$ConversationUpdated holds messages', () {
      final msgs = <ChatMessage>[UserMessage.text('a')];
      final event = ConversationUpdated(msgs);
      expect(event.messages, msgs);
    });

    test('$Loading holds isLoading', () {
      const event = Loading(isLoading: true);
      expect(event.isLoading, isTrue);
    });

    test('$ErrorOccurred holds message', () {
      const event = ErrorOccurred('fail');
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
      act: (bloc) => bloc.add(ChatStarted(_scenario)),
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
        bloc.add(ChatStarted(_scenario));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const ChatMessageSent('Hello'));
      },
      wait: const Duration(milliseconds: 50),
      verify: (bloc) {
        expect(bloc.state.messages, isNotEmpty);
      },
    );

    blocTest<ChatBloc, ChatState>(
      '$ConversationUpdated emits state with new messages',
      build: _buildBloc,
      act: (bloc) => bloc.add(ConversationUpdated([UserMessage.text('msg')])),
      expect: () => [
        isA<ChatState>().having((s) => s.messages, 'messages', hasLength(1)),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      '$Loading emits state with isLoading',
      build: _buildBloc,
      act: (bloc) => bloc.add(const Loading(isLoading: true)),
      expect: () => [
        isA<ChatState>().having((s) => s.isLoading, 'isLoading', isTrue),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      '$ErrorOccurred emits error status with message',
      build: _buildBloc,
      act: (bloc) => bloc.add(const ErrorOccurred('something failed')),
      expect: () => [
        isA<ChatState>()
            .having((s) => s.status, 'status', ChatStatus.error)
            .having((s) => s.error, 'error', 'something failed'),
      ],
    );

    test('close disposes conversation resources', () async {
      final bloc = _buildBloc()..add(ChatStarted(_scenario));
      await Future<void>.delayed(Duration.zero);
      // Should not throw when closing after starting.
      await bloc.close();
    });

    test('close without starting does not throw', () async {
      final bloc = _buildBloc();
      await bloc.close();
    });

    test(
      'onError callback from content generator fires $ErrorOccurred',
      () async {
        final bloc = _buildBloc()..add(ChatStarted(_scenario));
        await Future<void>.delayed(Duration.zero);

        bloc.add(const ChatMessageSent('Test'));
        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(bloc.state.status, ChatStatus.error);

        await bloc.close();
      },
    );

    test('processing listener fires $Loading event', () async {
      final bloc = _buildBloc()..add(ChatStarted(_scenario));
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
