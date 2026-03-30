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
  BuildContext context,
  Map<String, Object?> data, {
  void Function(UiEvent)? dispatchEvent,
}) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'AiButton',
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

Future<void> _pump(
  WidgetTester tester,
  Map<String, Object?> data, {
  void Function(UiEvent)? dispatchEvent,
  SimulatorState state = const SimulatorState(),
}) async {
  final bloc = _MockSimulatorBloc();
  when(() => bloc.state).thenReturn(state);
  await tester.pumpWidget(
    BlocProvider<SimulatorBloc>.value(
      value: bloc,
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => aiButtonItem.widgetBuilder(
              _context(
                context,
                data,
                dispatchEvent: dispatchEvent,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group(aiButtonItem, () {
    test('has correct name and schema keys', () {
      expect(aiButtonItem.name, 'AiButton');

      final schema = aiButtonItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(props, contains('text'));

      final required = schema.value['required']! as List;
      expect(required, contains('text'));
    });

    testWidgets('renders AiButton with provided text', (tester) async {
      await _pump(tester, {'text': "What's eating my money?"});

      expect(find.byType(AiButton), findsOneWidget);
      expect(find.text("What's eating my money?"), findsOneWidget);
    });

    testWidgets('is disabled when bloc is loading', (tester) async {
      UiEvent? dispatched;
      await _pump(
        tester,
        {'text': 'Tap me'},
        state: const SimulatorState(isLoading: true),
        dispatchEvent: (event) => dispatched = event,
      );

      // Should render with reduced opacity
      final opacityFinder = find.ancestor(
        of: find.byType(AiButton),
        matching: find.byType(Opacity),
      );
      final opacity = tester.widget<Opacity>(opacityFinder.first);
      expect(opacity.opacity, 0.5);

      // Should be wrapped in IgnorePointer
      final ignorePointerFinder = find.ancestor(
        of: find.byType(AiButton),
        matching: find.byType(IgnorePointer),
      );
      final ignorePointer = tester.widget<IgnorePointer>(
        ignorePointerFinder.first,
      );
      expect(ignorePointer.ignoring, isTrue);

      // Tapping should not dispatch an event (warnIfMissed: false because
      // IgnorePointer intentionally blocks the tap)
      await tester.tap(find.byType(AiButton), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(dispatched, isNull);
    });

    testWidgets('onTap dispatches UserActionEvent', (tester) async {
      UiEvent? dispatched;
      await _pump(
        tester,
        {'text': 'Tap me'},
        dispatchEvent: (event) => dispatched = event,
      );

      await tester.tap(find.byType(AiButton));
      await tester.pumpAndSettle();

      expect(dispatched, isNotNull);
      final action = dispatched! as UserActionEvent;
      expect(action.name, 'ai_button_tapped');
      expect(action.sourceComponentId, 'test');
    });
  });
}
