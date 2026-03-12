import 'package:bloc_test/bloc_test.dart';
import 'package:finance_app/chat/bloc/bloc.dart';
import 'package:finance_app/chat/chat.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:mocktail/mocktail.dart';

class _MockChatBloc extends MockBloc<ChatEvent, ChatState>
    implements ChatBloc {}

class _MockSurfaceHost extends Mock implements SurfaceHost {}

extension on WidgetTester {
  Future<void> pumpChatView(ChatBloc bloc) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<ChatBloc>.value(
          value: bloc,
          child: const ChatView(),
        ),
      ),
    );
  }
}

void main() {
  late _MockChatBloc bloc;

  setUpAll(() {
    registerFallbackValue(const ChatMessageSent(''));
  });

  setUp(() {
    bloc = _MockChatBloc();
    when(() => bloc.state).thenReturn(const ChatState());
  });

  group(ChatView, () {
    testWidgets('shows empty-state label when messages are empty', (
      tester,
    ) async {
      await tester.pumpChatView(bloc);

      expect(find.text('Send a message to get started!'), findsOneWidget);
    });

    testWidgets('shows $ChatInputBar when active and not loading', (
      tester,
    ) async {
      when(() => bloc.state).thenReturn(
        const ChatState(status: ChatStatus.active),
      );
      await tester.pumpChatView(bloc);

      expect(find.byType(ChatInputBar), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows $CircularProgressIndicator when loading', (
      tester,
    ) async {
      when(() => bloc.state).thenReturn(
        const ChatState(status: ChatStatus.active, isLoading: true),
      );
      await tester.pumpChatView(bloc);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(ChatInputBar), findsNothing);
    });

    testWidgets('renders message bubbles when messages exist', (tester) async {
      final host = _MockSurfaceHost();
      when(() => bloc.state).thenReturn(
        ChatState(
          status: ChatStatus.active,
          messages: const [UserDisplayMessage('Hello')],
          host: host,
        ),
      );
      await tester.pumpChatView(bloc);

      expect(find.byType(ChatMessageBubble), findsOneWidget);
      expect(
        find.text('Send a message to get started!'),
        findsNothing,
      );
    });

    testWidgets('shows $AppBar', (tester) async {
      await tester.pumpChatView(bloc);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('$ChatInputBar onSend dispatches $ChatMessageSent', (
      tester,
    ) async {
      when(() => bloc.state).thenReturn(
        const ChatState(status: ChatStatus.active),
      );
      await tester.pumpChatView(bloc);

      await tester.enterText(find.byType(TextField), 'hi');
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pump();

      final captured = verify(() => bloc.add(captureAny())).captured;
      expect(captured, hasLength(1));
      expect(captured.first, isA<ChatMessageSent>());
      expect((captured.first as ChatMessageSent).text, 'hi');
    });

    testWidgets('$ChatInputBar is disabled when status is not active', (
      tester,
    ) async {
      when(() => bloc.state).thenReturn(
        const ChatState(),
      );
      await tester.pumpChatView(bloc);

      final inputBar = tester.widget<ChatInputBar>(
        find.byType(ChatInputBar),
      );
      expect(inputBar.enabled, isFalse);
    });

    testWidgets('messages buildWhen triggers rebuild on message change', (
      tester,
    ) async {
      final host = _MockSurfaceHost();
      whenListen(
        bloc,
        Stream.fromIterable([
          ChatState(
            status: ChatStatus.active,
            messages: const [UserDisplayMessage('Hello')],
            host: host,
          ),
        ]),
        initialState: ChatState(status: ChatStatus.active, host: host),
      );

      await tester.pumpChatView(bloc);
      await tester.pump();

      expect(find.byType(ChatMessageBubble), findsOneWidget);
    });

    testWidgets('bottom buildWhen triggers rebuild on loading change', (
      tester,
    ) async {
      whenListen(
        bloc,
        Stream.fromIterable([
          const ChatState(status: ChatStatus.active, isLoading: true),
        ]),
        initialState: const ChatState(status: ChatStatus.active),
      );

      await tester.pumpChatView(bloc);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
