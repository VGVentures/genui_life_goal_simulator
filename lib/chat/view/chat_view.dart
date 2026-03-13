import 'dart:async';

import 'package:finance_app/app/presentation/spacing.dart';
import 'package:finance_app/chat/bloc/bloc.dart';
import 'package:finance_app/chat/chat.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui/genui.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final chatBloc = context.read<ChatBloc>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.chatAppBarTitle)),
      body: BlocConsumer<ChatBloc, ChatState>(
        listenWhen: (previous, current) =>
            previous.currentPageIndex != current.currentPageIndex,
        listener: (context, state) {
          if (_pageController.hasClients && state.pages.isNotEmpty) {
            unawaited(
              _pageController.animateToPage(
                state.currentPageIndex,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              ),
            );
          }
        },
        buildWhen: (previous, current) =>
            previous.pages != current.pages ||
            previous.isLoading != current.isLoading,
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: state.pages.isEmpty
                    ? Center(child: Text(l10n.startChattingLabel))
                    : PageView.builder(
                        controller: _pageController,
                        itemCount: state.pages.length,
                        itemBuilder: (context, pageIndex) {
                          final messages = state.pages[pageIndex];
                          return _ChatPage(
                            messages: messages,
                            host: state.host!,
                            isLoading:
                                state.isLoading &&
                                pageIndex == state.currentPageIndex,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ChatPage extends StatelessWidget {
  const _ChatPage({
    required this.messages,
    required this.host,
    required this.isLoading,
  });

  final List<DisplayMessage> messages;
  final SurfaceHost host;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final message in messages)
            if (message is! UserDisplayMessage)
              ChatMessageBubble(message: message, host: host),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(Spacing.md),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
