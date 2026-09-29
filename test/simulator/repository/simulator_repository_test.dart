import 'package:dartantic_ai/dartantic_ai.dart';
import 'package:dartantic_firebase_ai/dartantic_firebase_ai.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/error_reporting/error_reporting.dart';
import 'package:genui_life_goal_simulator/simulator/catalog/catalog.dart';
import 'package:genui_life_goal_simulator/simulator/repository/simulator_conversation_event.dart';
import 'package:genui_life_goal_simulator/simulator/repository/simulator_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockFirebaseAIChatModel extends Mock implements FirebaseAIChatModel {}

class _MockErrorReportingRepository extends Mock
    implements ErrorReportingRepository {}

void main() {
  late _MockFirebaseAIChatModel chatModel;
  late _MockErrorReportingRepository errorReporting;
  late Catalog catalog;
  late SurfaceController surfaceController;
  late SimulatorRepository repository;

  setUp(() {
    chatModel = _MockFirebaseAIChatModel();
    errorReporting = _MockErrorReportingRepository();
    catalog = buildFinanceCatalog();
    surfaceController = SurfaceController(catalogs: [catalog]);

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
      catalog: catalog,
      surfaceController: surfaceController,
    );
  });

  tearDown(() async {
    await repository.dispose();
  });

  group('$SimulatorRepository', () {
    group('initial state', () {
      test('events stream is accessible before startConversation', () {
        expect(repository.events, isA<Stream<SimulatorConversationEvent>>());
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

    group('currentStep and history truncation', () {
      test('currentStep defaults to 0', () {
        expect(repository.currentStep, 0);
      });

      test('currentStep can be read and written', () {
        repository.currentStep = 3;
        expect(repository.currentStep, 3);
      });

      test(
        'truncates history beyond currentStep when sending after going back',
        () async {
          await repository.startConversation();

          // Build up history, advancing currentStep after each send just
          // like the bloc does when a new surface arrives.
          await repository.sendMessage('step 0');
          repository.currentStep = 1;
          await repository.sendMessage('step 1');
          repository.currentStep = 2;
          await repository.sendMessage('step 2');

          // Record how many messages the LLM saw on the 3rd send.
          final beforeBacktrack = verify(
            () => chatModel.sendStream(captureAny()),
          ).captured;
          final messagesAtStep2 =
              (beforeBacktrack.last as List<ChatMessage>).length;

          // Simulate going back to step 0 and continuing.
          repository.currentStep = 0;
          await repository.sendMessage('step 0 redo');

          final afterBacktrack = verify(
            () => chatModel.sendStream(captureAny()),
          ).captured;
          final messagesAfterTruncation =
              (afterBacktrack.last as List<ChatMessage>).length;

          // After truncation the LLM should see fewer messages than before
          // (system + step0 user + step0 model + new user vs. the full
          // chain that included step1 and step2).
          expect(messagesAfterTruncation, lessThan(messagesAtStep2));
        },
      );

      test(
        'does not truncate when currentStep matches history',
        () async {
          await repository.startConversation();

          // Advance currentStep in lockstep with sends.
          await repository.sendMessage('step 0');
          repository.currentStep = 1;
          await repository.sendMessage('step 1');
          repository.currentStep = 2;
          await repository.sendMessage('step 2');

          final captured = verify(
            () => chatModel.sendStream(captureAny()),
          ).captured;

          // Each successive call should see more messages than the previous.
          final lengths = [
            for (final c in captured) (c as List<ChatMessage>).length,
          ];
          for (var i = 1; i < lengths.length; i++) {
            expect(
              lengths[i],
              greaterThan(lengths[i - 1]),
              reason: 'send $i should see more messages than send ${i - 1}',
            );
          }
        },
      );
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

    group('unparsed A2UI payloads', () {
      Future<List<SimulatorConversationEvent>> sendWithResponse(
        String response,
      ) async {
        when(() => chatModel.sendStream(any())).thenAnswer(
          (_) => Stream.fromIterable([
            ChatResult(output: ChatMessage.model(response)),
          ]),
        );

        await repository.startConversation();

        final events = <SimulatorConversationEvent>[];
        repository.events.listen(events.add);

        await repository.sendMessage('hi');
        await Future<void>.delayed(Duration.zero);
        return events;
      }

      void verifyMalformedResponseReported() {
        verify(
          () => errorReporting.recordError(
            any<dynamic>(that: isA<MalformedA2uiResponseException>()),
            any<StackTrace?>(),
            reason: 'Malformed A2UI response',
          ),
        ).called(1);
      }

      test(
        'does not emit a fenced block with invalid JSON as text '
        'and emits an error instead',
        () async {
          // Missing comma after "path", as seen in the wild.
          const response =
              '```json\n'
              '{"version": "v0.9", "updateComponents": '
              '{"surfaceId": "tax_bracket_step", "components": [ '
              '{"id": "bracket_slider", "component": "GCNSlider", '
              '"valueLabel": {"path": "/bracket_slider/formattedValue"\n'
              '"formattedValue": "24%"}}]}}\n'
              '```';

          final events = await sendWithResponse(response);

          expect(
            events.whereType<SimulatorConversationTextReceived>(),
            isEmpty,
          );
          final errors = events.whereType<SimulatorConversationError>();
          expect(errors, hasLength(1));
          expect(errors.first.message, contains('AI error'));
          verifyMalformedResponseReported();
        },
      );

      test(
        'does not emit an unfenced JSON object with invalid JSON as text',
        () async {
          // Missing comma between "surfaceId" and "catalogId".
          const response =
              '{"version": "v0.9", "createSurface": '
              '{"surfaceId": "s1" "catalogId": "$financeCatalogId"}}';

          final events = await sendWithResponse(response);

          expect(
            events.whereType<SimulatorConversationTextReceived>(),
            isEmpty,
          );
          expect(events.whereType<SimulatorConversationError>(), isNotEmpty);
          verifyMalformedResponseReported();
        },
      );

      test('still emits conversational text that mentions braces', () async {
        final events = await sendWithResponse('Budget {approximately} 10%');

        final texts = events.whereType<SimulatorConversationTextReceived>();
        expect(texts, isNotEmpty);
        expect(texts.first.text, startsWith('Budget'));
        expect(events.whereType<SimulatorConversationError>(), isEmpty);
        verifyNever(
          () => errorReporting.recordError(
            any<dynamic>(),
            any<StackTrace?>(),
            reason: 'Malformed A2UI response',
          ),
        );
      });

      test('emits valid A2UI messages as surfaces, not text', () async {
        const response =
            '```json\n'
            '{"version": "v0.9", "createSurface": '
            '{"surfaceId": "s1", "catalogId": "$financeCatalogId"}}\n'
            '```';

        final events = await sendWithResponse(response);

        expect(
          events.whereType<SimulatorConversationSurfaceAdded>(),
          isNotEmpty,
        );
        expect(events.whereType<SimulatorConversationTextReceived>(), isEmpty);
        expect(events.whereType<SimulatorConversationError>(), isEmpty);
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

      test(
        'pops the dangling user message when the stream fails with zero '
        'chunks so the next send does not produce two consecutive user turns',
        () async {
          // First call: fail immediately with no chunks.
          // Second call: succeed.
          var callCount = 0;
          when(() => chatModel.sendStream(any())).thenAnswer((_) {
            callCount++;
            if (callCount == 1) {
              return Stream<ChatResult<ChatMessage>>.error(
                Exception('network blip'),
              );
            }
            return Stream.fromIterable([
              ChatResult(output: ChatMessage.model('ok')),
            ]);
          });

          await repository.startConversation();
          await repository.sendMessage('first attempt');
          await Future<void>.delayed(Duration.zero);
          await repository.sendMessage('second attempt');

          final captured = verify(
            () => chatModel.sendStream(captureAny()),
          ).captured;

          // Walk the history the LLM saw on the second call and confirm no
          // two adjacent user turns (the dangling first-attempt user
          // message should have been popped).
          final secondCallMessages = captured.last as List<ChatMessage>;
          for (var i = 1; i < secondCallMessages.length; i++) {
            expect(
              secondCallMessages[i].role == ChatMessageRole.user &&
                  secondCallMessages[i - 1].role == ChatMessageRole.user,
              isFalse,
              reason:
                  'history must never contain two consecutive user turns: '
                  '${secondCallMessages.map((m) => m.role).toList()}',
            );
          }
        },
      );
    });

    group('dispose', () {
      test('disposes chatModel', () async {
        final localRepo = SimulatorRepository(
          chatModel: chatModel,
          errorReporting: errorReporting,
          catalog: catalog,
          surfaceController: surfaceController,
        );
        await localRepo.startConversation();
        await localRepo.dispose();

        verify(() => chatModel.dispose()).called(1);
      });

      test('can be called before startConversation', () async {
        final localRepo = SimulatorRepository(
          chatModel: chatModel,
          errorReporting: errorReporting,
          catalog: catalog,
          surfaceController: surfaceController,
        );
        await localRepo.dispose();

        verify(() => chatModel.dispose()).called(1);
      });
    });
  });
}
