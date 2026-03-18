import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:vgv_genui_financial_advisor/advisor/bloc/advisor_event.dart';
import 'package:vgv_genui_financial_advisor/advisor/bloc/advisor_state.dart';
import 'package:vgv_genui_financial_advisor/advisor/prompt/prompt.dart'
    as app_prompt;
import 'package:vgv_genui_financial_advisor/advisor/repository/advisor_conversation_event.dart';
import 'package:vgv_genui_financial_advisor/advisor/repository/advisor_repository.dart';

class AdvisorBloc extends Bloc<AdvisorEvent, AdvisorState> {
  AdvisorBloc({required AdvisorRepository advisorRepository})
    : _repository = advisorRepository,
      super(const AdvisorState()) {
    on<AdvisorStarted>(_onStarted);
    on<AdvisorMessageSent>(_onMessageSent);
    on<AdvisorSurfaceReceived>(_onSurfaceReceived);
    on<AdvisorContentReceived>(_onContentReceived);
    on<AdvisorLoading>(_onLoading);
    on<AdvisorErrorOccurred>(_onErrorOccurred);
  }

  final AdvisorRepository _repository;
  StreamSubscription<AdvisorConversationEvent>? _eventSubscription;

  Future<void> _onStarted(
    AdvisorStarted event,
    Emitter<AdvisorState> emit,
  ) async {
    emit(state.copyWith(status: AdvisorStatus.loading));

    _eventSubscription = _repository.events.listen((event) {
      if (isClosed) return;
      switch (event) {
        case AdvisorConversationWaiting(:final isWaiting):
          add(AdvisorLoading(isLoading: isWaiting));
        case AdvisorConversationTextReceived(:final text):
          add(AdvisorContentReceived(AiTextDisplayMessage(text)));
        case AdvisorConversationSurfaceAdded(:final surfaceId):
          add(AdvisorSurfaceReceived(surfaceId));
        case AdvisorConversationError(:final message):
          add(AdvisorErrorOccurred(message));
      }
    });

    await _repository.startConversation();

    emit(
      state.copyWith(
        status: AdvisorStatus.active,
        host: _repository.surfaceHost,
      ),
    );

    final initialMessage = app_prompt.PromptBuilder.buildInitialUserMessage(
      profileType: event.profileType,
      focusOptions: event.focusOptions,
      customOption: event.customOption,
    );
    await _repository.sendMessage(initialMessage);
  }

  void _onSurfaceReceived(
    AdvisorSurfaceReceived event,
    Emitter<AdvisorState> emit,
  ) {
    final existingPageIndex = state.pages.indexWhere(
      (page) => page.any(
        (m) => m is AiSurfaceDisplayMessage && m.surfaceId == event.surfaceId,
      ),
    );

    if (existingPageIndex != -1) {
      emit(state.copyWith(currentPageIndex: existingPageIndex));
    } else {
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
    var pages = [...state.pages];
    var currentPageIndex = state.currentPageIndex;
    if (pages.isEmpty) {
      pages = [<DisplayMessage>[]];
      currentPageIndex = 0;
    }

    final currentPage = pages[currentPageIndex];
    final message = event.message;

    if (message is AiTextDisplayMessage && currentPage.isNotEmpty) {
      final last = currentPage.last;
      if (last is AiTextDisplayMessage) {
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
    await _repository.sendMessage(event.text);
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
    await _repository.dispose();
    return super.close();
  }
}
