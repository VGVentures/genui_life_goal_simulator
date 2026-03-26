import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/l10n/l10n.dart';
import 'package:genui_life_goal_simulator/onboarding/want_to_focus/view/widgets/focus_options_mobile.dart';
import 'package:genui_life_goal_simulator/onboarding/want_to_focus/want_to_focus.dart';
import 'package:mocktail/mocktail.dart';

class _MockWantToFocusCubit extends MockCubit<WantToFocusState>
    implements WantToFocusCubit {}

Future<void> _pump(WidgetTester tester, {required WantToFocusCubit cubit}) {
  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme(LightThemeColors()).themeData,
      home: BlocProvider<WantToFocusCubit>.value(
        value: cubit,
        child: const Scaffold(
          body: FocusOptionsMobile(),
        ),
      ),
    ),
  );
}

void main() {
  group(FocusOptionsMobile, () {
    late _MockWantToFocusCubit cubit;
    late AppLocalizations l10n;

    setUp(() async {
      cubit = _MockWantToFocusCubit();
      when(() => cubit.state).thenReturn(const WantToFocusState());
      l10n = await AppLocalizations.delegate.load(const Locale('en'));
    });

    testWidgets(
      'renders all option labels',
      (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await _pump(tester, cubit: cubit);
        await tester.pumpAndSettle();

        expect(find.text(l10n.everydaySpendingLabel), findsOneWidget);
        expect(find.text(l10n.saveForRetirementLabel), findsOneWidget);
        expect(find.text(l10n.mortgageLabel), findsOneWidget);
        expect(find.text(l10n.housingAndFixedCostsLabel), findsOneWidget);
        expect(find.text(l10n.healthcareAndInsuranceLabel), findsOneWidget);
        expect(find.text(l10n.writeYourOwnLabel), findsOneWidget);
      },
    );

    testWidgets(
      'tapping an option calls toggleOption on cubit',
      (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await _pump(tester, cubit: cubit);
        await tester.pumpAndSettle();

        await tester.tap(find.text(l10n.everydaySpendingLabel));
        await tester.pump();

        verify(
          () => cubit.toggleOption(FocusOption.everydaySpending),
        ).called(1);
      },
    );

    testWidgets(
      'typing in write-your-own calls setCustomOption',
      (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await _pump(tester, cubit: cubit);
        await tester.pumpAndSettle();

        await tester.tap(find.text(l10n.writeYourOwnLabel));
        await tester.pump();
        await tester.enterText(find.byType(TextField), 'custom');
        await tester.pump();

        verify(() => cubit.setCustomOption('custom')).called(1);
      },
    );
  });
}
