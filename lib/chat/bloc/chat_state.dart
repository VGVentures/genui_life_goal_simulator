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
    this.messages = const [],
    this.isLoading = false,
    this.host,
    this.error,
  });

  final ChatStatus status;
  final List<DisplayMessage> messages;
  final bool isLoading;
  final SurfaceHost? host;
  final String? error;

  ChatState copyWith({
    ChatStatus? status,
    List<DisplayMessage>? messages,
    bool? isLoading,
    SurfaceHost? host,
    String? error,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      host: host ?? this.host,
      error: error ?? this.error,
    );
  }
}

enum ChatStatus { initial, loading, active, error }
