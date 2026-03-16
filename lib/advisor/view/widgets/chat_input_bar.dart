import 'package:finance_app/design_system/design_system.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    required this.onSend,
    this.enabled = true,
    super.key,
  });

  final ValueChanged<String> onSend;
  final bool enabled;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorExtension = Theme.of(context).extension<AppColors>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xs),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: widget.enabled,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: colorExtension?.onSurfaceVariant ?? Colors.grey,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.xs,
                  ),
                  hintText: l10n.chatInputBarHint,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorExtension?.onSurfaceVariant,
                  ),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorExtension?.onSurface,
                ),
              ),
            ),
            const SizedBox(width: Spacing.xs),
            IconButton.filled(
              onPressed: widget.enabled ? _submit : null,
              icon: Icon(
                Icons.send,
                color: colorExtension?.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
