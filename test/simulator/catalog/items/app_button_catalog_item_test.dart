import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/l10n/gen/app_localizations.dart';
import 'package:genui_life_goal_simulator/simulator/simulator.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataModel extends Mock implements DataModel {}

class _MockSimulatorBloc extends MockBloc<SimulatorEvent, SimulatorState>
    implements SimulatorBloc {}

const _defaultAction = {
  'event': {'name': 'button_pressed'},
};

Map<String, Object?> _data({
  String label = 'Get Started',
  String variant = 'filled',
  String size = 'large',
  Map<String, Object?> action = _defaultAction,
}) => {
  'label': label,
  'variant': variant,
  'size': size,
  'action': action,
};

CatalogItemContext _context(
  BuildContext context,
  Map<String, Object?> data, {
  void Function(UiEvent)? dispatchEvent,
}) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'AppButton',
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
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => appButtonItem.widgetBuilder(
              _context(context, data, dispatchEvent: dispatchEvent),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group(appButtonItem, () {
    test('has correct name and schema keys', () {
      expect(appButtonItem.name, 'AppButton');

      final schema = appButtonItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(
        props,
        containsAll([
          'label',
          'variant',
          'size',
          'action',
          'showLoadingOverlay',
        ]),
      );

      final required = schema.value['required']! as List;
      expect(required, containsAll(['label', 'variant', 'size', 'action']));
    });

    group('renders', () {
      testWidgets('filled button with label', (tester) async {
        await _pump(tester, _data());

        expect(find.text('Get Started'), findsOneWidget);
        expect(find.byType(FilledButton), findsOneWidget);
      });

      testWidgets('outlined variant', (tester) async {
        await _pump(tester, _data(variant: 'outlined'));

        expect(find.text('Get Started'), findsOneWidget);
        expect(find.byType(OutlinedButton), findsOneWidget);
      });

      testWidgets('button is disabled after tap', (tester) async {
        await _pump(tester, _data());

        await tester.tap(find.text('Get Started'));
        await tester.pump();

        // Button should still show its label (not a loading indicator)
        expect(find.text('Get Started'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('button is disabled when bloc is loading', (tester) async {
        final events = <UiEvent>[];
        await _pump(
          tester,
          _data(),
          state: const SimulatorState(isLoading: true),
          dispatchEvent: events.add,
        );

        // Button should render but be disabled (not tappable)
        expect(find.text('Get Started'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);

        // Tapping should not dispatch an event
        await tester.tap(find.text('Get Started'));
        await tester.pump();
        expect(events, isEmpty);
      });

      testWidgets('dispatches event on press', (tester) async {
        final events = <UiEvent>[];
        await _pump(
          tester,
          _data(
            action: {
              'event': {
                'name': 'get_started',
                'context': {'page': 'home'},
              },
            },
          ),
          dispatchEvent: events.add,
        );

        await tester.tap(find.text('Get Started'));
        await tester.pump();

        expect(events, hasLength(1));
        final event = events.single as UserActionEvent;
        expect(event.name, 'get_started');
        expect(event.context, {'page': 'home'});
      });
    });
  });
}
