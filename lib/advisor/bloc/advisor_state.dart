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

/// {@template advisor_state}
/// State for the advisor bloc.
/// {@endtemplate}
final class AdvisorState {
  /// {@macro advisor_state}
  const AdvisorState({
    this.status = AdvisorStatus.initial,
    this.pages = const [],
    this.currentPageIndex = 0,
    this.isLoading = false,
    this.host,
    this.error,
  });

  final AdvisorStatus status;

  /// Each page is a list of display messages shown on one full-screen step.
  final List<List<DisplayMessage>> pages;

  /// The index of the page currently being built by the AI.
  final int currentPageIndex;

  final bool isLoading;
  final SurfaceHost? host;
  final String? error;

  AdvisorState copyWith({
    AdvisorStatus? status,
    List<List<DisplayMessage>>? pages,
    int? currentPageIndex,
    bool? isLoading,
    SurfaceHost? host,
    String? error,
  }) {
    return AdvisorState(
      status: status ?? this.status,
      pages: pages ?? this.pages,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isLoading: isLoading ?? this.isLoading,
      host: host ?? this.host,
      error: error ?? this.error,
    );
  }
}

enum AdvisorStatus { initial, loading, active, error }
