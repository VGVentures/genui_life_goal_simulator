import 'dart:async';
import 'dart:convert';

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
import 'package:json_schema_builder/json_schema_builder.dart';

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
  final List<String> messages = [];
  int get count => messages.length;
}

String _firstLine(String s) => s.split('\n').first.trim();

/// Runs every model in [models] round-robin: one iteration of each model per
/// cycle, re-shuffling the order each cycle. Each iteration drives [turns] real
/// round trips through the actual [SimulatorRepository] (same composed system
/// prompt, same GenUI parser, which doubles as the schema validator: a turn
/// that yields no surface, or errors, is a failure).
///
/// Interleaving spreads each provider's requests across the whole run so bursts
/// don't trip rate/token limits, and no model is penalized by running late.
/// [onIterationComplete] fires after each model finishes an iteration so
/// callers can persist partial results as the run progresses.
///
/// The whole sweep runs inside one guarded zone so a malformed-output error (or
/// a genui teardown race) is recorded as a turn failure instead of aborting the
/// benchmark.
Future<void> runRoundRobin({
  required List<BenchmarkModel> models,
  required int iterations,
  required int turns,
  required int stepDelaySeconds,
  void Function(String message)? log,
  void Function(BenchmarkModel model, BenchmarkRecorder recorder)?
  onIterationComplete,
}) async {
  final recorders = {
    for (final model in models) model.id: BenchmarkRecorder(model.id),
  };
  final tally = _AsyncErrorTally();
  final stepDelay = Duration(seconds: stepDelaySeconds);

  // Per-component JSON schemas from the catalog, used to validate that the
  // model's output conforms to each catalog item's props.
  final componentSchemas = <String, Schema>{
    for (final item in buildFinanceCatalog().items) item.name: item.dataSchema,
  };

  await runZonedGuarded(
    () async {
      for (var i = 0; i < iterations; i++) {
        final order = [...models]..shuffle();
        for (final model in order) {
          if (stepDelay > Duration.zero) {
            await Future<void>.delayed(stepDelay);
          }
          log?.call('iteration ${i + 1}/$iterations — ${model.id}');
          final recorder = recorders[model.id]!;
          await _runIteration(
            model: model,
            turns: turns,
            recorder: recorder,
            tally: tally,
            componentSchemas: componentSchemas,
            log: log,
          );
          onIterationComplete?.call(model, recorder);
        }
      }
    },
    (error, stack) {
      tally.messages.add(error.toString());
    },
  );
}

Future<void> _runIteration({
  required BenchmarkModel model,
  required int turns,
  required BenchmarkRecorder recorder,
  required _AsyncErrorTally tally,
  required Map<String, Schema> componentSchemas,
  void Function(String message)? log,
}) async {
  recorder.startIteration();
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
  final eventErrors = <String>[];
  final subscription = repository.events.listen((event) {
    switch (event) {
      case SimulatorConversationSurfaceAdded(:final surfaceId):
        surfaceIds.add(surfaceId);
      case SimulatorConversationError(:final message):
        eventErrors.add(message);
      case _:
        break;
    }
  });

  try {
    await repository.startConversation();

    for (var t = 0; t < turns; t++) {
      lastTiming = null;
      final surfacesBefore = surfaceIds.length;
      final eventErrorsBefore = eventErrors.length;
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
      // Wait for the async A2UI parser to emit its surface/error events. Poll
      // until they stop arriving (or a cap) rather than a fixed delay, so a
      // slightly-late surface event isn't missed and counted as a failure.
      await _awaitSettled(
        () => surfaceIds.length + eventErrors.length + tally.count,
      );

      final producedSurface = surfaceIds.length > surfacesBefore;
      final timing = lastTiming;

      // All error strings seen during this turn (event stream + the parser's
      // uncaught async errors), kept in full for the failure report.
      final turnErrors = [
        ...eventErrors.skip(eventErrorsBefore),
        ...tally.messages.skip(asyncErrorsBefore),
      ];
      // Validate the model's emitted components against the catalog schemas.
      // genui validates these too but swallows the failures (it just logs them
      // and tells the model), so we check here to count them in the error rate.
      final schemaViolations = await _validateComponents(
        timing?.outputText ?? '',
        componentSchemas,
      );

      final hadError = turnErrors.isNotEmpty;
      final failed =
          hadError || !producedSurface || schemaViolations.isNotEmpty;
      final failureReason = failed
          ? _classifyFailure(
              output: timing?.outputText ?? '',
              errors: turnErrors,
              schemaViolations: schemaViolations,
            )
          : null;

      recorder.recordTurn(
        totalMs: timing?.totalMs ?? 0,
        chunkCount: timing?.chunkCount ?? 0,
        surfaceProduced: producedSurface,
        timeToFirstChunkMs: timing?.timeToFirstChunkMs,
        promptTokens: timing?.promptTokens,
        responseTokens: timing?.responseTokens,
        totalTokens: timing?.totalTokens,
        error: hadError ? _firstLine(turnErrors.first) : timing?.errorMessage,
        failureReason: failureReason,
        errorDetails: [...turnErrors, ...schemaViolations],
        outputText: timing?.outputText ?? '',
      );

      if (!producedSurface) {
        log?.call(
          '    turn ${t + 1}: ${failureReason ?? 'no surface'}; '
          'stopping pass.',
        );
        break;
      }
    }
  } finally {
    await subscription.cancel();
    await repository.dispose();
    // Let any post-dispose async noise settle inside this iteration's scope so
    // it isn't misattributed to the next turn.
    await Future<void>.delayed(const Duration(milliseconds: 150));
  }
}

