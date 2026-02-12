import 'package:bloc/bloc.dart';
import 'package:finance_app/advisor/catalog/catalog.dart';
import 'package:finance_app/advisor/prompt/prompt.dart';
import 'package:finance_app/financials/mock/mock_scenario.dart';
import 'package:genui/genui.dart';
import 'package:genui_firebase_ai/genui_firebase_ai.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState()) {
    on<ChatStarted>(_onStarted);
    on<ChatMessageSent>(_onMessageSent);
    on<ConversationUpdated>(_onConversationUpdated);
    on<Loading>(_onLoading);
    on<ErrorOccurred>(_onErrorOccurred);
  }

  GenUiConversation? _conversation;

  void _onStarted(
    ChatStarted event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(status: ChatStatus.loading));

    final catalog = buildFinanceCatalog();
    final prompt = PromptBuilder.build(event.scenario);

    final contentGenerator = FirebaseAiContentGenerator(
      catalog: catalog,
      systemInstruction: prompt,
    );

    final processor = A2uiMessageProcessor(catalogs: [catalog]);

    _conversation = GenUiConversation(
      contentGenerator: contentGenerator,
      a2uiMessageProcessor: processor,
      onError: (error) {
        if (!isClosed) add(ErrorOccurred(error.error.toString()));
      },
    );

    _conversation!.conversation.addListener(_onConversationChanged);
    _conversation!.isProcessing.addListener(_onProcessingChanged);

    emit(
      state.copyWith(
        status: ChatStatus.active,
        host: _conversation!.host,
      ),
    );
  }

  void _onConversationChanged() {
    if (!isClosed) {
      add(ConversationUpdated(_conversation!.conversation.value));
    }
  }

  void _onProcessingChanged() {
    if (!isClosed) {
      add(Loading(isLoading: _conversation!.isProcessing.value));
    }
  }

  void _onConversationUpdated(
    ConversationUpdated event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(messages: event.messages));
  }

  void _onLoading(
    Loading event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(isLoading: event.isLoading));
  }

  Future<void> _onMessageSent(
    ChatMessageSent event,
    Emitter<ChatState> emit,
  ) async {
    await _conversation?.sendRequest(UserMessage.text(event.text));
  }

  void _onErrorOccurred(
    ErrorOccurred event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(status: ChatStatus.error, error: event.message));
  }

  @override
  Future<void> close() {
    _conversation?.conversation.removeListener(_onConversationChanged);
    _conversation?.isProcessing.removeListener(_onProcessingChanged);
    _conversation?.dispose();
    return super.close();
  }
}
