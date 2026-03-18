import 'dart:async';
import 'dart:convert';

import 'package:dartantic_firebase_ai/dartantic_firebase_ai.dart';
import 'package:genui/genui.dart';
import 'package:vgv_genui_financial_advisor/advisor/catalog/catalog.dart';
import 'package:vgv_genui_financial_advisor/advisor/prompt/prompt.dart'
    as app_prompt;
import 'package:vgv_genui_financial_advisor/advisor/repository/advisor_conversation_event.dart';

/// {@template advisor_repository}
/// Repository that manages the AI financial advisor conversation.
///
/// Hides the GenUI plumbing (catalog, controller, transport adapter) and
/// the Firebase AI chat model behind a simple API: [startConversation] and
/// [sendMessage].
/// {@endtemplate}
class AdvisorRepository {
  /// {@macro advisor_repository}
  AdvisorRepository({required FirebaseAIChatModel chatModel})
    : _chatModel = chatModel;

  final FirebaseAIChatModel _chatModel;
  Conversation? _conversation;
  StreamSubscription<ConversationEvent>? _eventSubscription;
  final List<ChatMessage> _history = [];
  late String _systemPrompt;

  final _controller = StreamController<AdvisorConversationEvent>.broadcast();

  /// Stream of conversation events (text, surfaces, errors, waiting state).
  Stream<AdvisorConversationEvent> get events => _controller.stream;

  /// The [SurfaceHost] for rendering GenUI surfaces in the presentation layer.
  ///
  /// Only available after [startConversation] has been called.
  SurfaceHost? get surfaceHost => _conversation?.controller;

  /// Starts a new conversation with the AI advisor.
  ///
  /// Call [sendMessage] afterwards to send the initial user message.
  Future<void> startConversation() async {
    final catalog = buildFinanceCatalog();

    final genUiPromptBuilder = PromptBuilder.chat(
      catalog: catalog,
      systemPromptFragments: [
        app_prompt.PromptBuilder.buildSystemPrompt(),
      ],
    );
    _systemPrompt = genUiPromptBuilder.systemPromptJoined();

    final controller = SurfaceController(catalogs: [catalog]);

    final adapter = A2uiTransportAdapter(onSend: _handleSend);

    _conversation = Conversation(
      controller: controller,
      transport: adapter,
    );

    _eventSubscription = _conversation!.events.listen((event) {
      switch (event) {
        case ConversationWaiting():
          _controller.add(const AdvisorConversationWaiting(isWaiting: true));
        case ConversationContentReceived(:final text):
          _controller.add(AdvisorConversationTextReceived(text));
        case ConversationSurfaceAdded(:final surfaceId):
          _controller.add(AdvisorConversationSurfaceAdded(surfaceId));
        case ConversationError(:final error):
          _controller.add(AdvisorConversationError(error.toString()));
        case _:
          break;
      }
    });

    _conversation!.state.addListener(_onStateChanged);
  }

  /// Sends a user message to the ongoing conversation.
  Future<void> sendMessage(String text) async {
    await _conversation?.sendRequest(ChatMessage.user(text));
  }

  void _onStateChanged() {
    _controller.add(
      AdvisorConversationWaiting(
        isWaiting: _conversation!.state.value.isWaiting,
      ),
    );
  }

  Future<void> _handleSend(ChatMessage message) async {
    _history.add(_convertDataPartsToText(message));

    final messages = [
      ChatMessage.system(_systemPrompt),
      ..._history,
    ];

    final adapter = _conversation!.transport as A2uiTransportAdapter;
    final buffer = StringBuffer();

    await for (final result in _chatModel.sendStream(messages)) {
      final text = result.output.text;
      if (text.isNotEmpty) {
        buffer.write(text);
        adapter.addChunk(text);
      }
    }

    _history.add(ChatMessage.model(buffer.toString()));
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
