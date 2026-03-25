import 'package:genui/genui.dart';

/// A message to display in the chat UI.
sealed class DisplayMessage {
  const DisplayMessage();
}

/// A message sent by the user.
final class UserDisplayMessage extends DisplayMessage {
  const UserDisplayMessage(this.text);

  final String text;
}

/// A text response from the AI.
final class AiTextDisplayMessage extends DisplayMessage {
  const AiTextDisplayMessage(this.text);

  final String text;
}

/// An AI-generated UI surface.
final class AiSurfaceDisplayMessage extends DisplayMessage {
  const AiSurfaceDisplayMessage(this.surfaceId);

  final String surfaceId;
}

/// {@template simulator_state}
/// State for the simulator bloc.
/// {@endtemplate}
final class SimulatorState {
  /// {@macro simulator_state}
  const SimulatorState({
    this.status = SimulatorStatus.initial,
    this.pages = const [],
    this.currentPageIndex = 0,
    this.isLoading = false,
    this.hasPendingNavigation = false,
    this.showLoadingOverlay = false,
    this.host,
    this.error,
  });

  final SimulatorStatus status;

  /// Each page is a list of display messages shown on one full-screen step.
  final List<List<DisplayMessage>> pages;

  /// The index of the page currently being built by the AI.
  final int currentPageIndex;

  /// Whether the LLM is currently processing a request.
  final bool isLoading;

  /// Whether a new surface has been received but navigation has been deferred
  /// until the LLM finishes loading. This keeps the current page visible
  /// (with its button's thinking animation) while the next page's content is
  /// being generated. The view uses this to show the outer thinking animation
  /// during the initial load.
  final bool hasPendingNavigation;

  /// Whether the full-screen loading overlay with the large Rive animation
  /// should be shown. Set to `true` when an AppButton with
  /// `showLoadingOverlay` is pressed, and cleared when the pending navigation
  /// completes.
  final bool showLoadingOverlay;

  final SurfaceHost? host;
  final String? error;

  SimulatorState copyWith({
    SimulatorStatus? status,
    List<List<DisplayMessage>>? pages,
    int? currentPageIndex,
    bool? isLoading,
    bool? hasPendingNavigation,
    bool? showLoadingOverlay,
    SurfaceHost? host,
    String? error,
  }) {
    return SimulatorState(
      status: status ?? this.status,
      pages: pages ?? this.pages,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isLoading: isLoading ?? this.isLoading,
      hasPendingNavigation: hasPendingNavigation ?? this.hasPendingNavigation,
      showLoadingOverlay: showLoadingOverlay ?? this.showLoadingOverlay,
      host: host ?? this.host,
      error: error ?? this.error,
    );
  }
}

enum SimulatorStatus { initial, loading, active, error }
