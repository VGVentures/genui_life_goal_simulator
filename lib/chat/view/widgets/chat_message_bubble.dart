import 'dart:async';

import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/chat/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:genui/genui.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    required this.message,
    required this.host,
    super.key,
  });

  final DisplayMessage message;
  final SurfaceHost host;

  @override
  Widget build(BuildContext context) {
    return switch (message) {
      UserDisplayMessage(:final text) => _UserBubble(text: text),
      AiTextDisplayMessage(:final text) => _AssistantTextBubble(text: text),
      AiSurfaceDisplayMessage(:final surfaceId) => Surface(
        surfaceContext: host.contextFor(surfaceId),
      ),
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
            color: colorExtension?.onPrimary,
          ),
        ),
      ),
    );
  }
}

class _AssistantTextBubble extends StatefulWidget {
  const _AssistantTextBubble({required this.text});

  final String text;

  @override
  State<_AssistantTextBubble> createState() => _AssistantTextBubbleState();
}

class _AssistantTextBubbleState extends State<_AssistantTextBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    unawaited(_controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FadeTransition(
      opacity: _opacity,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Padding(
            padding: const EdgeInsets.only(
              top: Spacing.md,
            ),
            child: MarkdownBody(
              data: widget.text,
              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                p: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
