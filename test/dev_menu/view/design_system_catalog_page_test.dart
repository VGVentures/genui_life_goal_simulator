import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/dev_menu/dev_menu.dart';
import 'package:genui_life_goal_simulator/l10n/l10n.dart';

Future<void> _pumpPage(WidgetTester tester) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const DesignSystemCatalogPage(),
    ),
  );
}

Future<void> _scrollTo(WidgetTester tester, String text) async {
  await tester.dragUntilVisible(
    find.text(text),
    find.byType(ListView),
    const Offset(0, -100),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('DesignSystemCatalogPage', () {
    testWidgets('renders Design System app bar title', (tester) async {
      await _pumpPage(tester);

      expect(find.text('Design System'), findsOneWidget);
    });

    testWidgets('renders ActionItem list tile', (tester) async {
      await _pumpPage(tester);

      expect(find.text('ActionItem'), findsOneWidget);
    });

    testWidgets('tapping ActionItem navigates to ActionItemCatalogPage', (
      tester,
    ) async {
      await _pumpPage(tester);

      await tester.tap(find.text('ActionItem'));
      await tester.pumpAndSettle();

      expect(find.byType(ActionItemCatalogPage), findsOneWidget);
    });

    testWidgets('renders AiButton list tile', (tester) async {
      await _pumpPage(tester);

      expect(find.text('AiButton'), findsOneWidget);
    });

    testWidgets('tapping AiButton navigates to AiButtonCatalogPage', (
      tester,
    ) async {
      await _pumpPage(tester);

      await tester.tap(find.text('AiButton'));
      await tester.pumpAndSettle();

      expect(find.byType(AiButtonCatalogPage), findsOneWidget);
    });

    testWidgets('renders AppButton list tile', (tester) async {
      await _pumpPage(tester);

      expect(find.text('AppButton'), findsOneWidget);
    });

    testWidgets('tapping AppButton navigates to AppButtonCatalogPage', (
      tester,
    ) async {
      await _pumpPage(tester);

      await tester.tap(find.text('AppButton'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(AppButtonCatalogPage), findsOneWidget);
    });

    testWidgets('renders CategoryFilterChip list tile', (tester) async {
      await _pumpPage(tester);

      expect(find.text('CategoryFilterChip'), findsOneWidget);
    });

    testWidgets(
      'tapping CategoryFilterChip navigates to '
      'CategoryFilterChipCatalogPage',
      (tester) async {
        await _pumpPage(tester);

        await tester.tap(find.text('CategoryFilterChip'));
        await tester.pumpAndSettle();

        expect(find.byType(CategoryFilterChipCatalogPage), findsOneWidget);
      },
    );

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

    testWidgets('renders FilterBar list tile', (tester) async {
      await _pumpPage(tester);

      await _scrollTo(tester, 'FilterBar');

      expect(find.text('FilterBar'), findsOneWidget);
    });

    testWidgets('tapping FilterBar navigates to FilterBarCatalogPage', (
      tester,
    ) async {
      await _pumpPage(tester);
      await _scrollTo(tester, 'FilterBar');
      await tester.tap(find.text('FilterBar'));
      await tester.pumpAndSettle();
      expect(find.byType(FilterBarCatalogPage), findsOneWidget);
    });

    testWidgets('renders ProgressBar list tile', (tester) async {
      await _pumpPage(tester);

      await _scrollTo(tester, 'ProgressBar');

      expect(find.text('ProgressBar'), findsOneWidget);
    });

    testWidgets('tapping ProgressBar navigates to ProgressBarCatalogPage', (
      tester,
    ) async {
      await _pumpPage(tester);
      await _scrollTo(tester, 'ProgressBar');
      await tester.tap(find.text('ProgressBar'));
      await tester.pumpAndSettle();
      expect(find.byType(ProgressBarCatalogPage), findsOneWidget);
    });

    testWidgets('renders HeaderSelector list tile', (tester) async {
      await _pumpPage(tester);

      await _scrollTo(tester, 'HeaderSelector');

      expect(find.text('HeaderSelector'), findsOneWidget);
    });

    testWidgets(
      'tapping HeaderSelector navigates to HeaderSelectorCatalogPage',
      (tester) async {
        await _pumpPage(tester);
        await _scrollTo(tester, 'HeaderSelector');
        await tester.tap(find.text('HeaderSelector'));
        await tester.pumpAndSettle();
        expect(find.byType(HeaderSelectorCatalogPage), findsOneWidget);
      },
    );

    testWidgets('renders HorizontalBar list tile', (tester) async {
      await _pumpPage(tester);

      await _scrollTo(tester, 'HorizontalBar');

      expect(find.text('HorizontalBar'), findsOneWidget);
    });

    testWidgets(
      'tapping HorizontalBar navigates to HorizontalBarCatalogPage',
      (tester) async {
        await _pumpPage(tester);
        await _scrollTo(tester, 'HorizontalBar');
        await tester.tap(find.text('HorizontalBar'));
        await tester.pumpAndSettle();
        expect(find.byType(HorizontalBarCatalogPage), findsOneWidget);
      },
    );

    testWidgets('renders MetricCard list tile', (tester) async {
      await _pumpPage(tester);

      await _scrollTo(tester, 'MetricCard');

      expect(find.text('MetricCard'), findsOneWidget);
    });

    testWidgets('tapping MetricCard navigates to MetricCardCatalogPage', (
      tester,
    ) async {
      await _pumpPage(tester);
      await _scrollTo(tester, 'MetricCard');
      await tester.tap(find.text('MetricCard'));
      await tester.pumpAndSettle();
      expect(find.byType(MetricCardCatalogPage), findsOneWidget);
    });

    testWidgets('renders RadioCard list tile', (tester) async {
      await _pumpPage(tester);

      await _scrollTo(tester, 'RadioCard');

      expect(find.text('RadioCard'), findsOneWidget);
    });

    testWidgets('tapping RadioCard navigates to RadioCardCatalogPage', (
      tester,
    ) async {
      await _pumpPage(tester);
      await _scrollTo(tester, 'RadioCard');
      await tester.tap(find.text('RadioCard'));
      await tester.pumpAndSettle();
      expect(find.byType(RadioCardCatalogPage), findsOneWidget);
    });

    testWidgets('renders Ranked Table list tile', (tester) async {
      await _pumpPage(tester);

      await _scrollTo(tester, 'Ranked Table');

      expect(find.text('Ranked Table'), findsOneWidget);
    });

    testWidgets('tapping Ranked Table navigates to RankedTablePage', (
      tester,
    ) async {
      await _pumpPage(tester);
      await _scrollTo(tester, 'Ranked Table');
      await tester.tap(find.text('Ranked Table'));
      await tester.pumpAndSettle();
      expect(find.byType(RankedTablePage), findsOneWidget);
    });

    testWidgets('renders LineChart list tile', (tester) async {
      await _pumpPage(tester);

      await _scrollTo(tester, 'LineChart');

      expect(find.text('LineChart'), findsOneWidget);
    });

    testWidgets('tapping LineChart navigates to LineChartCatalogPage', (
      tester,
    ) async {
      await _pumpPage(tester);
      await _scrollTo(tester, 'LineChart');
      await tester.tap(find.text('LineChart'));
      await tester.pumpAndSettle();
      expect(find.byType(LineChartCatalogPage), findsOneWidget);
    });

    testWidgets('renders SectionHeader list tile', (tester) async {
      await _pumpPage(tester);

      await _scrollTo(tester, 'SectionHeader');

      expect(find.text('SectionHeader'), findsOneWidget);
    });

    testWidgets('tapping SectionHeader navigates to SectionHeaderCatalogPage', (
      tester,
    ) async {
      await _pumpPage(tester);
      await _scrollTo(tester, 'SectionHeader');
      await tester.tap(find.text('SectionHeader'));
      await tester.pumpAndSettle();
      expect(find.byType(SectionHeaderCatalogPage), findsOneWidget);
    });

    testWidgets('renders Transaction List list tile', (tester) async {
      await _pumpPage(tester);

      await _scrollTo(tester, 'Transaction List');

      expect(find.text('Transaction List'), findsOneWidget);
    });

    testWidgets(
      'tapping Transaction List navigates to TransactionListCatalogPage',
      (tester) async {
        await _pumpPage(tester);
        await _scrollTo(tester, 'Transaction List');
        await tester.tap(find.text('Transaction List'));
        await tester.pumpAndSettle();
        expect(find.byType(TransactionListCatalogPage), findsOneWidget);
      },
    );

    testWidgets('renders Pie Chart list tile', (tester) async {
      await _pumpPage(tester);

      await _scrollTo(tester, 'Pie Chart');

      expect(find.text('Pie Chart'), findsOneWidget);
    });

    testWidgets('tapping Pie Chart navigates to PieChartCatalogPage', (
      tester,
    ) async {
      await _pumpPage(tester);
      await _scrollTo(tester, 'Pie Chart');
      await tester.tap(find.text('Pie Chart'));
      await tester.pumpAndSettle();
      expect(find.byType(PieChartCatalogPage), findsOneWidget);
    });

    testWidgets('renders Comparison Table list tile', (tester) async {
      await _pumpPage(tester);

      await _scrollTo(tester, 'Comparison Table');

      expect(find.text('Comparison Table'), findsOneWidget);
    });

    testWidgets(
      'tapping Comparison Table navigates to ComparisonTableCatalogPage',
      (tester) async {
        await _pumpPage(tester);
        await _scrollTo(tester, 'Comparison Table');
        await tester.tap(find.text('Comparison Table'));
        await tester.pumpAndSettle();
        expect(find.byType(ComparisonTableCatalogPage), findsOneWidget);
      },
    );

    testWidgets('renders Slider list tile', (tester) async {
      await _pumpPage(tester);

      await _scrollTo(tester, 'Slider');

      expect(find.text('Slider'), findsOneWidget);
    });

    testWidgets('tapping Slider navigates to SliderCatalogPage', (
      tester,
    ) async {
      await _pumpPage(tester);
      await _scrollTo(tester, 'Slider');
      await tester.tap(find.text('Slider'));
      await tester.pumpAndSettle();
      expect(find.byType(SliderCatalogPage), findsOneWidget);
    });

    testWidgets('renders Loading Animation list tile', (tester) async {
      await _pumpPage(tester);

      await _scrollTo(tester, 'Loading Animation');

      expect(find.text('Loading Animation'), findsOneWidget);
    });

    // Navigation tests for Loading Animation and Thinking Animation are
    // skipped because Rive native runtime is unavailable in test.

    testWidgets('renders Thinking Animation list tile', (tester) async {
      await _pumpPage(tester);

      await _scrollTo(tester, 'Thinking Animation');

      expect(find.text('Thinking Animation'), findsOneWidget);
    });
  });
}
