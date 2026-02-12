import 'package:flutter/material.dart';
import 'package:genui/genui.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    required this.message,
    required this.host,
    super.key,
  });

  final ChatMessage message;
  final GenUiHost host;

  @override
  Widget build(BuildContext context) {
    return switch (message) {
      UserMessage(:final text) => _UserBubble(text: text),
      AiTextMessage(:final text) => _AssistantTextBubble(text: text),
      AiUiMessage(:final surfaceId) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: GenUiSurface(host: host, surfaceId: surfaceId),
      ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        // TODO(juanRodriguez17): Use spacing class when gets merged
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}

class _AssistantTextBubble extends StatelessWidget {
  const _AssistantTextBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        // TODO(juanRodriguez17): Use spacing class when gets merged
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(text, style: theme.textTheme.bodyMedium),
      ),
    );
  }
}
