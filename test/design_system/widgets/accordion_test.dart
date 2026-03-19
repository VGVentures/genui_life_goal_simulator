import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

Future<void> _pump(WidgetTester tester, Widget widget) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: Scaffold(body: SingleChildScrollView(child: widget)),
    ),
  );
}

void main() {
  group(AppAccordion, () {
    final content = ActionItemsGroup(
      items: [
        ActionItem(
          title: 'Restaurant',
          subtitle: 'Dining • Feb 18',
          amount: r'$450',
          delta: '+28%',
          trailing: FilledButton(
            onPressed: () {},
            child: const Text('Details'),
          ),
        ),
        ActionItem(
          title: 'Restaurant',
          subtitle: 'Dining • Feb 18',
          amount: r'$450',
          delta: '+28%',
          trailing: FilledButton(
            onPressed: () {},
            child: const Text('Details'),
          ),
        ),
      ],
    );

    group('collapsed state', () {
      testWidgets('renders title', (tester) async {
        await _pump(
          tester,
          AppAccordion(title: 'Accordion Title', content: content),
        );

        expect(find.text('Accordion Title'), findsOneWidget);
      });

      testWidgets('renders expand icon', (tester) async {
        await _pump(
          tester,
          AppAccordion(title: 'Accordion Title', content: content),
        );

        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      });

      testWidgets('adapts to available width', (tester) async {
        await _pump(
          tester,
          AppAccordion(title: 'Accordion Title', content: content),
        );

        final size = tester.getSize(find.byType(AppAccordion));
        expect(size.width, greaterThan(0));
      });

      testWidgets('has collapsed height approximately 56', (tester) async {
        await _pump(
          tester,
          AppAccordion(title: 'Accordion Title', content: content),
        );

        final size = tester.getSize(find.byType(AppAccordion));
        // Height is 56 + 2 (border) = 58
        expect(size.height, closeTo(56, 4));
      });

      testWidgets('content is not hittable when collapsed', (tester) async {
        await _pump(
          tester,
          AppAccordion(title: 'Accordion Title', content: content),
        );

        // Content should not be hittable when collapsed
        expect(
          find.text('Restaurant').hitTestable(),
          findsNothing,
        );
      });
    });

    group('open state', () {
      testWidgets('renders title', (tester) async {
        await _pump(
          tester,
          AppAccordion(
            title: 'Accordion Title',
            content: content,
            isExpanded: true,
          ),
        );

        expect(find.text('Accordion Title'), findsOneWidget);
      });

      testWidgets('shows action items when expanded', (tester) async {
        await _pump(
          tester,
          AppAccordion(
            title: 'Accordion Title',
            content: content,
            isExpanded: true,
          ),
        );

        expect(find.text('Restaurant'), findsNWidgets(2));
        expect(find.text(r'$450'), findsNWidgets(2));
      });

      testWidgets('content is hittable when expanded', (tester) async {
        await _pump(
          tester,
          AppAccordion(
            title: 'Accordion Title',
            content: content,
            isExpanded: true,
          ),
        );

        // Content should be hittable when expanded
        expect(
          find.text('Restaurant').hitTestable(),
          findsNWidgets(2),
        );
      });

      testWidgets('expands to fit content', (tester) async {
        await _pump(
          tester,
          AppAccordion(
            title: 'Accordion Title',
            content: content,
            isExpanded: true,
          ),
        );

        final size = tester.getSize(find.byType(AppAccordion));
        expect(size.width, greaterThan(0));
        expect(size.height, greaterThan(56));
      });
    });

    group('animation', () {
      testWidgets('expands when tapped', (tester) async {
        await _pump(
          tester,
          AppAccordion(title: 'Accordion Title', content: content),
        );

        // Initially collapsed - content not hittable
        expect(find.text('Restaurant').hitTestable(), findsNothing);

        // Tap to expand
        await tester.tap(find.text('Accordion Title'));
        await tester.pumpAndSettle();

        // Now expanded - content hittable
        expect(find.text('Restaurant').hitTestable(), findsNWidgets(2));
      });

      testWidgets('collapses when tapped again', (tester) async {
        await _pump(
          tester,
          AppAccordion(
            title: 'Accordion Title',
            content: content,
            isExpanded: true,
          ),
        );

        // Initially expanded - content hittable
        expect(find.text('Restaurant').hitTestable(), findsNWidgets(2));

        // Tap to collapse
        await tester.tap(find.text('Accordion Title'));
        await tester.pumpAndSettle();

        // Now collapsed - content not hittable
        expect(find.text('Restaurant').hitTestable(), findsNothing);
      });

      testWidgets('calls onToggle callback with true when expanding', (
        tester,
      ) async {
        var toggledValue = false;
        await _pump(
          tester,
          AppAccordion(
            title: 'Accordion Title',
            content: content,
            onToggle: (value) => toggledValue = value,
          ),
        );

        await tester.tap(find.text('Accordion Title'));
        await tester.pumpAndSettle();

        expect(toggledValue, isTrue);
      });

      testWidgets('calls onToggle callback with false when collapsing', (
        tester,
      ) async {
        var toggledValue = true;
        await _pump(
          tester,
          AppAccordion(
            title: 'Accordion Title',
            content: content,
            isExpanded: true,
            onToggle: (value) => toggledValue = value,
          ),
        );

        await tester.tap(find.text('Accordion Title'));
        await tester.pumpAndSettle();

        expect(toggledValue, isFalse);
      });

      testWidgets('icon rotates when expanded', (tester) async {
        await _pump(
          tester,
          AppAccordion(title: 'Accordion Title', content: content),
        );

        // Get initial rotation
        var rotation = tester.widget<RotationTransition>(
          find.descendant(
            of: find.byType(AppAccordion),
            matching: find.byType(RotationTransition),
          ),
        );
        expect(rotation.turns.value, 0);

        // Tap to expand
        await tester.tap(find.text('Accordion Title'));
        await tester.pumpAndSettle();

        // Check rotation after expansion
        rotation = tester.widget<RotationTransition>(
          find.descendant(
            of: find.byType(AppAccordion),
            matching: find.byType(RotationTransition),
          ),
        );
        expect(rotation.turns.value, 0.5);
      });
    });

    testWidgets('renders without error without AppColors extension', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppAccordion(
              title: 'Accordion Title',
              content: content,
            ),
          ),
        ),
      );

      expect(find.text('Accordion Title'), findsOneWidget);
    });

    testWidgets('updates when isExpanded prop changes', (tester) async {
      var isExpanded = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme(LightThemeColors()).themeData,
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => setState(() => isExpanded = !isExpanded),
                      child: const Text('Toggle'),
                    ),
                    AppAccordion(
                      title: 'Accordion Title',
                      content: content,
                      isExpanded: isExpanded,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      // Initially collapsed - content not hittable
      expect(find.text('Restaurant').hitTestable(), findsNothing);

      // Toggle via external control
      await tester.tap(find.text('Toggle'));
      await tester.pumpAndSettle();

      // Now expanded - content hittable
      expect(find.text('Restaurant').hitTestable(), findsNWidgets(2));
    });
  });
}
