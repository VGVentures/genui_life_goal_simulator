import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

Future<void> _pumpSelector(WidgetTester tester, Widget widget) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: Scaffold(body: widget),
    ),
  );
}

void main() {
  const options = ['1M', '3M', '6M'];

  group(HeaderSelector, () {
    group('renders', () {
      testWidgets('all option labels', (tester) async {
        await _pumpSelector(
          tester,
          HeaderSelector(
            options: options,
            selectedIndex: 0,
            onChanged: (_) {},
          ),
        );

        for (final label in options) {
          expect(find.text(label), findsOneWidget);
        }
      });

      testWidgets('without $AppColors theme extension', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: HeaderSelector(
                options: options,
                selectedIndex: 0,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        expect(find.byType(HeaderSelector), findsOneWidget);
        for (final label in options) {
          expect(find.text(label), findsOneWidget);
        }
      });
    });

    group('applies', () {
      testWidgets('primary background and white text to selected chip', (
        tester,
      ) async {
        await _pumpSelector(
          tester,
          HeaderSelector(
            options: options,
            selectedIndex: 0,
            onChanged: (_) {},
          ),
        );

        final colors = LightThemeColors();

        // The first Ink widget corresponds to the selected chip (index 0).
        final firstInk = tester.widgetList<Ink>(find.byType(Ink)).first;
        final decoration = firstInk.decoration! as BoxDecoration;
        expect(decoration.color, colors.primary);
        expect(
          (decoration.border! as Border).top.color,
          Colors.transparent,
        );

        final selectedText = tester.widget<Text>(find.text('1M'));
        expect(selectedText.style?.color, colors.onPrimary);
      });

      testWidgets(
        'surface background and outlineVariant border to default chip',
        (tester) async {
          await _pumpSelector(
            tester,
            HeaderSelector(
              options: options,
              selectedIndex: 0,
              onChanged: (_) {},
            ),
          );

          final colors = LightThemeColors();

          // The second Ink widget corresponds to the unselected '3M' chip.
          final inks = tester.widgetList<Ink>(find.byType(Ink)).toList();
          final decoration = inks[1].decoration! as BoxDecoration;
          expect(decoration.color, colors.surface);
          expect(
            (decoration.border! as Border).top.color,
            colors.outlineVariant,
          );
        },
      );

      testWidgets('onSurfaceVariant text color to unselected chip', (
        tester,
      ) async {
        await _pumpSelector(
          tester,
          HeaderSelector(
            options: options,
            selectedIndex: 0,
            onChanged: (_) {},
          ),
        );

        final colors = LightThemeColors();
        final unselectedText = tester.widget<Text>(find.text('3M'));
        expect(unselectedText.style?.color, colors.onSurfaceVariant);
      });

      testWidgets('letterSpacing -0.15 on chip labels', (tester) async {
        await _pumpSelector(
          tester,
          HeaderSelector(
            options: options,
            selectedIndex: 0,
            onChanged: (_) {},
          ),
        );

        final texts = tester.widgetList<Text>(find.byType(Text));
        for (final text in texts) {
          expect(text.style?.letterSpacing, -0.15);
        }
      });
    });

    group('interaction', () {
      testWidgets('calls onChanged with correct index when chip is tapped', (
        tester,
      ) async {
        var tappedIndex = -1;

        await _pumpSelector(
          tester,
          HeaderSelector(
            options: options,
            selectedIndex: 0,
            onChanged: (i) => tappedIndex = i,
          ),
        );

        await tester.tap(find.text('3M'));
        expect(tappedIndex, 1);
      });

      testWidgets('calls onChanged with index 0 when first chip is tapped', (
        tester,
      ) async {
        var tappedIndex = -1;

        await _pumpSelector(
          tester,
          HeaderSelector(
            options: options,
            selectedIndex: 2,
            onChanged: (i) => tappedIndex = i,
          ),
        );

        await tester.tap(find.text('1M'));
        expect(tappedIndex, 0);
      });

      testWidgets('calls onChanged with last index when last chip is tapped', (
        tester,
      ) async {
        var tappedIndex = -1;

        await _pumpSelector(
          tester,
          HeaderSelector(
            options: options,
            selectedIndex: 0,
            onChanged: (i) => tappedIndex = i,
          ),
        );

        await tester.tap(find.text('6M'));
        expect(tappedIndex, 2);
      });

      testWidgets('updates selected chip when selectedIndex changes', (
        tester,
      ) async {
        var selectedIndex = 0;

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme(LightThemeColors()).themeData,
            home: StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  body: HeaderSelector(
                    options: options,
                    selectedIndex: selectedIndex,
                    onChanged: (i) => setState(() => selectedIndex = i),
                  ),
                );
              },
            ),
          ),
        );

        final colors = LightThemeColors();

        // Initially '1M' is selected.
        var inks = tester.widgetList<Ink>(find.byType(Ink)).toList();
        expect((inks[0].decoration! as BoxDecoration).color, colors.primary);
        expect((inks[1].decoration! as BoxDecoration).color, colors.surface);

        // Tap '3M' to move selection.
        await tester.tap(find.text('3M'));
        await tester.pump();

        inks = tester.widgetList<Ink>(find.byType(Ink)).toList();
        expect((inks[0].decoration! as BoxDecoration).color, colors.surface);
        expect((inks[1].decoration! as BoxDecoration).color, colors.primary);
      });
    });
  });
}
