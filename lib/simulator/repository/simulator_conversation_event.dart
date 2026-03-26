/// Events emitted by the simulator repository during a conversation.
sealed class SimulatorConversationEvent {
  const SimulatorConversationEvent();
}

/// The AI is waiting/processing.
final class SimulatorConversationWaiting extends SimulatorConversationEvent {
  const SimulatorConversationWaiting({required this.isWaiting});

  final bool isWaiting;
}

/// The AI produced a text chunk.
final class SimulatorConversationTextReceived
    extends SimulatorConversationEvent {
  const SimulatorConversationTextReceived(this.text);

  final String text;
}

/// The AI produced a new or updated UI surface.
final class SimulatorConversationSurfaceAdded
    extends SimulatorConversationEvent {
  const SimulatorConversationSurfaceAdded(this.surfaceId);

  final String surfaceId;
}

/// An error occurred during the conversation.
final class SimulatorConversationError extends SimulatorConversationEvent {
  const SimulatorConversationError(this.message);

  final String message;
}
