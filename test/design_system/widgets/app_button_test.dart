import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/l10n/l10n.dart';

Future<void> _pump(WidgetTester tester, Widget widget) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: Center(child: widget)),
    ),
  );
}

void main() {
  group(AppButton, () {
    group('filled variant', () {
      testWidgets('renders FilledButton with label', (tester) async {
        await _pump(
          tester,
          AppButton(label: 'Continue', onPressed: () {}),
        );

        expect(find.byType(FilledButton), findsOneWidget);
        expect(find.text('Continue'), findsOneWidget);
      });

      testWidgets('calls onPressed when tapped', (tester) async {
        var tapped = false;
        await _pump(
          tester,
          AppButton(label: 'Tap me', onPressed: () => tapped = true),
        );

        await tester.tap(find.byType(FilledButton));
        expect(tapped, isTrue);
      });

      testWidgets('renders no OutlinedButton', (tester) async {
        await _pump(
          tester,
          AppButton(label: 'Continue', onPressed: () {}),
        );

        expect(find.byType(OutlinedButton), findsNothing);
      });
    });

    group('outlined variant', () {
      testWidgets('renders OutlinedButton with label', (tester) async {
        await _pump(
          tester,
          AppButton(
            label: 'Cancel',
            variant: AppButtonVariant.outlined,
            onPressed: () {},
          ),
        );

        expect(find.byType(OutlinedButton), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('calls onPressed when tapped', (tester) async {
        var tapped = false;
        await _pump(
          tester,
          AppButton(
            label: 'Tap me',
            variant: AppButtonVariant.outlined,
            onPressed: () => tapped = true,
          ),
        );

        await tester.tap(find.byType(OutlinedButton));
        expect(tapped, isTrue);
      });

      testWidgets('renders no FilledButton', (tester) async {
        await _pump(
          tester,
          AppButton(
            label: 'Cancel',
            variant: AppButtonVariant.outlined,
            onPressed: () {},
          ),
        );

        expect(find.byType(FilledButton), findsNothing);
      });
    });

    group('sizes', () {
      testWidgets('large size renders at 48px height', (tester) async {
        await _pump(
          tester,
          AppButton(label: 'Large', onPressed: () {}),
        );

        final button = tester.getSize(find.byType(FilledButton));
        expect(button.height, 48);
      });

      testWidgets('small size renders with 48px touch target', (
        tester,
      ) async {
        await _pump(
          tester,
          AppButton(
            label: 'Small',
            size: AppButtonSize.small,
            onPressed: () {},
          ),
        );

        // Visual height is 40px but tapTargetSize.padded ensures 48px.
        final button = tester.getSize(find.byType(FilledButton));
        expect(button.height, 48);
      });
    });

    group('icons', () {
      testWidgets('renders leading icon', (tester) async {
        await _pump(
          tester,
          AppButton(
            label: 'Add',
            leadingIcon: const Icon(Icons.add),
            onPressed: () {},
          ),
        );

        expect(find.byIcon(Icons.add), findsOneWidget);
      });

      testWidgets('renders trailing icon', (tester) async {
        await _pump(
          tester,
          AppButton(
            label: 'Next',
            trailingIcon: const Icon(Icons.arrow_forward),
            onPressed: () {},
          ),
        );

        expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      });
    });

    group('disabled state', () {
      testWidgets('renders disabled FilledButton when onPressed is null', (
        tester,
      ) async {
        await _pump(
          tester,
          const AppButton(label: 'Disabled'),
        );

        final button = tester.widget<FilledButton>(
          find.byType(FilledButton),
        );
        expect(button.onPressed, isNull);
      });

      testWidgets(
        'renders disabled OutlinedButton when onPressed is null',
        (tester) async {
          await _pump(
            tester,
            const AppButton(
              label: 'Disabled',
              variant: AppButtonVariant.outlined,
            ),
          );

          final button = tester.widget<OutlinedButton>(
            find.byType(OutlinedButton),
          );
          expect(button.onPressed, isNull);
        },
      );
    });

    group('loading state', () {
      testWidgets('shows CircularProgressIndicator', (tester) async {
        await _pump(
          tester,
          const AppButton(label: 'Submit', isLoading: true),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('shows Loading... text', (tester) async {
        await _pump(
          tester,
          const AppButton(label: 'Submit', isLoading: true),
        );

        expect(find.text('Loading...'), findsOneWidget);
      });

      testWidgets('does not show original label', (tester) async {
        await _pump(
          tester,
          const AppButton(label: 'Submit', isLoading: true),
        );

        expect(find.text('Submit'), findsNothing);
      });

      testWidgets('does not trigger onPressed when tapped', (tester) async {
        var tapped = false;
        await _pump(
          tester,
          AppButton(
            label: 'Submit',
            isLoading: true,
            onPressed: () => tapped = true,
          ),
        );

        await tester.tap(find.byType(FilledButton));
        expect(tapped, isFalse);
      });

      testWidgets(
        'renders with outlined variant',
        (tester) async {
          await _pump(
            tester,
            const AppButton(
              label: 'Submit',
              variant: AppButtonVariant.outlined,
              isLoading: true,
            ),
          );

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          expect(find.byType(OutlinedButton), findsOneWidget);
        },
      );
    });

    testWidgets('renders without error without AppColors extension', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: AppButton(label: 'Fallback', onPressed: () {}),
          ),
        ),
      );

      expect(find.text('Fallback'), findsOneWidget);
    });
  });
}
