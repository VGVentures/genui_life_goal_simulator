part of 'chat_bloc.dart';

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
/// State for the [ChatBloc].
/// {@endtemplate}
final class ChatState {
  /// {@macro advisor_state}
  const ChatState({
    this.status = ChatStatus.initial,
    this.pages = const [],
    this.currentPageIndex = 0,
    this.isLoading = false,
    this.host,
    this.error,
  });

  final ChatStatus status;

  /// Each page is a list of display messages shown on one full-screen step.
  final List<List<DisplayMessage>> pages;

  /// The index of the page currently being built by the AI.
  final int currentPageIndex;

  final bool isLoading;
  final SurfaceHost? host;
  final String? error;

  ChatState copyWith({
    ChatStatus? status,
    List<List<DisplayMessage>>? pages,
    int? currentPageIndex,
    bool? isLoading,
    SurfaceHost? host,
    String? error,
  }) {
    return ChatState(
      status: status ?? this.status,
      pages: pages ?? this.pages,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isLoading: isLoading ?? this.isLoading,
      host: host ?? this.host,
      error: error ?? this.error,
    );
  }
}

enum ChatStatus { initial, loading, active, error }
