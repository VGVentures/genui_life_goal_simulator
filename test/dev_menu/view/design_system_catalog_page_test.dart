import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/dev_menu/dev_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpPage(WidgetTester tester) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: const DesignSystemCatalogPage(),
    ),
  );
}

void main() {
  group('DesignSystemCatalogPage', () {
    testWidgets('renders Design System app bar title', (tester) async {
      await _pumpPage(tester);

      expect(find.text('Design System'), findsOneWidget);
    });

    testWidgets('renders MetricCard list tile', (tester) async {
      await _pumpPage(tester);

      await tester.dragUntilVisible(
        find.text('MetricCard'),
        find.byType(ListView),
        const Offset(0, -100),
      );
      expect(find.text('MetricCard'), findsOneWidget);
    });

    testWidgets('tapping MetricCard navigates to MetricCardCatalogPage', (
      tester,
    ) async {
      await _pumpPage(tester);

      await tester.dragUntilVisible(
        find.text('MetricCard'),
        find.byType(ListView),
        const Offset(0, -100),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('MetricCard'));
      await tester.pumpAndSettle();

      expect(find.byType(MetricCardCatalogPage), findsOneWidget);
    });

    testWidgets('renders Accordion list tile', (tester) async {
      await _pumpPage(tester);

      expect(find.text('Accordion'), findsOneWidget);
    });

    testWidgets('tapping Accordion navigates to AccordionCatalogPage', (
      tester,
    ) async {
      await _pumpPage(tester);

      await tester.tap(find.text('Accordion'));
      await tester.pumpAndSettle();

      expect(find.byType(AccordionCatalogPage), findsOneWidget);
    });

    testWidgets('renders EmojiCard list tile', (tester) async {
      await _pumpPage(tester);

      expect(find.text('EmojiCard'), findsOneWidget);
    });

    testWidgets('tapping EmojiCard navigates to EmojiCardCatalogPage', (
      tester,
    ) async {
      await _pumpPage(tester);

      await tester.tap(find.text('EmojiCard'));
      await tester.pumpAndSettle();

      expect(find.byType(EmojiCardCatalogPage), findsOneWidget);
    });

    testWidgets('renders RadioCard list tile', (tester) async {
      await _pumpPage(tester);

      await tester.dragUntilVisible(
        find.text('RadioCard'),
        find.byType(ListView),
        const Offset(0, -100),
      );

      expect(find.text('RadioCard'), findsOneWidget);
    });

    testWidgets('tapping RadioCard navigates to RadioCardCatalogPage', (
      tester,
    ) async {
      await _pumpPage(tester);

      await tester.dragUntilVisible(
        find.text('RadioCard'),
        find.byType(ListView),
        const Offset(0, -100),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('RadioCard'));
      await tester.pumpAndSettle();

      expect(find.byType(RadioCardCatalogPage), findsOneWidget);
    });

    testWidgets('renders SectionHeader list tile', (tester) async {
      await _pumpPage(tester);

      await tester.dragUntilVisible(
        find.text('SectionHeader'),
        find.byType(ListView),
        const Offset(0, -100),
      );

      expect(find.text('SectionHeader'), findsOneWidget);
    });

    testWidgets('tapping SectionHeader navigates to SectionHeaderCatalogPage', (
      tester,
    ) async {
      await _pumpPage(tester);
      await tester.dragUntilVisible(
        find.text('SectionHeader'),
        find.byType(ListView),
        const Offset(0, -100),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('SectionHeader'));
      await tester.pumpAndSettle();
      expect(find.byType(SectionHeaderCatalogPage), findsOneWidget);
    });

    testWidgets('renders FilterBar list tile', (tester) async {
      await _pumpPage(tester);

      await tester.dragUntilVisible(
        find.text('FilterBar'),
        find.byType(ListView),
        const Offset(0, -100),
      );

      expect(find.text('FilterBar'), findsOneWidget);
    });

    testWidgets('tapping FilterBar navigates to FilterBarCatalogPage', (
      tester,
    ) async {
      await _pumpPage(tester);
      await tester.dragUntilVisible(
        find.text('FilterBar'),
        find.byType(ListView),
        const Offset(0, -100),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('FilterBar'));
      await tester.pumpAndSettle();
      expect(find.byType(FilterBarCatalogPage), findsOneWidget);
    });
  });
}
