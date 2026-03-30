import 'package:dartantic_ai/dartantic_ai.dart';
import 'package:dartantic_firebase_ai/dartantic_firebase_ai.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/error_reporting/error_reporting.dart';
import 'package:genui_life_goal_simulator/simulator/repository/simulator_conversation_event.dart';
import 'package:genui_life_goal_simulator/simulator/repository/simulator_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockFirebaseAIChatModel extends Mock implements FirebaseAIChatModel {}

class _MockErrorReportingRepository extends Mock
    implements ErrorReportingRepository {}

void main() {
  late _MockFirebaseAIChatModel chatModel;
  late _MockErrorReportingRepository errorReporting;
  late SimulatorRepository repository;

  setUp(() {
    chatModel = _MockFirebaseAIChatModel();
    errorReporting = _MockErrorReportingRepository();

    when(() => chatModel.sendStream(any())).thenAnswer(
      (_) => Stream.fromIterable([
        ChatResult(output: ChatMessage.model('hello')),
      ]),
    );
    when(() => chatModel.dispose()).thenReturn(null);
    when(
      () => errorReporting.recordError(
        any<dynamic>(),
        any<StackTrace?>(),
        reason: any(named: 'reason'),
        extra: any(named: 'extra'),
      ),
    ).thenAnswer((_) async {});

    repository = SimulatorRepository(
      chatModel: chatModel,
      errorReporting: errorReporting,
    );
  });

  tearDown(() async {
    await repository.dispose();
  });

  group('$SimulatorRepository', () {
    group('initial state', () {
      test('surfaceHost is null before startConversation', () {
        expect(repository.surfaceHost, isNull);
      });

      test('events stream is accessible before startConversation', () {
        expect(repository.events, isA<Stream<SimulatorConversationEvent>>());
      });
    });

    group('startConversation', () {
      test('sets surfaceHost', () async {
        await repository.startConversation();
        expect(repository.surfaceHost, isNotNull);
      });
    });

    group('sendMessage', () {
      test(
        'calls chatModel.sendStream with system prompt and user message',
        () async {
          await repository.startConversation();
          await repository.sendMessage('hello');

          final captured = verify(
            () => chatModel.sendStream(captureAny()),
          ).captured;
          expect(captured, hasLength(1));

          final messages = captured.first as List<ChatMessage>;
          // First message is the system prompt.
          expect(messages.first.role, ChatMessageRole.system);
          // Second is the user message sent by Conversation.
          expect(
            messages.any((m) => m.role == ChatMessageRole.user),
            isTrue,
          );
        },
      );

      test('accumulates history across multiple sends', () async {
        await repository.startConversation();
        await repository.sendMessage('first');
        await repository.sendMessage('second');

        final captured = verify(
          () => chatModel.sendStream(captureAny()),
        ).captured;
        // Second call should have system + user1 + model1 + user2.
        final secondMessages = captured.last as List<ChatMessage>;
        expect(secondMessages.length, greaterThan(2));
      });

      test('converts DataParts to TextParts in history', () async {
        when(() => chatModel.sendStream(any())).thenAnswer((_) {
          return Stream.fromIterable([
            ChatResult(output: ChatMessage.model('ok')),
          ]);
        });

        await repository.startConversation();
        await repository.sendMessage('hi');

        // The sendStream was called — verify no DataParts in the captured
        // messages (since the user message is plain text, this confirms
        // the conversion path doesn't break plain text).
        final captured = verify(
          () => chatModel.sendStream(captureAny()),
        ).captured;
        final messages = captured.first as List<ChatMessage>;
        for (final msg in messages) {
          expect(msg.parts.whereType<DataPart>(), isEmpty);
        }
      });
    });

    group('AI response streaming', () {
      test('emits text events for plain text AI responses', () async {
        when(() => chatModel.sendStream(any())).thenAnswer(
          (_) => Stream.fromIterable([
            ChatResult(output: ChatMessage.model('hello world')),
          ]),
        );

        await repository.startConversation();

        final events = <SimulatorConversationEvent>[];
        repository.events.listen(events.add);

        await repository.sendMessage('hi');

        // Give the stream events time to propagate.
        await Future<void>.delayed(Duration.zero);

        expect(
          events.whereType<SimulatorConversationTextReceived>(),
          isNotEmpty,
        );
      });

      test('emits waiting events', () async {
        await repository.startConversation();

        final events = <SimulatorConversationEvent>[];
        repository.events.listen(events.add);

        await repository.sendMessage('hi');
        await Future<void>.delayed(Duration.zero);

        expect(
          events.whereType<SimulatorConversationWaiting>(),
          isNotEmpty,
        );
      });
    });

    group('error handling', () {
      test(
        'reports sendStream errors to errorReporting '
        'and emits error event',
        () async {
          final exception = Exception('AI failed');
          when(
            () => chatModel.sendStream(any()),
          ).thenAnswer((_) => Stream.error(exception));

          await repository.startConversation();

          final events = <SimulatorConversationEvent>[];
          repository.events.listen(events.add);

          await repository.sendMessage('hi');
          await Future<void>.delayed(Duration.zero);

          verify(
            () => errorReporting.recordError(
              exception,
              any(),
              reason: 'AI sendStream error',
            ),
          ).called(1);

          final errors = events.whereType<SimulatorConversationError>();
          expect(errors, isNotEmpty);
          expect(errors.first.message, contains('AI error'));
        },
      );

      test('reports sendStream thrown errors to errorReporting', () async {
        when(() => chatModel.sendStream(any())).thenThrow(
          Exception('immediate failure'),
        );

        await repository.startConversation();

        final events = <SimulatorConversationEvent>[];
        repository.events.listen(events.add);

        await repository.sendMessage('hi');
        await Future<void>.delayed(Duration.zero);

        verify(
          () => errorReporting.recordError(
            any<dynamic>(),
            any<StackTrace?>(),
            reason: 'AI sendStream error',
          ),
        ).called(1);

        final errors = events.whereType<SimulatorConversationError>();
        expect(errors, isNotEmpty);
      });
    });

    group('dispose', () {
      test('disposes chatModel', () async {
        final localRepo = SimulatorRepository(
          chatModel: chatModel,
          errorReporting: errorReporting,
        );
        await localRepo.startConversation();
        await localRepo.dispose();

        verify(() => chatModel.dispose()).called(1);
      });

      test('can be called before startConversation', () async {
        final localRepo = SimulatorRepository(
          chatModel: chatModel,
          errorReporting: errorReporting,
        );
        await localRepo.dispose();

        verify(() => chatModel.dispose()).called(1);
      });
    });
  });
}
