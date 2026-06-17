import 'dart:async';

import 'package:flutter/foundation.dart';
// genui also exports a PromptBuilder; hide it so the app's PromptBuilder wins.
import 'package:genui/genui.dart' hide PromptBuilder;
import 'package:genui_life_goal_simulator/error_reporting/error_reporting.dart';
import 'package:genui_life_goal_simulator/onboarding/pick_profile/models/profile_type.dart';
import 'package:genui_life_goal_simulator/onboarding/want_to_focus/models/focus_option.dart';
import 'package:genui_life_goal_simulator/simulator/catalog/finance_catalog.dart';
import 'package:genui_life_goal_simulator/simulator/prompt/prompt.dart';
import 'package:genui_life_goal_simulator/simulator/repository/simulator_conversation_event.dart';
import 'package:genui_life_goal_simulator/simulator/repository/simulator_repository.dart';

import 'benchmark_models.dart';
import 'benchmark_recorder.dart';
import 'timing_chat_model.dart';

/// Tracks uncaught async errors captured by the guarded zone.
///
/// The GenUI parser reports invalid model output (schema violations) by adding
/// errors to a stream that has no error handler, so they escape as uncaught
/// async errors rather than reaching the conversation's event stream. We
/// capture them here and attribute them to the in-flight turn.
class _AsyncErrorTally {
  int count = 0;
  String? lastMessage;
}

/// Runs the benchmark for a single model: [iterations] passes, each driving
/// [turns] real model round trips through the actual [SimulatorRepository] —
/// same composed system prompt, same GenUI parser. The parser doubles as the
/// schema validator: a turn that yields no surface (or errors) is a failure.
Future<BenchmarkRecorder> runBenchmarkForModel({
  required BenchmarkModel model,
  required int iterations,
  required int turns,
  void Function(String message)? log,
}) async {
  final recorder = BenchmarkRecorder(model.id);
  final tally = _AsyncErrorTally();

  // Run inside a guarded zone so a malformed-output error (or a teardown race
  // in genui) is recorded as a turn failure instead of aborting the benchmark.
  await runZonedGuarded(
    () async {
      for (var i = 0; i < iterations; i++) {
        recorder.startIteration();
        log?.call('  iteration ${i + 1}/$iterations');
        await _runIteration(
          model: model,
          turns: turns,
          recorder: recorder,
          tally: tally,
          log: log,
        );
      }
    },
    (error, stack) {
      tally
        ..count += 1
        ..lastMessage = error.toString().split('\n').first;
    },
  );

  return recorder;
}

Future<void> _runIteration({
  required BenchmarkModel model,
  required int turns,
  required BenchmarkRecorder recorder,
  required _AsyncErrorTally tally,
  void Function(String message)? log,
}) async {
  final catalog = buildFinanceCatalog();
  final surfaceController = SurfaceController(catalogs: [catalog]);

  TurnTiming? lastTiming;
  final chatModel = TimingChatModel(
    model.build(),
    onTurn: (timing) => lastTiming = timing,
  );

  final repository = SimulatorRepository(
    chatModel: chatModel,
    errorReporting: _SilentErrorReporting(),
    catalog: catalog,
    surfaceController: surfaceController,
  );

  final surfaceIds = <String>{};
  var errorCount = 0;
  String? lastError;
  final subscription = repository.events.listen((event) {
    switch (event) {
      case SimulatorConversationSurfaceAdded(:final surfaceId):
        surfaceIds.add(surfaceId);
      case SimulatorConversationError(:final message):
        errorCount += 1;
        lastError = message;
      case _:
        break;
    }
  });

  try {
    await repository.startConversation();

    for (var t = 0; t < turns; t++) {
      lastTiming = null;
      final surfacesBefore = surfaceIds.length;
      final errorsBefore = errorCount;
      final asyncErrorsBefore = tally.count;

      // Mirror the bloc's step tracking so history isn't truncated between
      // forward turns.
      repository.currentStep = t;

      final message = t == 0
          ? PromptBuilder.buildInitialUserMessage(
              profileType: ProfileType.beginner,
              focusOptions: const {FocusOption.saveForRetirement},
            )
          : 'Continue to the next step.';

      await repository.sendMessage(message);
      await _drainParser();

      final producedSurface = surfaceIds.length > surfacesBefore;
      final eventError = errorCount > errorsBefore;
      final asyncError = tally.count > asyncErrorsBefore;
      final hadError = eventError || asyncError;
      final timing = lastTiming;

      recorder.recordTurn(
        totalMs: timing?.totalMs ?? 0,
        chunkCount: timing?.chunkCount ?? 0,
        surfaceProduced: producedSurface,
        timeToFirstChunkMs: timing?.timeToFirstChunkMs,
        promptTokens: timing?.promptTokens,
        responseTokens: timing?.responseTokens,
        totalTokens: timing?.totalTokens,
        error: hadError
            ? (lastError ?? tally.lastMessage ?? 'genui error')
            : timing?.errorMessage,
      );

      if (!producedSurface) {
        log?.call('    turn ${t + 1}: no valid surface; stopping pass.');
        break;
      }
    }
  } finally {
    await subscription.cancel();
    await repository.dispose();
    // Let any post-dispose async noise settle inside this iteration's scope so
    // it isn't misattributed to the next turn.
    await _drainParser();
  }
}

/// The A2UI parser processes streamed text on an async pipeline, so surface and
/// error events arrive shortly after `sendMessage` returns. Yield to the event
/// loop long enough for them to flush.
Future<void> _drainParser() async {
  for (var i = 0; i < 15; i++) {
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}

/// Swallows errors during benchmarking — failures are already recorded as turn
/// metrics via the conversation event stream.
class _SilentErrorReporting extends ErrorReportingRepository {
  @override
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? extra,
  }) async {}

  @override
  void handleFlutterError(FlutterErrorDetails details) {}

  @override
  bool handlePlatformError(Object error, StackTrace stackTrace) => true;
}
