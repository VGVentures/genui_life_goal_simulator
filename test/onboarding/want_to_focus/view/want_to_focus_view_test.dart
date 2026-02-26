import 'package:bloc_test/bloc_test.dart';
import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:finance_app/onboarding/want_to_focus/view/widgets/focus_options_desktop.dart';
import 'package:finance_app/onboarding/want_to_focus/view/widgets/focus_options_mobile.dart';
import 'package:finance_app/onboarding/want_to_focus/want_to_focus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockWantToFocusCubit extends MockCubit<WantToFocusState>
    implements WantToFocusCubit {}

Future<void> _pump(
  WidgetTester tester, {
  required WantToFocusCubit cubit,
  Size size = const Size(800, 1000),
}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme(LightThemeColors()).themeData,
      home: BlocProvider<WantToFocusCubit>.value(
        value: cubit,
        child: const Scaffold(
          body: WantToFocusView(),
        ),
      ),
    ),
  );
}

void main() {
  group(WantToFocusView, () {
    late _MockWantToFocusCubit cubit;

    setUp(() {
      cubit = _MockWantToFocusCubit();
      when(() => cubit.state).thenReturn(const WantToFocusState());
    });

    group('renders', () {
      testWidgets(
        'title and desktop options on wide screen',
        (tester) async {
          await _pump(tester, cubit: cubit);
          await tester.pumpAndSettle();

          expect(
            find.byType(FocusOptionsDesktop),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'title and mobile options on narrow screen',
        (tester) async {
          await _pump(tester, cubit: cubit, size: const Size(400, 800));
          await tester.pumpAndSettle();

          expect(
            find.byType(FocusOptionsMobile),
            findsOneWidget,
          );
        },
      );
    });
  });
}
