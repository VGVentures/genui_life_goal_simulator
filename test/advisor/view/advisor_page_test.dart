import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv_genui_financial_advisor/advisor/advisor.dart';
import 'package:vgv_genui_financial_advisor/l10n/l10n.dart';
import 'package:vgv_genui_financial_advisor/onboarding/pick_profile/models/profile_type.dart';
import 'package:vgv_genui_financial_advisor/onboarding/want_to_focus/models/focus_option.dart';

class _MockAdvisorBloc extends MockBloc<AdvisorEvent, AdvisorState>
    implements AdvisorBloc {}

void main() {
  group(AdvisorPage, () {
    test('is a $StatelessWidget and holds onboarding data', () {
      const page = AdvisorPage(
        profileType: ProfileType.beginner,
        focusOptions: {FocusOption.mortgage},
        customOption: 'custom',
      );

      expect(page, isA<StatelessWidget>());
      expect(page.profileType, ProfileType.beginner);
      expect(page.focusOptions, {FocusOption.mortgage});
      expect(page.customOption, 'custom');
    });

    testWidgets('provides $AdvisorBloc and renders $AdvisorView', (
      tester,
    ) async {
      final bloc = _MockAdvisorBloc();
      when(() => bloc.state).thenReturn(const AdvisorState());

      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AdvisorPage(
            profileType: ProfileType.beginner,
            advisorBloc: bloc,
          ),
        ),
      );

      expect(find.byType(AdvisorView), findsOneWidget);
    });
  });
}
