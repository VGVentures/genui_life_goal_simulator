import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';
import 'package:vgv_genui_financial_advisor/l10n/l10n.dart';
import 'package:vgv_genui_financial_advisor/onboarding/pick_profile/models/profile_type.dart';
import 'package:vgv_genui_financial_advisor/onboarding/want_to_focus/want_to_focus.dart';
import 'package:vgv_genui_financial_advisor/onboarding/widgets/widgets.dart';

Future<void> _pump(
  WidgetTester tester, {
  Size size = const Size(800, 600),
  ThemeData? theme,
}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: theme ?? AppTheme(LightThemeColors()).themeData,
      home: const WantToFocusPage(profileType: ProfileType.beginner),
    ),
  );
}

void main() {
  group(WantToFocusPage, () {
    testWidgets(
      'renders on desktop with Floating Action Button and WantToFocusView',
      (tester) async {
        await _pump(tester);
        await tester.pumpAndSettle();

        expect(
          find.byType(WantToFocusView),
          findsOneWidget,
        );
        expect(
          find.byType(OnboardingNextButton),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders on mobile with smaller Floating Action Button',
      (tester) async {
        await _pump(tester, size: const Size(400, 800));
        await tester.pumpAndSettle();

        expect(
          find.byType(WantToFocusView),
          findsOneWidget,
        );
        expect(
          find.byType(OnboardingNextButton),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'FAB tap does not throw',
      (tester) async {
        await _pump(tester);
        await tester.pumpAndSettle();

        await tester.tap(find.byType(OnboardingNextButton));
      },
    );

    testWidgets(
      'renders without $AppColors theme extension',
      (tester) async {
        await _pump(tester, theme: ThemeData());
        await tester.pumpAndSettle();

        expect(
          find.byType(WantToFocusPage),
          findsOneWidget,
        );

        await tester.tap(find.byType(OnboardingNextButton));
      },
    );
  });
}
