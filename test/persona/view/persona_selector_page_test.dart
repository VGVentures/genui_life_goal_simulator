import 'package:finance_app/chat/chat.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:finance_app/persona/persona.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockNavigatorObserver extends Mock implements NavigatorObserver {}

class _FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeRoute());
  });

  group(PersonaSelectorPage, () {
    testWidgets('renders $AppBar with title and all $PersonaCard items', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: PersonaSelectorPage(),
        ),
      );

      expect(find.byType(PersonaCard), findsNWidgets(scenarios.length));
    });

    test('scenarios list contains 4 personas', () {
      expect(scenarios, hasLength(4));
    });

    testWidgets('tapping $PersonaCard navigates to $ChatPage', (
      tester,
    ) async {
      final observer = _MockNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const PersonaSelectorPage(),
          navigatorObservers: [observer],
        ),
      );

      reset(observer);

      await tester.tap(find.byType(PersonaCard).first);

      verify(() => observer.didPush(any(), any())).called(1);
    });
  });
}
