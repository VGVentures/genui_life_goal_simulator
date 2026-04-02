import 'package:equatable/equatable.dart';

/// A message to display in the chat UI.
sealed class DisplayMessage extends Equatable {
  const DisplayMessage();
}

/// A message sent by the user.
final class UserDisplayMessage extends DisplayMessage {
  const UserDisplayMessage(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}

/// A text response from the AI.
final class AiTextDisplayMessage extends DisplayMessage {
  const AiTextDisplayMessage(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}

/// An AI-generated UI surface.
final class AiSurfaceDisplayMessage extends DisplayMessage {
  const AiSurfaceDisplayMessage(this.surfaceId);

  final String surfaceId;

  @override
  List<Object?> get props => [surfaceId];
}
