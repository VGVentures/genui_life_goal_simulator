import 'dart:async';
import 'dart:convert';

import 'package:dartantic_ai/dartantic_ai.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/error_reporting/error_reporting.dart';
import 'package:genui_life_goal_simulator/simulator/prompt/prompt.dart'
    as app_prompt;
import 'package:genui_life_goal_simulator/simulator/repository/simulator_conversation_event.dart';

/// {@template simulator_repository}
/// Repository that manages the AI life goal simulator conversation.
///
/// Wraps the Firebase AI chat model and GenUI transport behind a simple API:
/// [startConversation] and [sendMessage].
///
/// The [Catalog] and [SurfaceController] are created by the presentation layer
/// and passed in — the repository uses them for prompt building and
/// conversation wiring, but does not own them.
/// {@endtemplate}
class SimulatorRepository {
  /// {@macro simulator_repository}
  SimulatorRepository({
    required ChatModel chatModel,
    required ErrorReportingRepository errorReporting,
    required Catalog catalog,
    required SurfaceController surfaceController,
  }) : _chatModel = chatModel,
       _errorReporting = errorReporting,
       _catalog = catalog,
       _surfaceController = surfaceController;

  final ChatModel _chatModel;
  final ErrorReportingRepository _errorReporting;
  final Catalog _catalog;
  final SurfaceController _surfaceController;
  Conversation? _conversation;
  StreamSubscription<ConversationEvent>? _eventSubscription;
  final List<ChatMessage> _history = [];
  late String _systemPrompt;

  /// The current step index for history tracking.
  ///
  /// Set this when navigating between steps so that [_handleSend] can
  /// truncate stale future history entries when continuing from a revisited
  /// step.
  int currentStep = 0;

  final _controller = StreamController<SimulatorConversationEvent>.broadcast();

  /// Stream of conversation events (text, surfaces, errors, waiting state).
  Stream<SimulatorConversationEvent> get events => _controller.stream;

  /// Starts a new conversation with the AI life goal simulator.
  ///
  /// Call [sendMessage] afterwards to send the initial user message.
  Future<void> startConversation() async {
    final genUiPromptBuilder = PromptBuilder.chat(
      catalog: _catalog,
      systemPromptFragments: [
        app_prompt.PromptBuilder.buildSystemPrompt(),
      ],
    );
    _systemPrompt = genUiPromptBuilder.systemPromptJoined();

    final adapter = A2uiTransportAdapter(onSend: _handleSend);

    _conversation = Conversation(
      controller: _surfaceController,
      transport: adapter,
    );

    _eventSubscription = _conversation!.events.listen(
      (event) {
        switch (event) {
          case ConversationWaiting():
            _controller.add(
              const SimulatorConversationWaiting(isWaiting: true),
            );
          case ConversationContentReceived(:final text):
            _controller.add(SimulatorConversationTextReceived(text));
          case ConversationSurfaceAdded(:final surfaceId):
            _controller.add(SimulatorConversationSurfaceAdded(surfaceId));
          case ConversationError(:final error):
            unawaited(
              _errorReporting.recordError(error, null, reason: 'GenUI error'),
            );
            _controller.add(SimulatorConversationError(error.toString()));
          case _:
            break;
        }
      },
      onError: (Object error, StackTrace st) {
        unawaited(
          _errorReporting.recordError(error, st, reason: 'GenUI stream error'),
        );
        _controller.add(SimulatorConversationError('Stream error: $error'));
      },
    );

    _conversation!.state.addListener(_onStateChanged);
  }

  /// Sends a user message to the ongoing conversation.
  Future<void> sendMessage(String text) async {
    await _conversation?.sendRequest(ChatMessage.user(text));
  }

  void _onStateChanged() {
    _controller.add(
      SimulatorConversationWaiting(
        isWaiting: _conversation!.state.value.isWaiting,
      ),
    );
  }

  Future<void> _handleSend(ChatMessage message) async {
    // If continuing from a revisited step, truncate future history so the
    // LLM only sees the conversation up to the current step.
    final expectedLength = (currentStep + 1) * 2;
    if (_history.length > expectedLength) {
      _history.removeRange(expectedLength, _history.length);
    }

    _history.add(_convertDataPartsToText(message));

    final messages = [
      ChatMessage.system(_systemPrompt),
      ..._history,
    ];

    final adapter = _conversation!.transport as A2uiTransportAdapter;
    final buffer = StringBuffer();

    try {
      await for (final result in _chatModel.sendStream(messages)) {
        final text = result.output.text;
        if (text.isNotEmpty) {
          buffer.write(text);
          adapter.addChunk(text);
        }
      }
      _history.add(ChatMessage.model(buffer.toString()));
    } on Object catch (e, st) {
      // Save whatever was streamed so retry has full context.
      if (buffer.isNotEmpty) {
        _history.add(ChatMessage.model(buffer.toString()));
      }
      await _errorReporting.recordError(e, st, reason: 'AI sendStream error');
      _controller.add(SimulatorConversationError('AI error: $e'));
    }
  }

  ChatMessage _convertDataPartsToText(ChatMessage message) {
    final hasDataParts = message.parts.any((p) => p is DataPart);
    if (!hasDataParts) return message;

    final converted = [
      for (final part in message.parts)
        if (part is DataPart) TextPart(utf8.decode(part.bytes)) else part,
    ];

    return ChatMessage(role: message.role, parts: converted);
  }

  /// Disposes all resources held by this repository.
  Future<void> dispose() async {
    await _eventSubscription?.cancel();
    _conversation?.state.removeListener(_onStateChanged);
    _conversation?.dispose();
    _chatModel.dispose();
    await _controller.close();
  }
}
