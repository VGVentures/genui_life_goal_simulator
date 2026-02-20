part of 'chat_bloc.dart';

/// {@template advisor_event}
/// Events for the [ChatBloc].
/// {@endtemplate}
sealed class ChatEvent {
  const ChatEvent();
}

/// The user selected a persona and wants to start a conversation
final class ChatStarted extends ChatEvent {
  const ChatStarted(this.scenario);

  final MockScenario scenario;
}

/// The user sent a text message
final class ChatMessageSent extends ChatEvent {
  const ChatMessageSent(this.text);

  final String text;
}

/// Conversation messages changed
final class ChatConversationUpdated extends ChatEvent {
  const ChatConversationUpdated(this.messages);

  final List<ChatMessage> messages;
}

/// Loading state when LLM is processing a request
final class ChatLoading extends ChatEvent {
  const ChatLoading({required this.isLoading});

  final bool isLoading;
}

/// An error occurred in the content generator
final class ChatErrorOccurred extends ChatEvent {
  const ChatErrorOccurred(this.message);

  final String message;
}
