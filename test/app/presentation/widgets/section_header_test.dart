import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpSectionHeader(
  WidgetTester tester,
  Widget widget, {
  Size size = const Size(800, 600),
}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: Scaffold(body: widget),
    ),
  );
}

void main() {
  group(SectionHeader, () {
    group('renders', () {
      testWidgets('title and subtitle text', (tester) async {
        await _pumpSectionHeader(
          tester,
          const SectionHeader(
            title: 'Your spending this month',
            subtitle: 'February 2026 • 19 days tracked',
          ),
        );

        expect(find.text('Your spending this month'), findsOneWidget);
        expect(find.text('February 2026 • 19 days tracked'), findsOneWidget);
      });

      testWidgets('with selector options', (tester) async {
        await _pumpSectionHeader(
          tester,
          SectionHeader(
            title: 'Your spending this month',
            subtitle: 'February 2026 • 19 days tracked',
            selectorOptions: const ['1M', '3M', '6M'],
            onSelectorChanged: (_) {},
          ),
        );

        expect(find.text('1M'), findsOneWidget);
        expect(find.text('3M'), findsOneWidget);
        expect(find.text('6M'), findsOneWidget);
        expect(find.byType(HeaderSelector), findsOneWidget);
      });

      testWidgets('without selector when selectorOptions is null', (
        tester,
      ) async {
        await _pumpSectionHeader(
          tester,
          const SectionHeader(
            title: 'Your spending this month',
            subtitle: 'February 2026 • 19 days tracked',
          ),
        );

        expect(find.byType(HeaderSelector), findsNothing);
      });

      testWidgets('without $AppColors theme extension', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SectionHeader(
                title: 'Test Title',
                subtitle: 'Test Subtitle',
                selectorOptions: const ['1M', '3M'],
                onSelectorChanged: (_) {},
              ),
            ),
          ),
        );

        expect(find.byType(SectionHeader), findsOneWidget);
        expect(find.text('Test Title'), findsOneWidget);
        expect(find.text('Test Subtitle'), findsOneWidget);
      });
    });

    group('styling', () {
      testWidgets('applies onSurface color to title', (tester) async {
        await _pumpSectionHeader(
          tester,
          const SectionHeader(
            title: 'Test Title',
            subtitle: 'Test Subtitle',
          ),
        );

        final colors = LightThemeColors();
        final titleText = tester.widget<Text>(find.text('Test Title'));
        expect(titleText.style?.color, colors.onSurface);
      });

      testWidgets('applies semibold weight to title', (tester) async {
        await _pumpSectionHeader(
          tester,
          const SectionHeader(
            title: 'Test Title',
            subtitle: 'Test Subtitle',
          ),
        );

        final titleText = tester.widget<Text>(find.text('Test Title'));
        expect(titleText.style?.fontWeight, FontWeight.w600);
      });

      testWidgets('applies onSurfaceVariant color to subtitle', (
        tester,
      ) async {
        await _pumpSectionHeader(
          tester,
          const SectionHeader(
            title: 'Test Title',
            subtitle: 'Test Subtitle',
          ),
        );

        final colors = LightThemeColors();
        final subtitleText = tester.widget<Text>(find.text('Test Subtitle'));
        expect(subtitleText.style?.color, colors.onSurfaceVariant);
      });

      testWidgets('has 56px height on desktop with selector', (tester) async {
        await _pumpSectionHeader(
          tester,
          SectionHeader(
            title: 'Test Title',
            subtitle: 'Test Subtitle',
            selectorOptions: const ['1M', '3M', '6M'],
            onSelectorChanged: (_) {},
          ),
        );

        final sizedBox = tester.widget<SizedBox>(
          find.ancestor(
            of: find.byType(Row),
            matching: find.byType(SizedBox),
          ),
        );
        expect(sizedBox.height, 56);
      });
    });

    group('responsive layout', () {
      testWidgets('shows horizontal layout on desktop', (tester) async {
        await _pumpSectionHeader(
          tester,
          SectionHeader(
            title: 'Your spending this month',
            subtitle: 'February 2026 • 19 days tracked',
            selectorOptions: const ['1M', '3M', '6M'],
            onSelectorChanged: (_) {},
          ),
        );

        expect(find.byType(Row), findsOneWidget);
      });

      testWidgets('shows vertical layout on mobile', (tester) async {
        await _pumpSectionHeader(
          tester,
          SectionHeader(
            title: 'Your spending this month',
            subtitle: 'February 2026 • 19 days tracked',
            selectorOptions: const ['1M', '3M', '6M'],
            onSelectorChanged: (_) {},
          ),
          size: const Size(400, 800),
        );

        final columns = find.byType(Column);
        expect(columns, findsWidgets);

        expect(
          find.descendant(
            of: columns.first,
            matching: find.byType(HeaderSelector),
          ),
          findsOneWidget,
        );
      });
    });

    group('interaction', () {
      testWidgets('calls onSelectorChanged when chip is tapped', (
        tester,
      ) async {
        var tappedIndex = -1;

        await _pumpSectionHeader(
          tester,
          SectionHeader(
            title: 'Your spending this month',
            subtitle: 'February 2026 • 19 days tracked',
            selectorOptions: const ['1M', '3M', '6M'],
            onSelectorChanged: (i) => tappedIndex = i,
          ),
        );

        await tester.tap(find.text('3M'));
        expect(tappedIndex, 1);
      });

      testWidgets('uses correct selectedIndex', (tester) async {
        await _pumpSectionHeader(
          tester,
          SectionHeader(
            title: 'Test',
            subtitle: 'Test Subtitle',
            selectorOptions: const ['1M', '3M', '6M'],
            selectedIndex: 2,
            onSelectorChanged: (_) {},
          ),
        );

        final colors = LightThemeColors();
        final inks = tester.widgetList<Ink>(find.byType(Ink)).toList();
        final selectedDecoration = inks[2].decoration! as BoxDecoration;
        expect(selectedDecoration.color, colors.primary);
      });
    });
  });
}
