import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/simulator/simulator.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataModel extends Mock implements DataModel {}

class _MockSimulatorBloc extends MockBloc<SimulatorEvent, SimulatorState>
    implements SimulatorBloc {}

CatalogItemContext _context(
  BuildContext context, {
  void Function(UiEvent)? dispatchEvent,
}) {
  return CatalogItemContext(
    data: {
      'suggestions': [
        {'label': 'Option A'},
        {'label': 'Option B'},
      ],
    },
    id: 'test',
    type: 'NextStepsBar',
    buildChild: (id, [dataContext]) => const SizedBox.shrink(),
    dispatchEvent: dispatchEvent ?? (_) {},
    buildContext: context,
    dataContext: DataContext(_MockDataModel(), DataPath.root),
    getComponent: (_) => null,
    getCatalogItem: (_) => null,
    surfaceId: 'surface',
    reportError: (_, _) {},
  );
}

Future<_MockSimulatorBloc> _pump(
  WidgetTester tester, {
  void Function(UiEvent)? dispatchEvent,
  Stream<SimulatorState>? stream,
}) async {
  final bloc = _MockSimulatorBloc();
  when(() => bloc.state).thenReturn(const SimulatorState());
  if (stream != null) {
    whenListen(bloc, stream);
  }
  await tester.pumpWidget(
    BlocProvider<SimulatorBloc>.value(
      value: bloc,
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => nextStepsBarItem.widgetBuilder(
              _context(context, dispatchEvent: dispatchEvent),
            ),
          ),
        ),
      ),
    ),
  );
  // Allow the post-frame callback to insert the overlay.
  await tester.pumpAndSettle();
  return bloc;
}

void main() {
  group(nextStepsBarItem, () {
    test('has correct name and schema keys', () {
      expect(nextStepsBarItem.name, 'NextStepsBar');

      final schema = nextStepsBarItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(props, containsAll(['suggestions']));

      final required = schema.value['required']! as List;
      expect(required, containsAll(['suggestions']));
    });

    testWidgets('renders suggestion buttons in overlay', (tester) async {
      await _pump(tester);

      expect(find.byType(AiButton), findsNWidgets(2));
      expect(find.text('Option A'), findsOneWidget);
      expect(find.text('Option B'), findsOneWidget);
    });

    testWidgets('dispatches event on tap', (tester) async {
      final events = <UiEvent>[];
      await _pump(tester, dispatchEvent: events.add);

      await tester.tap(find.text('Option A'));
      await tester.pump();

      expect(events, hasLength(1));
      final event = events.single as UserActionEvent;
      expect(event.name, 'next_step_selected');
      expect(event.context, {'label': 'Option A'});
    });

    testWidgets('shows ThinkingAnimation after tap', (tester) async {
      await _pump(tester);

      await tester.tap(find.text('Option A'));
      await tester.pump();

      expect(find.byType(ThinkingAnimation), findsOneWidget);
      expect(find.byType(AiButton), findsNothing);
    });

    testWidgets('buttons are disabled when bloc is loading', (tester) async {
      final events = <UiEvent>[];
      final controller = StreamController<SimulatorState>();
      await _pump(
        tester,
        stream: controller.stream,
        dispatchEvent: events.add,
      );

      // Verify buttons are initially active
      expect(find.byType(AiButton), findsNWidgets(2));

      // Simulate bloc transitioning to loading
      const loadingState = SimulatorState(isLoading: true);
      controller.add(loadingState);
      await tester.pumpAndSettle();

      // Buttons should still be visible (not replaced with ThinkingAnimation)
      expect(find.byType(AiButton), findsNWidgets(2));
      expect(find.byType(ThinkingAnimation), findsNothing);

      // Tapping should not dispatch an event
      await tester.tap(find.text('Option A'), warnIfMissed: false);
      await tester.pump();
      expect(events, isEmpty);

      await controller.close();
    });
  });
}
