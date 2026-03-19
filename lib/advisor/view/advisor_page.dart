import 'package:dartantic_firebase_ai/dartantic_firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv_genui_financial_advisor/advisor/advisor.dart';
import 'package:vgv_genui_financial_advisor/onboarding/pick_profile/models/profile_type.dart';
import 'package:vgv_genui_financial_advisor/onboarding/want_to_focus/models/focus_option.dart';

class AdvisorPage extends StatelessWidget {
  const AdvisorPage({
    required this.profileType,
    this.focusOptions = const {},
    this.customOption = '',
    this.advisorBloc,
    super.key,
  });

  final ProfileType profileType;
  final Set<FocusOption> focusOptions;
  final String customOption;
  final AdvisorBloc? advisorBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          (advisorBloc ??
                AdvisorBloc(
                  advisorRepository: AdvisorRepository(
                    chatModel: FirebaseAIChatModel(
                      name: 'gemini-3-flash-preview',
                      backend: FirebaseAIBackend.googleAI,
                      appCheck: FirebaseAppCheck.instance,
                      useLimitedUseAppCheckTokens: true,
                    ),
                  ),
                ))
            ..add(
              AdvisorStarted(
                profileType: profileType,
                focusOptions: focusOptions,
                customOption: customOption,
              ),
            ),
      child: AdvisorView(profileType: profileType),
    );
  }
}
