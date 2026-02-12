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

    return SafeArea(
      child: Padding(
        // TODO(juanRodriguez17): Use spacing class when gets merged
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: widget.enabled,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  hintText: l10n.chatInputBarHint,
                  border: const OutlineInputBorder(),
                  // TODO(juanRodriguez17): Use spacing class when gets merged
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ),
            // TODO(juanRodriguez17): Use spacing class when gets merged
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: widget.enabled ? _submit : null,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
