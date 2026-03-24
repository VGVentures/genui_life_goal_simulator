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
    this.host,
    this.error,
  });

  final SimulatorStatus status;

  /// Each page is a list of display messages shown on one full-screen step.
  final List<List<DisplayMessage>> pages;

  /// The index of the page currently being built by the AI.
  final int currentPageIndex;

  final bool isLoading;
  final SurfaceHost? host;
  final String? error;

  SimulatorState copyWith({
    SimulatorStatus? status,
    List<List<DisplayMessage>>? pages,
    int? currentPageIndex,
    bool? isLoading,
    SurfaceHost? host,
    String? error,
  }) {
    return SimulatorState(
      status: status ?? this.status,
      pages: pages ?? this.pages,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isLoading: isLoading ?? this.isLoading,
      host: host ?? this.host,
      error: error ?? this.error,
    );
  }
}

enum SimulatorStatus { initial, loading, active, error }
