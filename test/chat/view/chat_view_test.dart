import 'package:bloc_test/bloc_test.dart';
import 'package:finance_app/chat/bloc/bloc.dart';
import 'package:finance_app/chat/chat.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:finance_app/onboarding/pick_profile/models/profile_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:mocktail/mocktail.dart';

class _MockChatBloc extends MockBloc<ChatEvent, ChatState>
    implements ChatBloc {}

class _MockSurfaceHost extends Mock implements SurfaceHost {}

const _testSurfaceSize = Size(1200, 800);

extension on WidgetTester {
  Future<void> pumpChatView(ChatBloc bloc) async {
    view.physicalSize = _testSurfaceSize;
    view.devicePixelRatio = 1.0;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<ChatBloc>.value(
          value: bloc,
          child: const ChatView(profileType: ProfileType.optimizer),
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
    testWidgets('shows loading indicator when pages are empty', (
      tester,
    ) async {
      await tester.pumpChatView(bloc);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
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
      // Loading spinner should not be shown when pages exist
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows app bar with logo and profile chip', (tester) async {
      await tester.pumpChatView(bloc);
      expect(find.textContaining('VGV'), findsOneWidget);
      expect(find.text('The Optimizer'), findsOneWidget);
      expect(find.text('Restart Demo'), findsOneWidget);
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
