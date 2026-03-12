import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartantic_firebase_ai/dartantic_firebase_ai.dart';
import 'package:finance_app/advisor/catalog/catalog.dart';
import 'package:finance_app/advisor/prompt/prompt.dart' as app_prompt;
import 'package:finance_app/onboarding/pick_profile/models/profile_type.dart';
import 'package:finance_app/onboarding/want_to_focus/models/focus_option.dart';
import 'package:genui/genui.dart';

part 'chat_event.dart';
part 'chat_state.dart';

/// Factory for creating a [FirebaseAIChatModel].
typedef ChatModelFactory = FirebaseAIChatModel Function();

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({required ChatModelFactory chatModelFactory})
    : _chatModelFactory = chatModelFactory,
      super(const ChatState()) {
    on<ChatStarted>(_onStarted);
    on<ChatMessageSent>(_onMessageSent);
    on<ChatConversationUpdated>(_onConversationUpdated);
    on<ChatLoading>(_onLoading);
    on<ChatErrorOccurred>(_onErrorOccurred);
  }

  final ChatModelFactory _chatModelFactory;
  Conversation? _conversation;
  FirebaseAIChatModel? _chatModel;
  StreamSubscription<ConversationEvent>? _eventSubscription;
  late final List<ChatMessage> _history = [];
  late final List<DisplayMessage> _displayMessages = [];
  late String _systemPrompt;

  Future<void> _onStarted(
    ChatStarted event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(status: ChatStatus.loading));

    final catalog = buildFinanceCatalog();

    // Build the system prompt (persona + rules + A2UI schema)
    final genUiPromptBuilder = PromptBuilder.chat(
      catalog: catalog,
      systemPromptFragments: [
        app_prompt.PromptBuilder.buildSystemPrompt(),
      ],
    );
    _systemPrompt = genUiPromptBuilder.systemPromptJoined();

    // Create the engine
    final controller = SurfaceController(catalogs: [catalog]);

    // Create the Firebase AI chat model
    _chatModel = _chatModelFactory();

    // Create transport adapter with send callback
    final adapter = A2uiTransportAdapter(onSend: _handleSend);

    // Create conversation facade
    _conversation = Conversation(
      controller: controller,
      transport: adapter,
    );

    // Listen for conversation events
    _eventSubscription = _conversation!.events.listen((event) {
      if (isClosed) return;
      switch (event) {
        case ConversationContentReceived(:final text):
          _addDisplayMessage(AiTextDisplayMessage(text));
        case ConversationSurfaceAdded(:final surfaceId):
          _addDisplayMessage(AiSurfaceDisplayMessage(surfaceId));
        case ConversationError(:final error):
          add(ChatErrorOccurred(error.toString()));
        case ConversationWaiting():
          add(const ChatLoading(isLoading: true));
        case _:
          break;
      }
    });

    // Track waiting state changes
    _conversation!.state.addListener(_onStateChanged);

    emit(
      state.copyWith(
        status: ChatStatus.active,
        host: _conversation!.controller,
      ),
    );

    // Send the initial user message to kick off the conversation
    final initialMessage = app_prompt.PromptBuilder.buildInitialUserMessage(
      profileType: event.profileType,
      focusOptions: event.focusOptions,
      customOption: event.customOption,
    );
    _addDisplayMessage(UserDisplayMessage(initialMessage));
    await _conversation!.sendRequest(ChatMessage.user(initialMessage));
  }

  void _onStateChanged() {
    if (!isClosed) {
      add(ChatLoading(isLoading: _conversation!.state.value.isWaiting));
    }
  }

  void _addDisplayMessage(DisplayMessage message) {
    if (!isClosed) {
      _displayMessages.add(message);
      add(ChatConversationUpdated(List.of(_displayMessages)));
    }
  }

  Future<void> _handleSend(ChatMessage message) async {
    _history.add(message);

    final messages = [
      ChatMessage.system(_systemPrompt),
      ..._history,
    ];

    final adapter = _conversation!.transport as A2uiTransportAdapter;
    final buffer = StringBuffer();

    await for (final result in _chatModel!.sendStream(messages)) {
      final text = result.output.text;
      if (text.isNotEmpty) {
        buffer.write(text);
        adapter.addChunk(text);
      }
    }

    // Add AI response to history for future context
    _history.add(ChatMessage.model(buffer.toString()));
  }

  void _onConversationUpdated(
    ChatConversationUpdated event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(messages: event.messages));
  }

  void _onLoading(
    ChatLoading event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(isLoading: event.isLoading));
  }

  Future<void> _onMessageSent(
    ChatMessageSent event,
    Emitter<ChatState> emit,
  ) async {
    _addDisplayMessage(UserDisplayMessage(event.text));
    await _conversation?.sendRequest(ChatMessage.user(event.text));
  }

  void _onErrorOccurred(
    ChatErrorOccurred event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(status: ChatStatus.error, error: event.message));
  }

  @override
  Future<void> close() async {
    await _eventSubscription?.cancel();
    _conversation?.state.removeListener(_onStateChanged);
    _conversation?.dispose();
    _chatModel?.dispose();
    return super.close();
  }
}
