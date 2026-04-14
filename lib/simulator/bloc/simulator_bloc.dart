import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:genui_life_goal_simulator/simulator/bloc/simulator_event.dart';
import 'package:genui_life_goal_simulator/simulator/bloc/simulator_state.dart';
import 'package:genui_life_goal_simulator/simulator/prompt/prompt.dart'
    as app_prompt;
import 'package:genui_life_goal_simulator/simulator/repository/simulator_conversation_event.dart';
import 'package:genui_life_goal_simulator/simulator/repository/simulator_repository.dart';

class SimulatorBloc extends Bloc<SimulatorEvent, SimulatorState> {
  SimulatorBloc({required SimulatorRepository simulatorRepository})
    : _repository = simulatorRepository,
      super(const SimulatorState()) {
    on<SimulatorStarted>(_onStarted);
    on<SimulatorMessageSent>(_onMessageSent);
    on<SimulatorBackPressed>(_onBackPressed);
    on<SimulatorForwardPagesTruncated>(_onForwardPagesTruncated);
    on<SimulatorSurfaceReceived>(_onSurfaceReceived);
    on<SimulatorContentReceived>(_onContentReceived);
    on<SimulatorLoading>(_onLoading);
    on<SimulatorLoadingOverlayRequested>(_onLoadingOverlayRequested);
    on<SimulatorErrorOccurred>(_onErrorOccurred);
    on<SimulatorRetried>(_onRetried);
  }

  final SimulatorRepository _repository;
  StreamSubscription<SimulatorConversationEvent>? _eventSubscription;

  Future<void> _onStarted(
    SimulatorStarted event,
    Emitter<SimulatorState> emit,
  ) async {
    emit(state.copyWith(status: SimulatorStatus.loading));

    _eventSubscription = _repository.events.listen((event) {
      if (isClosed) return;
      switch (event) {
        case SimulatorConversationWaiting(:final isWaiting):
          add(SimulatorLoading(isLoading: isWaiting));
        case SimulatorConversationTextReceived(:final text):
          add(SimulatorContentReceived(AiTextDisplayMessage(text)));
        case SimulatorConversationSurfaceAdded(:final surfaceId):
          add(SimulatorSurfaceReceived(surfaceId));
        case SimulatorConversationError(:final message):
          add(SimulatorErrorOccurred(message));
      }
    });

    await _repository.startConversation();

    emit(state.copyWith(status: SimulatorStatus.active));

    final initialMessage = app_prompt.PromptBuilder.buildInitialUserMessage(
      profileType: event.profileType,
      focusOptions: event.focusOptions,
      customOption: event.customOption,
    );
    await _repository.sendMessage(initialMessage);
  }

  void _onBackPressed(
    SimulatorBackPressed event,
    Emitter<SimulatorState> emit,
  ) {
    if (state.currentPageIndex > 0) {
      final newIndex = state.currentPageIndex - 1;
      _repository.currentStep = newIndex;
      // Keep forward pages alive so the fade-out animation can play.
      // Buttons are disabled via isNavigatingBack until the animation
      // completes and SimulatorForwardPagesTruncated removes the pages.
      emit(
        state.copyWith(currentPageIndex: newIndex, isNavigatingBack: true),
      );
    }
  }

  void _onForwardPagesTruncated(
    SimulatorForwardPagesTruncated event,
    Emitter<SimulatorState> emit,
  ) {
    final pages = state.pages.sublist(0, state.currentPageIndex + 1);
    emit(state.copyWith(pages: pages, isNavigatingBack: false));
  }

  void _onSurfaceReceived(
    SimulatorSurfaceReceived event,
    Emitter<SimulatorState> emit,
  ) {
    final existingPageIndex = state.pages.indexWhere(
      (page) => page.any(
        (m) => m is AiSurfaceDisplayMessage && m.surfaceId == event.surfaceId,
      ),
    );

    if (existingPageIndex != -1) {
      _repository.currentStep = existingPageIndex;
      emit(
        state.copyWith(
          currentPageIndex: existingPageIndex,
          pendingPageIndex: clearPendingPageIndex,
          showLoadingOverlay: false,
        ),
      );
    } else {
      final message = AiSurfaceDisplayMessage(event.surfaceId);

      // If forward pages still exist (e.g. the back-animation truncation
      // hasn't fired yet), trim them before appending the new surface.
      final base = state.currentPageIndex < state.pages.length - 1
          ? state.pages.sublist(0, state.currentPageIndex + 1)
          : state.pages;

      final pages = [
        ...base,
        <DisplayMessage>[message],
      ];
      final newIndex = pages.length - 1;
      _repository.currentStep = newIndex;

      // Defer navigation until loading finishes so the current page
      // stays visible with the thinking animation until content is ready.
      if (state.isLoading) {
        emit(
          state.copyWith(
            pages: pages,
            pendingPageIndex: newIndex,
            isNavigatingBack: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            pages: pages,
            currentPageIndex: newIndex,
            pendingPageIndex: clearPendingPageIndex,
            showLoadingOverlay: false,
            isNavigatingBack: false,
          ),
        );
      }
    }
  }

  void _onContentReceived(
    SimulatorContentReceived event,
    Emitter<SimulatorState> emit,
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
    SimulatorLoading event,
    Emitter<SimulatorState> emit,
  ) {
    final withLoading = state.copyWith(isLoading: event.isLoading);
    emit(withLoading);

    // If loading just finished and there's a deferred page, navigate now.
    if (!event.isLoading && withLoading.hasPendingNavigation) {
      final pending = withLoading.pendingPageIndex;
      if (pending != null) {
        emit(
          withLoading.copyWith(
            currentPageIndex: pending,
            pendingPageIndex: clearPendingPageIndex,
            showLoadingOverlay: false,
          ),
        );
      }
    }
  }

  void _onLoadingOverlayRequested(
    SimulatorLoadingOverlayRequested event,
    Emitter<SimulatorState> emit,
  ) {
    emit(state.copyWith(showLoadingOverlay: true));
  }

  Future<void> _onMessageSent(
    SimulatorMessageSent event,
    Emitter<SimulatorState> emit,
  ) async {
    await _repository.sendMessage(event.text);
  }

  void _onErrorOccurred(
    SimulatorErrorOccurred event,
    Emitter<SimulatorState> emit,
  ) {
    emit(state.copyWith(status: SimulatorStatus.error, error: event.message));
  }

  Future<void> _onRetried(
    SimulatorRetried event,
    Emitter<SimulatorState> emit,
  ) async {
    // Find the last page with content
    final pages = state.pages;
    var lastGoodIndex = 0;
    for (var i = pages.length - 1; i >= 0; i--) {
      final hasContent = pages[i].any((m) => m is! AiSurfaceDisplayMessage);
      if (hasContent) {
        lastGoodIndex = i;
        break;
      }
    }

    emit(
      state.copyWith(
        status: SimulatorStatus.active,
        isLoading: true,
        currentPageIndex: lastGoodIndex,
        error: clearError,
      ),
    );
    await _repository.sendMessage('Please continue where you left off.');
  }

  @override
  Future<void> close() async {
    await _eventSubscription?.cancel();
    await _repository.dispose();
    return super.close();
  }
}
