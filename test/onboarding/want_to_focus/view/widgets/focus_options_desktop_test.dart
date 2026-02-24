import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:finance_app/onboarding/want_to_focus/view/widgets/focus_options_desktop.dart';
import 'package:finance_app/onboarding/want_to_focus/want_to_focus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester) {
  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme(LightThemeColors()).themeData,
      home: BlocProvider(
        create: (_) => WantToFocusCubit(),
        child: const Scaffold(
          body: FocusOptionsDesktop(),
        ),
      ),
    ),
  );
}

void main() {
  group(FocusOptionsDesktop, () {
    testWidgets(
      'renders all options and handles interactions',
      (tester) async {
        await _pump(tester);
        await tester.pumpAndSettle();

        // All labels rendered
        expect(
          find.text('Everyday spending'),
          findsOneWidget,
        );
        expect(
          find.text('Housing & Fixed Costs'),
          findsOneWidget,
        );

        // Tap each selectable option
        for (final label in [
          'Everyday spending',
          'Save for retirement',
          'Mortgage',
          'Housing & Fixed Costs',
          'Healthcare & insurance',
        ]) {
          await tester.tap(find.text(label));
          await tester.pump();
        }

        // Type in write-your-own
        await tester.tap(
          find.text('Write your own...'),
        );
        await tester.pump();
        await tester.enterText(
          find.byType(TextField),
          'custom',
        );
        await tester.pump();
      },
    );
  });
}
