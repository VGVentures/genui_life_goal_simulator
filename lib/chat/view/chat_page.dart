import 'package:finance_app/chat/bloc/bloc.dart';
import 'package:finance_app/chat/chat.dart';
import 'package:finance_app/financials/mock/mock_scenario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({required this.scenario, this.chatBloc, super.key});

  final MockScenario scenario;
  final ChatBloc? chatBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => (chatBloc ?? ChatBloc())..add(ChatStarted(scenario)),
      child: const ChatView(),
    );
  }
}
