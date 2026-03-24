import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/l10n/l10n.dart';
import 'package:genui_life_goal_simulator/onboarding/pick_profile/models/profile_type.dart';
import 'package:genui_life_goal_simulator/onboarding/want_to_focus/models/focus_option.dart';
import 'package:genui_life_goal_simulator/simulator/simulator.dart';
import 'package:mocktail/mocktail.dart';

class _MockSimulatorBloc extends MockBloc<SimulatorEvent, SimulatorState>
    implements SimulatorBloc {}

void main() {
  group(SimulatorPage, () {
    test('is a $StatelessWidget and holds onboarding data', () {
      const page = SimulatorPage(
        profileType: ProfileType.beginner,
        focusOptions: {FocusOption.mortgage},
        customOption: 'custom',
      );

      expect(page, isA<StatelessWidget>());
      expect(page.profileType, ProfileType.beginner);
      expect(page.focusOptions, {FocusOption.mortgage});
      expect(page.customOption, 'custom');
    });

    testWidgets('provides $SimulatorBloc and renders $SimulatorView', (
      tester,
    ) async {
      final bloc = _MockSimulatorBloc();
      when(() => bloc.state).thenReturn(const SimulatorState());

      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SimulatorPage(
            profileType: ProfileType.beginner,
            simulatorBloc: bloc,
          ),
        ),
      );

      expect(find.byType(SimulatorView), findsOneWidget);
    });
  });
}
