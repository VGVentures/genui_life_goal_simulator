part of 'chat_bloc.dart';

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
  final List<ChatMessage> messages;
  final bool isLoading;
  final GenUiHost? host;
  final String? error;

  ChatState copyWith({
    ChatStatus? status,
    List<ChatMessage>? messages,
    bool? isLoading,
    GenUiHost? host,
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
