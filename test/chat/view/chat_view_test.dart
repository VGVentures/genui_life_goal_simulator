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
    testWidgets('shows empty-state label when pages are empty', (
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
    });

    testWidgets('renders message bubbles in PageView when pages exist', (
      tester,
    ) async {
      final host = _MockSurfaceHost();
      when(() => bloc.state).thenReturn(
        ChatState(
          status: ChatStatus.active,
          pages: const [
            [AiTextDisplayMessage('Hello')],
          ],
          host: host,
        ),
      );
      await tester.pumpChatView(bloc);

      expect(find.byType(PageView), findsOneWidget);
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

    testWidgets('$ChatInputBar is not shown when status is not active', (
      tester,
    ) async {
      when(() => bloc.state).thenReturn(
        const ChatState(),
      );
      await tester.pumpChatView(bloc);

      expect(find.byType(ChatInputBar), findsNothing);
    });

    testWidgets('shows loading indicator on current page when loading', (
      tester,
    ) async {
      final host = _MockSurfaceHost();
      when(() => bloc.state).thenReturn(
        ChatState(
          status: ChatStatus.active,
          pages: const [[]],
          isLoading: true,
          host: host,
        ),
      );
      await tester.pumpChatView(bloc);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('rebuilds when pages change', (tester) async {
      final host = _MockSurfaceHost();
      whenListen(
        bloc,
        Stream.fromIterable([
          ChatState(
            status: ChatStatus.active,
            pages: const [
              [AiTextDisplayMessage('Hello')],
            ],
            host: host,
          ),
        ]),
        initialState: ChatState(status: ChatStatus.active, host: host),
      );

      await tester.pumpChatView(bloc);
      await tester.pump();

      expect(find.byType(ChatMessageBubble), findsOneWidget);
    });
  });
}
