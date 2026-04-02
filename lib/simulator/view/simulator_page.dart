import 'package:dartantic_firebase_ai/dartantic_firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/error_reporting/error_reporting.dart';
import 'package:genui_life_goal_simulator/onboarding/pick_profile/models/profile_type.dart';
import 'package:genui_life_goal_simulator/onboarding/want_to_focus/models/focus_option.dart';
import 'package:genui_life_goal_simulator/simulator/simulator.dart';

class SimulatorPage extends StatefulWidget {
  const SimulatorPage({
    required this.profileType,
    this.focusOptions = const {},
    this.customOption = '',
    this.simulatorBloc,
    this.surfaceController,
    super.key,
  });

  final ProfileType profileType;
  final Set<FocusOption> focusOptions;
  final String customOption;
  final SimulatorBloc? simulatorBloc;

  /// Optional [SurfaceController] for testing. When null, a real controller
  /// is created from [buildFinanceCatalog].
  final SurfaceController? surfaceController;

  @override
  State<SimulatorPage> createState() => _SimulatorPageState();
}

class _SimulatorPageState extends State<SimulatorPage> {
  late final Catalog _catalog;
  late final SurfaceController _surfaceController;

  @override
  void initState() {
    super.initState();
    _catalog = buildFinanceCatalog();
    _surfaceController =
        widget.surfaceController ?? SurfaceController(catalogs: [_catalog]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        if (widget.simulatorBloc != null) return widget.simulatorBloc!;
        return SimulatorBloc(
          simulatorRepository: SimulatorRepository(
            chatModel: FirebaseAIChatModel(
              name: 'gemini-3-flash-preview',
              backend: FirebaseAIBackend.googleAI,
              appCheck: FirebaseAppCheck.instance,
              useLimitedUseAppCheckTokens: true,
            ),
            errorReporting: context.read<ErrorReportingRepository>(),
            catalog: _catalog,
            surfaceController: _surfaceController,
          ),
        )..add(
          SimulatorStarted(
            profileType: widget.profileType,
            focusOptions: widget.focusOptions,
            customOption: widget.customOption,
          ),
        );
      },
      child: SimulatorView(
        profileType: widget.profileType,
        surfaceHost: _surfaceController,
      ),
    );
  }
}
