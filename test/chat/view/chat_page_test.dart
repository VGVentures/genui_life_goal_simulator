import 'package:bloc_test/bloc_test.dart';
import 'package:finance_app/chat/bloc/bloc.dart';
import 'package:finance_app/chat/chat.dart';
import 'package:finance_app/financials/mock/mock_scenario.dart';
import 'package:finance_app/financials/models/models.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockChatBloc extends MockBloc<ChatEvent, ChatState>
    implements ChatBloc {}

final _scenario = MockScenario(
  name: 'Test',
  description: 'desc',
  accounts: const [
    Account(
      id: 'a1',
      name: 'Checking',
      type: AccountType.depository,
      subtype: AccountSubtype.checking,
      mask: '0001',
      balance: Balance(current: 100, currencyCode: CurrencyCode.usd),
    ),
  ],
  transactions: [
    Transaction(
      id: 't1',
      accountId: 'a1',
      amount: 10,
      date: DateTime(2026),
      name: 'Test',
      category: TransactionCategory.foodAndDrink,
      paymentChannel: PaymentChannel.inStore,
    ),
  ],
);

void main() {
  group(ChatPage, () {
    test('is a $StatelessWidget and holds the scenario', () {
      final page = ChatPage(scenario: _scenario);

      expect(page, isA<StatelessWidget>());
      expect(page.scenario, _scenario);
    });

    testWidgets('provides $ChatBloc and renders $ChatView', (tester) async {
      final bloc = _MockChatBloc();
      when(() => bloc.state).thenReturn(const ChatState());

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChatPage(scenario: _scenario, chatBloc: bloc),
        ),
      );

      expect(find.byType(ChatView), findsOneWidget);
    });
  });
}
