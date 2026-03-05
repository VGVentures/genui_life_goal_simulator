import 'package:finance_app/onboarding/pick_profile/models/profile_type.dart';
import 'package:finance_app/onboarding/want_to_focus/models/focus_option.dart';
import 'package:finance_app/simple_chat/ai_client.dart';
import 'package:finance_app/simple_chat/chat_session.dart';
import 'package:finance_app/simple_chat/message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    required this.profileType,
    required this.customScenario,
    required this.selectedOptions,
    super.key,
    this.aiClient,
  });

  final AiClient? aiClient;
  final ProfileType profileType;
  final String customScenario;
  final Set<FocusOption> selectedOptions;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  ChatSession? _chatSession;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final double screenWidth = MediaQuery.of(context).size.width;
      _chatSession = ChatSession(
        aiClient: widget.aiClient ?? DartanticAiClient(),
        screenWidth: screenWidth,
      );
      _chatSession!.addListener(_scrollToBottom);
      _sendInitialMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ChatSession? chatSession = _chatSession;
    if (chatSession == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return ListenableBuilder(
      listenable: chatSession,
      builder: (context, _) {
        return Theme(
          data: ThemeData.light(),
          child: Scaffold(
            appBar: AppBar(title: const Text('Chat (Controller + Dartantic)')),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: chatSession.messages.length,
                      itemBuilder: (context, index) {
                        final Message message = chatSession.messages[index];
                        // Pass the controller as the host.
                        return ListTile(
                          title: MessageView(
                            message,
                            chatSession.surfaceController,
                          ),
                          tileColor: message.isUser
                              ? Colors.blue.withValues(alpha: 0.1)
                              : null,
                        );
                      },
                    ),
                  ),

                  if (chatSession.isProcessing)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            decoration: const InputDecoration(
                              hintText: 'Type your message...',
                            ),
                            enabled: !chatSession.isProcessing,
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: chatSession.isProcessing
                              ? null
                              : _sendMessage,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _sendMessage([String? message]) async {
    final String text = message ?? _textController.text;
    if (text.isEmpty) return;
    _textController.clear();
    await _chatSession!.sendMessage(text);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _chatSession?.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendInitialMessage() async {
    await Future.delayed(const Duration(seconds: 1));
    
    return _sendMessage(
      'Hello, please help me create a budget. I am a ${widget.profileType.name} and I want to focus on ${widget.selectedOptions.join(', ')}. Please ask me questions to help me create a budget.',
    );
  }
}
