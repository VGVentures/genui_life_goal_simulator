import 'package:bloc_test/bloc_test.dart';
import 'package:finance_app/chat/bloc/bloc.dart';
import 'package:finance_app/chat/chat.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:finance_app/onboarding/pick_profile/models/profile_type.dart';
import 'package:finance_app/onboarding/want_to_focus/models/focus_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockChatBloc extends MockBloc<ChatEvent, ChatState>
    implements ChatBloc {}

void main() {
  group(ChatPage, () {
    test('is a $StatelessWidget and holds onboarding data', () {
      const page = ChatPage(
        profileType: ProfileType.beginner,
        focusOptions: {FocusOption.mortgage},
        customOption: 'custom',
      );

      expect(page, isA<StatelessWidget>());
      expect(page.profileType, ProfileType.beginner);
      expect(page.focusOptions, {FocusOption.mortgage});
      expect(page.customOption, 'custom');
    });

    testWidgets('provides $ChatBloc and renders $ChatView', (tester) async {
      final bloc = _MockChatBloc();
      when(() => bloc.state).thenReturn(const ChatState());

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChatPage(
            profileType: ProfileType.beginner,
            chatBloc: bloc,
          ),
        ),
      );

      expect(find.byType(ChatView), findsOneWidget);
    });
  });
}
