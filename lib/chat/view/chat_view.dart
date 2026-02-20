import 'package:finance_app/app/presentation/spacing.dart';
import 'package:finance_app/chat/bloc/bloc.dart';
import 'package:finance_app/chat/chat.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final chatBloc = context.read<ChatBloc>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.chatAppBarTitle)),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              buildWhen: (previous, current) =>
                  previous.messages != current.messages,
              builder: (context, state) {
                if (state.messages.isEmpty) {
                  return Center(
                    child: Text(l10n.startChattingLabel),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        state.messages[state.messages.length - 1 - index];
                    return ChatMessageBubble(
                      message: message,
                      host: state.host!,
                    );
                  },
                );
              },
            ),
          ),
          BlocBuilder<ChatBloc, ChatState>(
            buildWhen: (previous, current) =>
                previous.isLoading != current.isLoading ||
                previous.status != current.status,
            builder: (context, state) {
              if (state.isLoading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Spacing.md,
                    vertical: Spacing.md,
                  ),
                  child: CircularProgressIndicator(),
                );
              }
              return ChatInputBar(
                enabled: state.status == ChatStatus.active && !state.isLoading,
                onSend: (text) {
                  chatBloc.add(ChatMessageSent(text));
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
