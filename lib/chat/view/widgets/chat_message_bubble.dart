import 'package:finance_app/app/presentation.dart';
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
      // TODO(juanRodriguez17): Just to see the hole model response
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
    final colorExtension = theme.extension<AppColors>();

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: Spacing.xs,
          horizontal: Spacing.xs,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: Spacing.sm,
          horizontal: Spacing.sm,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(Spacing.md),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorExtension?.secondary.shade50,
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
    final colorExtension = theme.extension<AppColors>();

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: Spacing.xs,
          horizontal: Spacing.xs,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: Spacing.sm,
          horizontal: Spacing.sm,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        decoration: BoxDecoration(
          color: colorExtension?.secondary.shade500,
          borderRadius: BorderRadius.circular(Spacing.md),
        ),
        child: Text(text, style: theme.textTheme.bodyMedium),
      ),
    );
  }
}