/// Waits for the async A2UI parser to finish emitting events for a turn.
///
/// [probe] returns a running count of observed events (surfaces + errors).
/// Returns once that count has been stable for a short quiet window, or after a
/// hard cap. Turns that legitimately produce nothing (e.g. an
/// `updateComponents` buffered awaiting a `createSurface`) return quickly via
/// the quiet window.
Future<void> _awaitSettled(int Function() probe) async {
  const quietMs = 250;
  const maxWaitMs = 8000;
  final stopwatch = Stopwatch()..start();
  var last = probe();
  var lastChangeMs = 0;
  while (stopwatch.elapsedMilliseconds < maxWaitMs) {
    await Future<void>.delayed(const Duration(milliseconds: 25));
    final now = probe();
    if (now != last) {
      last = now;
      lastChangeMs = stopwatch.elapsedMilliseconds;
    } else if (stopwatch.elapsedMilliseconds - lastChangeMs >= quietMs) {
      break;
    }
  }
}

/// Produces a sharp, human-readable reason a turn failed, by re-parsing the
/// model's raw [output] into A2UI messages and checking it against the protocol
/// (genui requires `version: "v0.9"` and `updateComponents: {surfaceId,
/// components}`, and a surface must be created before it can be updated).
String _classifyFailure({
  required String output,
  required List<String> errors,
  required List<String> schemaViolations,
}) {
  // Any non-GenUI error is a transport/API failure (e.g. rate limit, auth).
  final transport = errors.firstWhere(
    (e) => !e.contains('A2uiValidationException'),
    orElse: () => '',
  );
  if (transport.isNotEmpty) {
    return 'transport/API error: ${_firstLine(transport)}';
  }

  final objects = _extractJsonObjects(output);
  final a2ui = objects
      .where(
        (o) =>
            o.containsKey('createSurface') ||
            o.containsKey('updateComponents') ||
            o.containsKey('updateDataModel') ||
            o.containsKey('deleteSurface'),
      )
      .toList();

  if (a2ui.isEmpty) {
    final hasComponents = objects.any((o) => o.containsKey('component'));
    return hasComponents
        ? 'component fragments without an A2UI envelope '
              '(no createSurface/updateComponents)'
        : 'no A2UI messages found in output';
  }

  if (a2ui.any((o) => o['updateComponents'] is List)) {
    return 'malformed updateComponents (array, expected {surfaceId, '
        'components})';
  }
  if (a2ui.any((o) => o['version'] != 'v0.9')) {
    return 'wrong or missing version (expected "v0.9")';
  }

  // Props that don't conform to a catalog item's schema. Kept as a stable
  // category so the report tooltip aggregates cleanly; specifics live in the
  // per-turn errorDetails (and the failures.txt report).
  if (schemaViolations.isNotEmpty) {
    return 'component schema violation';
  }

  final hasCreate = a2ui.any((o) => o['createSurface'] is Map);
  final hasUpdate = a2ui.any((o) => o.containsKey('updateComponents'));
  if (hasUpdate && !hasCreate) {
    return 'updateComponents without createSurface (surface never created)';
  }
  if (!hasCreate) {
    return 'no createSurface emitted';
  }
  return 'createSurface present but no surface rendered';
}

/// Validates the model's emitted components against the catalog [schemas].
///
/// Parses `updateComponents` messages from the raw [output] and checks each
/// component's props against its catalog item's JSON schema (with `id` and
/// `component` stripped, since those aren't part of the props schema). Returns
/// one human-readable string per violation; empty means everything conformed.
Future<List<String>> _validateComponents(
  String output,
  Map<String, Schema> schemas,
) async {
  final violations = <String>[];
  for (final message in _extractJsonObjects(output)) {
    final update = message['updateComponents'];
    if (update is! Map) continue; // array/other forms handled elsewhere
    final components = update['components'];
    if (components is! List) continue;
    for (final raw in components) {
      if (raw is! Map) continue;
      final component = raw.cast<String, Object?>();
      final type = component['component'];
      if (type is! String) continue;
      final id = component['id'];
      final label = id is String ? '$type#$id' : type;
      final schema = schemas[type];
      if (schema == null) {
        violations.add('$label: unknown component "$type" (not in catalog)');
        continue;
      }
      // The catalog dataSchema describes the whole component object (it pins
      // `component` to a const and includes `id`), so validate it as-is.
      final errors = await schema.validate(component);
      if (errors.isNotEmpty) {
        violations.add('$label: ${errors.first.toErrorString()}');
      }
    }
  }
  return violations;
}

/// Extracts top-level JSON objects from [text], tolerating surrounding prose,
/// markdown fences, and multiple concatenated objects. String contents are
/// skipped so braces inside values don't break brace-matching.
List<Map<String, Object?>> _extractJsonObjects(String text) {
  final objects = <Map<String, Object?>>[];
  var depth = 0;
  var start = -1;
  var inString = false;
  var escaped = false;
  for (var i = 0; i < text.length; i++) {
    final ch = text[i];
    if (inString) {
      if (escaped) {
        escaped = false;
      } else if (ch == r'\') {
        escaped = true;
      } else if (ch == '"') {
        inString = false;
      }
      continue;
    }
    if (ch == '"') {
      inString = true;
    } else if (ch == '{') {
      if (depth == 0) start = i;
      depth++;
    } else if (ch == '}' && depth > 0) {
      depth--;
      if (depth == 0 && start >= 0) {
        try {
          final decoded = jsonDecode(text.substring(start, i + 1));
          if (decoded is Map<String, Object?>) objects.add(decoded);
        } on FormatException {
          // Not valid JSON; ignore this brace span.
        }
        start = -1;
      }
    }
  }
  return objects;
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
