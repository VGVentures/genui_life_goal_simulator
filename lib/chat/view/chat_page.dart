import 'package:dartantic_firebase_ai/dartantic_firebase_ai.dart';
import 'package:finance_app/chat/bloc/bloc.dart';
import 'package:finance_app/chat/chat.dart';
import 'package:finance_app/onboarding/pick_profile/models/profile_type.dart';
import 'package:finance_app/onboarding/want_to_focus/models/focus_option.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({
    required this.profileType,
    this.focusOptions = const {},
    this.customOption = '',
    this.chatBloc,
    super.key,
  });

  final ProfileType profileType;
  final Set<FocusOption> focusOptions;
  final String customOption;
  final ChatBloc? chatBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          (chatBloc ??
                ChatBloc(
                  chatModelFactory: () => FirebaseAIChatModel(
                    name: 'gemini-3-flash-preview',
                    backend: FirebaseAIBackend.googleAI,
                    appCheck: FirebaseAppCheck.instance,
                    useLimitedUseAppCheckTokens: true,
                  ),
                ))
            ..add(
              ChatStarted(
                profileType: profileType,
                focusOptions: focusOptions,
                customOption: customOption,
              ),
            ),
      child: ChatView(profileType: profileType),
    );
  }
}
