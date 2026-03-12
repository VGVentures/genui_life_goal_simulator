import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(GCNSlider, () {
    group('basic variant', () {
      group('renders', () {
        testWidgets('title and subtitle', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: GCNSlider(
                title: 'Slider Title',
                subtitle: 'Dining • Feb 18',
                value: 450,
                min: 1,
                max: 1270,
                onChanged: (_) {},
              ),
            ),
          );

          expect(find.text('Slider Title'), findsOneWidget);
          expect(find.text('Dining • Feb 18'), findsOneWidget);
        });

        testWidgets('valueLabel in header', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: GCNSlider(
                title: 'Slider Title',
                subtitle: 'Dining • Feb 18',
                value: 450,
                min: 1,
                max: 1270,
                onChanged: (_) {},
                valueLabel: r'$450',
              ),
            ),
          );

          expect(find.text(r'$450'), findsOneWidget);
        });

        testWidgets('min and max labels', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: GCNSlider(
                title: 'Test',
                subtitle: 'Sub',
                value: 100,
                min: 1,
                max: 1270,
                onChanged: (_) {},
                minLabel: r'$1',
                maxLabel: r'$1270',
              ),
            ),
          );

          expect(find.text(r'$1'), findsOneWidget);
          expect(find.text(r'$1270'), findsOneWidget);
        });

        testWidgets('$Slider widget', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: GCNSlider(
                title: 'Test',
                subtitle: 'Sub',
                value: 500,
                min: 1,
                max: 1000,
                onChanged: (_) {},
              ),
            ),
          );

          expect(find.byType(Slider), findsOneWidget);
        });
      });

      testWidgets('omits valueLabel row entry when not provided', (
        tester,
      ) async {
        await tester.pumpApp(
          Scaffold(
            body: GCNSlider(
              title: 'Slider Title',
              subtitle: 'Sub',
              value: 100,
              min: 1,
              max: 1270,
              onChanged: (_) {},
            ),
          ),
        );

        // Title appears exactly once (no second Text from missing valueLabel).
        expect(find.text('Slider Title'), findsOneWidget);
      });

      testWidgets('calls onChanged when slider is dragged', (tester) async {
        var changed = false;
        await tester.pumpApp(
          Scaffold(
            body: GCNSlider(
              title: 'Test',
              subtitle: 'Sub',
              value: 500,
              min: 1,
              max: 1000,
              onChanged: (_) => changed = true,
            ),
          ),
        );

        await tester.drag(find.byType(Slider), const Offset(20, 0));
        expect(changed, isTrue);
      });
    });

    group('splits variant', () {
      group('', () {
        testWidgets('title and subtitle', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: GCNSlider(
                title: 'Slider Title',
                subtitle: 'Dining • Feb 18',
                value: 2,
                min: 1,
                max: 6,
                divisions: 5,
                splitLabels: const ['1', '2', '3', '4', '5', '6'],
                onChanged: (_) {},
              ),
            ),
          );

          expect(find.text('Slider Title'), findsOneWidget);
          expect(find.text('Dining • Feb 18'), findsOneWidget);
        });

        testWidgets('all split labels', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: GCNSlider(
                title: 'Slider Title',
                subtitle: 'Dining • Feb 18',
                value: 2,
                min: 1,
                max: 6,
                divisions: 5,
                splitLabels: const ['1', '2', '3', '4', '5', '6'],
                onChanged: (_) {},
              ),
            ),
          );

          for (final label in ['1', '2', '3', '4', '5', '6']) {
            expect(find.text(label), findsAtLeastNWidgets(1));
          }
        });
      });

      testWidgets('passes divisions to the Slider widget', (tester) async {
        await tester.pumpApp(
          Scaffold(
            body: GCNSlider(
              title: 'Test',
              subtitle: 'Sub',
              value: 1,
              min: 1,
              max: 6,
              divisions: 5,
              splitLabels: const ['1', '2', '3', '4', '5', '6'],
              onChanged: (_) {},
            ),
          ),
        );

        final slider = tester.widget<Slider>(find.byType(Slider));
        expect(slider.divisions, 5);
      });

      testWidgets('highlights the label matching current value', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme(LightThemeColors()).themeData,
            home: Scaffold(
              body: GCNSlider(
                title: 'Test',
                subtitle: 'Sub',
                value: 2,
                min: 1,
                max: 6,
                divisions: 5,
                splitLabels: const ['1', '2', '3', '4', '5', '6'],
                onChanged: (_) {},
              ),
            ),
          ),
        );

        // value=2, min=1, max=6 → index 1 → label '2' uses onSurface colour,
        // unselected labels use onSurfaceMuted (a different colour).
        final selected = tester.widget<Text>(find.text('2'));
        final unselected = tester.widget<Text>(find.text('3'));
        expect(
          selected.style?.color,
          isNot(equals(unselected.style?.color)),
        );
      });

      testWidgets('calls onChanged when slider is dragged', (tester) async {
        var changed = false;
        await tester.pumpApp(
          Scaffold(
            body: GCNSlider(
              title: 'Test',
              subtitle: 'Sub',
              value: 1,
              min: 1,
              max: 6,
              divisions: 5,
              splitLabels: const ['1', '2', '3', '4', '5', '6'],
              onChanged: (_) => changed = true,
            ),
          ),
        );

        await tester.drag(find.byType(Slider), const Offset(100, 0));
        expect(changed, isTrue);
      });
    });
  });
}
