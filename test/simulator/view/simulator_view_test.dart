import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/l10n/l10n.dart';
import 'package:genui_life_goal_simulator/onboarding/pick_profile/models/profile_type.dart';
import 'package:genui_life_goal_simulator/simulator/simulator.dart';
import 'package:mocktail/mocktail.dart';

class _MockSimulatorBloc extends MockBloc<SimulatorEvent, SimulatorState>
    implements SimulatorBloc {}

class _MockSurfaceHost extends Mock implements SurfaceHost {}

const _testSurfaceSize = Size(1200, 800);

extension on WidgetTester {
  Future<void> pumpSimulatorView(
    SimulatorBloc bloc, {
    required SurfaceHost surfaceHost,
  }) async {
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
          child: SimulatorView(
            profileType: ProfileType.optimizer,
            surfaceHost: surfaceHost,
          ),
        ),
      ),
    );
  }
}

void main() {
  late _MockSimulatorBloc bloc;
  late _MockSurfaceHost surfaceHost;

  setUpAll(() {
    registerFallbackValue(const SimulatorMessageSent(''));
  });

  setUp(() {
    bloc = _MockSimulatorBloc();
    surfaceHost = _MockSurfaceHost();
    when(() => bloc.state).thenReturn(const SimulatorState());
  });

  group(SimulatorView, () {
    testWidgets('shows loading indicator when pages are empty', (
      tester,
    ) async {
      await tester.pumpSimulatorView(bloc, surfaceHost: surfaceHost);

      expect(find.byType(ThinkingAnimation), findsOneWidget);
    });

    testWidgets('renders message bubbles in PageView when pages exist', (
      tester,
    ) async {
      when(() => bloc.state).thenReturn(
        const SimulatorState(
          status: SimulatorStatus.active,
          pages: [
            [AiTextDisplayMessage('Hello')],
          ],
        ),
      );
      await tester.pumpSimulatorView(bloc, surfaceHost: surfaceHost);

      expect(find.byType(PageView), findsOneWidget);
      expect(find.byType(SimulatorMessageBubble), findsOneWidget);
      // Loading spinner should not be shown when pages exist
      expect(find.byType(ThinkingAnimation), findsNothing);
    });

    testWidgets('shows app bar with logo and profile chip', (tester) async {
      await tester.pumpSimulatorView(bloc, surfaceHost: surfaceHost);
      expect(find.textContaining('VGV'), findsOneWidget);
      expect(find.text('The Optimizer'), findsOneWidget);
      expect(find.text('Restart Demo'), findsOneWidget);
    });

    testWidgets('shows loading indicator on current page when loading', (
      tester,
    ) async {
      when(() => bloc.state).thenReturn(
        const SimulatorState(
          status: SimulatorStatus.active,
          pages: [[]],
          isLoading: true,
          pendingPageIndex: 0,
        ),
      );
      await tester.pumpSimulatorView(bloc, surfaceHost: surfaceHost);

      expect(find.byType(ThinkingAnimation), findsOneWidget);
    });

    testWidgets(
      'shows thinking animation during initial pending navigation',
      (tester) async {
        when(() => bloc.state).thenReturn(
          const SimulatorState(
            status: SimulatorStatus.active,
            pages: [
              [AiTextDisplayMessage('Hello')],
            ],
            isLoading: true,
            pendingPageIndex: 0,
          ),
        );
        await tester.pumpSimulatorView(bloc, surfaceHost: surfaceHost);

        // Only one page — user hasn't seen content yet, show thinking.
        expect(find.byType(ThinkingAnimation), findsOneWidget);
      },
    );

    testWidgets(
      'hides thinking animation during subsequent pending navigation',
      (tester) async {
        when(() => bloc.state).thenReturn(
          const SimulatorState(
            status: SimulatorStatus.active,
            pages: [
              [AiTextDisplayMessage('Hello')],
              [AiTextDisplayMessage('World')],
            ],
            isLoading: true,
            pendingPageIndex: 0,
          ),
        );
        await tester.pumpSimulatorView(bloc, surfaceHost: surfaceHost);

        // Multiple pages — user is viewing the first, no outer thinking.
        expect(find.byType(ThinkingAnimation), findsNothing);
      },
    );

    testWidgets('rebuilds when pages change', (tester) async {
      whenListen(
        bloc,
        Stream.fromIterable([
          const SimulatorState(
            status: SimulatorStatus.active,
            pages: [
              [AiTextDisplayMessage('Hello')],
            ],
          ),
        ]),
        initialState: const SimulatorState(status: SimulatorStatus.active),
      );

      await tester.pumpSimulatorView(bloc, surfaceHost: surfaceHost);
      await tester.pump();

      expect(find.byType(SimulatorMessageBubble), findsOneWidget);
    });

    testWidgets('renders error view when status is error', (tester) async {
      when(() => bloc.state).thenReturn(
        const SimulatorState(
          status: SimulatorStatus.error,
          error: 'something failed',
        ),
      );
      await tester.pumpSimulatorView(bloc, surfaceHost: surfaceHost);

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
    });

    testWidgets('shows loading overlay when showLoadingOverlay is true', (
      tester,
    ) async {
      when(() => bloc.state).thenReturn(
        const SimulatorState(
          status: SimulatorStatus.active,
          pages: [
            [AiTextDisplayMessage('Hello')],
          ],
          showLoadingOverlay: true,
        ),
      );
      await tester.pumpSimulatorView(bloc, surfaceHost: surfaceHost);

      expect(find.byType(LoadingOverlay), findsOneWidget);
    });
  });
}
