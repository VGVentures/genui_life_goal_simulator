import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

Future<void> _pumpCard(WidgetTester tester, Widget widget) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: Scaffold(body: widget),
    ),
  );
}

void main() {
  group(RadioCard, () {
    group('renders', () {
      testWidgets('label text', (tester) async {
        await _pumpCard(
          tester,
          RadioCard(
            label: 'Test Label',
            isSelected: false,
            onTap: () {},
          ),
        );

        expect(find.text('Test Label'), findsOneWidget);
      });

      testWidgets('$Radio with groupValue true when selected', (
        tester,
      ) async {
        await _pumpCard(
          tester,
          RadioCard(
            label: 'Selected',
            isSelected: true,
            onTap: () {},
          ),
        );

        final radioGroup = tester.widget<RadioGroup<bool>>(
          find.byType(RadioGroup<bool>),
        );
        expect(radioGroup.groupValue, isTrue);
      });

      testWidgets('$Radio with groupValue false when unselected', (
        tester,
      ) async {
        await _pumpCard(
          tester,
          RadioCard(
            label: 'Unselected',
            isSelected: false,
            onTap: () {},
          ),
        );

        final radioGroup = tester.widget<RadioGroup<bool>>(
          find.byType(RadioGroup<bool>),
        );
        expect(radioGroup.groupValue, isFalse);
      });

      testWidgets(
        'without $AppColors theme extension',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: RadioCard(
                  label: 'No Theme',
                  isSelected: true,
                  onTap: () {},
                ),
              ),
            ),
          );

          expect(find.text('No Theme'), findsOneWidget);
          expect(find.byType(RadioCard), findsOneWidget);
        },
      );
    });

    group('applies', () {
      testWidgets(
        'selected background and border when isSelected is true',
        (tester) async {
          await _pumpCard(
            tester,
            RadioCard(
              label: 'Selected',
              isSelected: true,
              onTap: () {},
            ),
          );

          final ink = tester.widget<Ink>(find.byType(Ink));
          final decoration = ink.decoration! as BoxDecoration;
          final colors = LightThemeColors();

          expect(decoration.color, colors.primaryContainer);
          expect(
            (decoration.border! as Border).top.color,
            colors.primary,
          );
        },
      );

      testWidgets(
        'unselected background and transparent border '
        'when isSelected is false',
        (tester) async {
          await _pumpCard(
            tester,
            RadioCard(
              label: 'Unselected',
              isSelected: false,
              onTap: () {},
            ),
          );

          final ink = tester.widget<Ink>(find.byType(Ink));
          final decoration = ink.decoration! as BoxDecoration;
          final colors = LightThemeColors();

          expect(decoration.color, colors.onPrimary);
          expect(
            (decoration.border! as Border).top.color,
            Colors.transparent,
          );
        },
      );

      testWidgets('text color from theme', (tester) async {
        await _pumpCard(
          tester,
          RadioCard(
            label: 'Styled',
            isSelected: false,
            onTap: () {},
          ),
        );

        final text = tester.widget<Text>(find.text('Styled'));
        final colors = LightThemeColors();
        expect(text.style?.color, colors.onSurface);
      });
    });

    testWidgets('calls onTap callback when tapped', (tester) async {
      var tapped = false;
      await _pumpCard(
        tester,
        RadioCard(
          label: 'Tappable',
          isSelected: false,
          onTap: () => tapped = true,
        ),
      );

      await tester.tap(find.text('Tappable'));
      expect(tapped, isTrue);
    });

    testWidgets(
      'falls back to transparent border color '
      'when selected without $AppColors extension',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RadioCard(
                label: 'Fallback',
                isSelected: true,
                onTap: () {},
              ),
            ),
          ),
        );

        final ink = tester.widget<Ink>(find.byType(Ink));
        final decoration = ink.decoration! as BoxDecoration;

        expect(
          (decoration.border! as Border).top.color,
          Colors.transparent,
        );
      },
    );
  });
}
