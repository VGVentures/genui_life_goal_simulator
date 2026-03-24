import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/l10n/l10n.dart';
import 'package:genui_life_goal_simulator/onboarding/pick_profile/models/profile_type.dart';
import 'package:genui_life_goal_simulator/simulator/simulator.dart';
import 'package:mocktail/mocktail.dart';

class _MockSimulatorBloc extends MockBloc<SimulatorEvent, SimulatorState>
    implements SimulatorBloc {}

class _MockSurfaceHost extends Mock implements SurfaceHost {}

const _testSurfaceSize = Size(1200, 800);

extension on WidgetTester {
  Future<void> pumpSimulatorView(SimulatorBloc bloc) async {
    view.physicalSize = _testSurfaceSize;
    view.devicePixelRatio = 1.0;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<SimulatorBloc>.value(
          value: bloc,
          child: const SimulatorView(profileType: ProfileType.optimizer),
        ),
      ),
    );
  }
}

void main() {
  late _MockSimulatorBloc bloc;

  setUpAll(() {
    registerFallbackValue(const SimulatorMessageSent(''));
  });

  setUp(() {
    bloc = _MockSimulatorBloc();
    when(() => bloc.state).thenReturn(const SimulatorState());
  });

  group(SimulatorView, () {
    testWidgets('shows loading indicator when pages are empty', (
      tester,
    ) async {
      await tester.pumpSimulatorView(bloc);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders message bubbles in PageView when pages exist', (
      tester,
    ) async {
      final host = _MockSurfaceHost();
      when(() => bloc.state).thenReturn(
        SimulatorState(
          status: SimulatorStatus.active,
          pages: const [
            [AiTextDisplayMessage('Hello')],
          ],
          host: host,
        ),
      );
      await tester.pumpSimulatorView(bloc);

      expect(find.byType(PageView), findsOneWidget);
      expect(find.byType(SimulatorMessageBubble), findsOneWidget);
      // Loading spinner should not be shown when pages exist
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows app bar with logo and profile chip', (tester) async {
      await tester.pumpSimulatorView(bloc);
      expect(find.textContaining('VGV'), findsOneWidget);
      expect(find.text('The Optimizer'), findsOneWidget);
      expect(find.text('Restart Demo'), findsOneWidget);
    });

    testWidgets('shows loading indicator on current page when loading', (
      tester,
    ) async {
      final host = _MockSurfaceHost();
      when(() => bloc.state).thenReturn(
        SimulatorState(
          status: SimulatorStatus.active,
          pages: const [[]],
          isLoading: true,
          host: host,
        ),
      );
      await tester.pumpSimulatorView(bloc);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('rebuilds when pages change', (tester) async {
      final host = _MockSurfaceHost();
      whenListen(
        bloc,
        Stream.fromIterable([
          SimulatorState(
            status: SimulatorStatus.active,
            pages: const [
              [AiTextDisplayMessage('Hello')],
            ],
            host: host,
          ),
        ]),
        initialState: SimulatorState(
          status: SimulatorStatus.active,
          host: host,
        ),
      );

      await tester.pumpSimulatorView(bloc);
      await tester.pump();

      expect(find.byType(SimulatorMessageBubble), findsOneWidget);
    });
  });
}
