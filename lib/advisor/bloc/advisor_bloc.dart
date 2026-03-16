import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dartantic_firebase_ai/dartantic_firebase_ai.dart';
import 'package:finance_app/advisor/catalog/catalog.dart';
import 'package:finance_app/advisor/prompt/prompt.dart' as app_prompt;
import 'package:finance_app/onboarding/pick_profile/models/profile_type.dart';
import 'package:finance_app/onboarding/want_to_focus/models/focus_option.dart';
import 'package:genui/genui.dart';

part 'advisor_event.dart';
part 'advisor_state.dart';

/// Factory for creating a [FirebaseAIChatModel].
typedef AdvisorModelFactory = FirebaseAIChatModel Function();

class AdvisorBloc extends Bloc<AdvisorEvent, AdvisorState> {
  AdvisorBloc({required AdvisorModelFactory chatModelFactory})
    : _chatModelFactory = chatModelFactory,
      super(const AdvisorState()) {
    on<AdvisorStarted>(_onStarted);
    on<AdvisorMessageSent>(_onMessageSent);
    on<AdvisorSurfaceReceived>(_onSurfaceReceived);
    on<AdvisorContentReceived>(_onContentReceived);
    on<AdvisorLoading>(_onLoading);
    on<AdvisorErrorOccurred>(_onErrorOccurred);
  }

  final AdvisorModelFactory _chatModelFactory;
  Conversation? _conversation;
  FirebaseAIChatModel? _chatModel;
  StreamSubscription<ConversationEvent>? _eventSubscription;
  late final List<ChatMessage> _history = [];
  late String _systemPrompt;

  Future<void> _onStarted(
    AdvisorStarted event,
    Emitter<AdvisorState> emit,
  ) async {
    emit(state.copyWith(status: AdvisorStatus.loading));

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
        case ConversationWaiting():
          add(const AdvisorLoading(isLoading: true));
        case ConversationContentReceived(:final text):
          add(AdvisorContentReceived(AiTextDisplayMessage(text)));
        case ConversationSurfaceAdded(:final surfaceId):
          add(AdvisorSurfaceReceived(surfaceId));
        case ConversationError(:final error):
          add(AdvisorErrorOccurred(error.toString()));
        case _:
          // ConversationComponentsUpdated: Surface widget auto-rebuilds.
          break;
      }
    });

    // Track waiting state changes
    _conversation!.state.addListener(_onStateChanged);

    emit(
      state.copyWith(
        status: AdvisorStatus.active,
        host: _conversation!.controller,
      ),
    );

    // Send the initial user message to kick off the conversation
    final initialMessage = app_prompt.PromptBuilder.buildInitialUserMessage(
      profileType: event.profileType,
      focusOptions: event.focusOptions,
      customOption: event.customOption,
    );
    await _conversation!.sendRequest(ChatMessage.user(initialMessage));
  }

  void _onStateChanged() {
    if (!isClosed) {
      add(AdvisorLoading(isLoading: _conversation!.state.value.isWaiting));
    }
  }

  Future<void> _handleSend(ChatMessage message) async {
    // GenUI encodes interaction events as DataParts with a custom MIME type
    // that the Gemini API doesn't support in inlineData. Convert them to
    // TextParts so the API accepts them.
    _history.add(_convertDataPartsToText(message));

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

  /// Converts any [DataPart]s in [message] to [TextPart]s by UTF-8 decoding
  /// the bytes. This is needed because the Gemini API rejects custom MIME
  /// types (like `application/vnd.genui.interaction+json`) in `inlineData`.
  ChatMessage _convertDataPartsToText(ChatMessage message) {
    final hasDataParts = message.parts.any((p) => p is DataPart);
    if (!hasDataParts) return message;

    final converted = [
      for (final part in message.parts)
        if (part is DataPart) TextPart(utf8.decode(part.bytes)) else part,
    ];

    return ChatMessage(role: message.role, parts: converted);
  }

  void _onSurfaceReceived(
    AdvisorSurfaceReceived event,
    Emitter<AdvisorState> emit,
  ) {
    // Check if this surface already exists on any page.
    final existingPageIndex = state.pages.indexWhere(
      (page) => page.any(
        (m) => m is AiSurfaceDisplayMessage && m.surfaceId == event.surfaceId,
      ),
    );

    if (existingPageIndex != -1) {
      // Surface already exists — stay on that page. The surface widget
      // auto-rebuilds via GenUI, so we just navigate back to it.
      emit(state.copyWith(currentPageIndex: existingPageIndex));
    } else {
      // New surface — create a new page with it.
      final message = AiSurfaceDisplayMessage(event.surfaceId);
      final pages = [
        ...state.pages,
        <DisplayMessage>[message],
      ];
      emit(state.copyWith(pages: pages, currentPageIndex: pages.length - 1));
    }
  }

  void _onContentReceived(
    AdvisorContentReceived event,
    Emitter<AdvisorState> emit,
  ) {
    // Ensure there's a page to append to.
    var pages = [...state.pages];
    var currentPageIndex = state.currentPageIndex;
    if (pages.isEmpty) {
      pages = [<DisplayMessage>[]];
      currentPageIndex = 0;
    }

    final currentPage = pages[currentPageIndex];
    final message = event.message;

    // Merge consecutive text messages into a single paragraph.
    if (message is AiTextDisplayMessage && currentPage.isNotEmpty) {
      final last = currentPage.last;
      if (last is AiTextDisplayMessage) {
        // Add a space if the two chunks would run together.
        final needsSpace =
            last.text.isNotEmpty &&
            message.text.isNotEmpty &&
            last.text[last.text.length - 1] != ' ' &&
            last.text[last.text.length - 1] != '\n' &&
            message.text[0] != ' ' &&
            message.text[0] != '\n';
        final separator = needsSpace ? ' ' : '';
        final merged = AiTextDisplayMessage(
          last.text + separator + message.text,
        );
        pages = [
          for (var i = 0; i < pages.length; i++)
            if (i == currentPageIndex)
              [...currentPage.sublist(0, currentPage.length - 1), merged]
            else
              pages[i],
        ];
        emit(state.copyWith(pages: pages, currentPageIndex: currentPageIndex));
        return;
      }
    }

    pages = [
      for (var i = 0; i < pages.length; i++)
        if (i == currentPageIndex) [...currentPage, message] else pages[i],
    ];
    emit(state.copyWith(pages: pages, currentPageIndex: currentPageIndex));
  }

  void _onLoading(
    AdvisorLoading event,
    Emitter<AdvisorState> emit,
  ) {
    emit(state.copyWith(isLoading: event.isLoading));
  }

  Future<void> _onMessageSent(
    AdvisorMessageSent event,
    Emitter<AdvisorState> emit,
  ) async {
    await _conversation?.sendRequest(ChatMessage.user(event.text));
  }

  void _onErrorOccurred(
    AdvisorErrorOccurred event,
    Emitter<AdvisorState> emit,
  ) {
    emit(state.copyWith(status: AdvisorStatus.error, error: event.message));
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
