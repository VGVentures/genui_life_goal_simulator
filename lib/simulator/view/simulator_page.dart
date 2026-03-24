import 'package:dartantic_firebase_ai/dartantic_firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui_life_goal_simulator/onboarding/pick_profile/models/profile_type.dart';
import 'package:genui_life_goal_simulator/onboarding/want_to_focus/models/focus_option.dart';
import 'package:genui_life_goal_simulator/simulator/simulator.dart';

class SimulatorPage extends StatelessWidget {
  const SimulatorPage({
    required this.profileType,
    this.focusOptions = const {},
    this.customOption = '',
    this.simulatorBloc,
    super.key,
  });

  final ProfileType profileType;
  final Set<FocusOption> focusOptions;
  final String customOption;
  final SimulatorBloc? simulatorBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          (simulatorBloc ??
                SimulatorBloc(
                  simulatorRepository: SimulatorRepository(
                    chatModel: FirebaseAIChatModel(
                      name: 'gemini-3-flash-preview',
                      backend: FirebaseAIBackend.googleAI,
                      appCheck: FirebaseAppCheck.instance,
                      useLimitedUseAppCheckTokens: true,
                    ),
                  ),
                ))
            ..add(
              SimulatorStarted(
                profileType: profileType,
                focusOptions: focusOptions,
                customOption: customOption,
              ),
            ),
      child: SimulatorView(profileType: profileType),
    );
  }
}
