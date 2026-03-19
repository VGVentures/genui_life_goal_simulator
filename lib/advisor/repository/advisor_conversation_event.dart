/// Events emitted by the advisor repository during a conversation.
sealed class AdvisorConversationEvent {
  const AdvisorConversationEvent();
}

/// The AI is waiting/processing.
final class AdvisorConversationWaiting extends AdvisorConversationEvent {
  const AdvisorConversationWaiting({required this.isWaiting});

  final bool isWaiting;
}

/// The AI produced a text chunk.
final class AdvisorConversationTextReceived extends AdvisorConversationEvent {
  const AdvisorConversationTextReceived(this.text);

  final String text;
}

/// The AI produced a new or updated UI surface.
final class AdvisorConversationSurfaceAdded extends AdvisorConversationEvent {
  const AdvisorConversationSurfaceAdded(this.surfaceId);

  final String surfaceId;
}

/// An error occurred during the conversation.
final class AdvisorConversationError extends AdvisorConversationEvent {
  const AdvisorConversationError(this.message);

  final String message;
}
