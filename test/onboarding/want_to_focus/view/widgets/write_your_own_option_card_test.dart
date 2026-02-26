import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/onboarding/want_to_focus/view/widgets/write_your_own_option_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpCard(
  WidgetTester tester,
  Widget widget,
) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: Scaffold(body: widget),
    ),
  );
}

void main() {
  group(WriteYourOwnOptionCard, () {
    testWidgets(
      'renders label with pencil icon and normal weight',
      (tester) async {
        await _pumpCard(
          tester,
          const WriteYourOwnOptionCard(
            label: 'Write your own...',
          ),
        );

        expect(
          find.text('Write your own...'),
          findsOneWidget,
        );
        expect(find.byType(Image), findsOneWidget);
      },
    );

    testWidgets(
      'tap enters editing, onChanged fires, '
      'submit exits and shows typed text',
      (tester) async {
        String? lastValue;
        await _pumpCard(
          tester,
          WriteYourOwnOptionCard(
            label: 'Write your own...',
            onChanged: (v) => lastValue = v,
          ),
        );

        // Tap to enter editing mode
        await tester.tap(
          find.byType(WriteYourOwnOptionCard),
        );
        await tester.pump();
        expect(find.byType(TextField), findsOneWidget);

        // Type triggers onChanged
        await tester.enterText(
          find.byType(TextField),
          'my goal',
        );
        await tester.pump();
        expect(lastValue, 'my goal');

        // Submit exits editing
        await tester.testTextInput.receiveAction(
          TextInputAction.done,
        );
        await tester.pump();

        expect(find.byType(TextField), findsNothing);
        expect(find.text('my goal'), findsOneWidget);
        expect(find.byType(Image), findsNothing);
      },
    );

    testWidgets(
      'focus loss while editing exits editing mode',
      (tester) async {
        await _pumpCard(
          tester,
          const WriteYourOwnOptionCard(
            label: 'Write your own...',
          ),
        );

        await tester.tap(
          find.byType(WriteYourOwnOptionCard),
        );
        await tester.pump();
        expect(find.byType(TextField), findsOneWidget);

        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pump();

        expect(find.byType(TextField), findsNothing);
      },
    );

    testWidgets(
      'applies mobile dimensions when screen width is below threshold',
      (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await _pumpCard(
          tester,
          const WriteYourOwnOptionCard(
            label: 'Write your own...',
          ),
        );

        final text = tester.widget<Text>(
          find.text('Write your own...'),
        );
        expect(text.style?.fontSize, 18);

        // Enter editing for mobile TextField coverage
        await tester.tap(
          find.byType(WriteYourOwnOptionCard),
        );
        await tester.pump();
        expect(find.byType(TextField), findsOneWidget);
      },
    );

    testWidgets(
      'renders without AppColors theme extension',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: WriteYourOwnOptionCard(
                label: 'Write your own...',
              ),
            ),
          ),
        );

        expect(
          find.text('Write your own...'),
          findsOneWidget,
        );
      },
    );
  });
}
