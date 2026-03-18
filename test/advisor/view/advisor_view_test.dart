import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv_genui_financial_advisor/advisor/advisor.dart';
import 'package:vgv_genui_financial_advisor/l10n/l10n.dart';
import 'package:vgv_genui_financial_advisor/onboarding/pick_profile/models/profile_type.dart';

class _MockAdvisorBloc extends MockBloc<AdvisorEvent, AdvisorState>
    implements AdvisorBloc {}

class _MockSurfaceHost extends Mock implements SurfaceHost {}

const _testSurfaceSize = Size(1200, 800);

extension on WidgetTester {
  Future<void> pumpAdvisorView(AdvisorBloc bloc) async {
    view.physicalSize = _testSurfaceSize;
    view.devicePixelRatio = 1.0;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<AdvisorBloc>.value(
          value: bloc,
          child: const AdvisorView(profileType: ProfileType.optimizer),
        ),
      ),
    );
  }
}

void main() {
  late _MockAdvisorBloc bloc;

  setUpAll(() {
    registerFallbackValue(const AdvisorMessageSent(''));
  });

  setUp(() {
    bloc = _MockAdvisorBloc();
    when(() => bloc.state).thenReturn(const AdvisorState());
  });

  group(AdvisorView, () {
    testWidgets('shows loading indicator when pages are empty', (
      tester,
    ) async {
      await tester.pumpAdvisorView(bloc);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders message bubbles in PageView when pages exist', (
      tester,
    ) async {
      final host = _MockSurfaceHost();
      when(() => bloc.state).thenReturn(
        AdvisorState(
          status: AdvisorStatus.active,
          pages: const [
            [AiTextDisplayMessage('Hello')],
          ],
          host: host,
        ),
      );
      await tester.pumpAdvisorView(bloc);

      expect(find.byType(PageView), findsOneWidget);
      expect(find.byType(AdvisorMessageBubble), findsOneWidget);
      // Loading spinner should not be shown when pages exist
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows app bar with logo and profile chip', (tester) async {
      await tester.pumpAdvisorView(bloc);
      expect(find.textContaining('VGV'), findsOneWidget);
      expect(find.text('The Optimizer'), findsOneWidget);
      expect(find.text('Restart Demo'), findsOneWidget);
    });

    testWidgets('shows loading indicator on current page when loading', (
      tester,
    ) async {
      final host = _MockSurfaceHost();
      when(() => bloc.state).thenReturn(
        AdvisorState(
          status: AdvisorStatus.active,
          pages: const [[]],
          isLoading: true,
          host: host,
        ),
      );
      await tester.pumpAdvisorView(bloc);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('rebuilds when pages change', (tester) async {
      final host = _MockSurfaceHost();
      whenListen(
        bloc,
        Stream.fromIterable([
          AdvisorState(
            status: AdvisorStatus.active,
            pages: const [
              [AiTextDisplayMessage('Hello')],
            ],
            host: host,
          ),
        ]),
        initialState: AdvisorState(status: AdvisorStatus.active, host: host),
      );

      await tester.pumpAdvisorView(bloc);
      await tester.pump();

      expect(find.byType(AdvisorMessageBubble), findsOneWidget);
    });
  });
}
