import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgv_genui_financial_advisor/design_system/app_colors.dart';
import 'package:vgv_genui_financial_advisor/design_system/widgets/category_filter_chip.dart';
import 'package:vgv_genui_financial_advisor/design_system/widgets/filter_bar.dart';

void main() {
  final colors = LightThemeColors();

  List<FilterCategory> createCategories({
    List<bool>? selected,
  }) {
    final categoryColors = [
      FilterChipColor.mustard,
      FilterChipColor.lightBlue,
      FilterChipColor.brightOrange,
      FilterChipColor.lightOlive,
      FilterChipColor.aqua,
      FilterChipColor.emerald,
    ];

    selected ??= List.filled(categoryColors.length, false);

    return List.generate(
      categoryColors.length,
      (i) => FilterCategory(
        label: 'Category ${i + 1}',
        color: categoryColors[i],
        isSelected: selected![i],
      ),
    );
  }

  Future<void> pump(
    WidgetTester tester, {
    List<FilterCategory>? categories,
    ValueChanged<int>? onCategoryToggled,
    VoidCallback? onAllToggled,
    bool isAllEnabled = true,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: [colors],
        ),
        home: Scaffold(
          body: FilterBar(
            categories: categories ?? createCategories(),
            onCategoryToggled: onCategoryToggled ?? (_) {},
            onAllToggled: onAllToggled ?? () {},
            isAllEnabled: isAllEnabled,
          ),
        ),
      ),
    );
  }

  group('FilterBar', () {
    group('renders', () {
      testWidgets('all category chips', (tester) async {
        await pump(tester);

        for (var i = 1; i <= 6; i++) {
          expect(find.text('Category $i'), findsOneWidget);
        }
      });

      testWidgets('All chip', (tester) async {
        await pump(tester);

        expect(find.text('All'), findsOneWidget);
      });

      testWidgets('selection count text showing 0 selected', (tester) async {
        await pump(tester);

        expect(find.text('0 of 6 categories selected'), findsOneWidget);
      });

      testWidgets('selection count text showing 3 selected', (tester) async {
        await pump(
          tester,
          categories: createCategories(
            selected: [true, true, true, false, false, false],
          ),
        );

        expect(find.text('3 of 6 categories selected'), findsOneWidget);
      });

      testWidgets('selection count text showing all selected', (tester) async {
        await pump(
          tester,
          categories: createCategories(
            selected: [true, true, true, true, true, true],
          ),
        );

        expect(find.text('6 of 6 categories selected'), findsOneWidget);
      });
    });

    group('All chip state', () {
      testWidgets('shows All as unselected when no categories selected', (
        tester,
      ) async {
        await pump(
          tester,
          categories: createCategories(
            selected: [false, false, false, false, false, false],
          ),
        );

        final allChip = tester.widget<CategoryFilterChip>(
          find.ancestor(
            of: find.text('All'),
            matching: find.byType(CategoryFilterChip),
          ),
        );

        expect(allChip.isSelected, isFalse);
      });

      testWidgets('shows All as unselected when some categories selected', (
        tester,
      ) async {
        await pump(
          tester,
          categories: createCategories(
            selected: [true, true, false, false, false, false],
          ),
        );

        final allChip = tester.widget<CategoryFilterChip>(
          find.ancestor(
            of: find.text('All'),
            matching: find.byType(CategoryFilterChip),
          ),
        );

        expect(allChip.isSelected, isFalse);
      });

      testWidgets('shows All as selected when all categories selected', (
        tester,
      ) async {
        await pump(
          tester,
          categories: createCategories(
            selected: [true, true, true, true, true, true],
          ),
        );

        final allChip = tester.widget<CategoryFilterChip>(
          find.ancestor(
            of: find.text('All'),
            matching: find.byType(CategoryFilterChip),
          ),
        );

        expect(allChip.isSelected, isTrue);
      });

      testWidgets('shows All as disabled when isAllEnabled is false', (
        tester,
      ) async {
        await pump(
          tester,
          isAllEnabled: false,
        );

        final allChip = tester.widget<CategoryFilterChip>(
          find.ancestor(
            of: find.text('All'),
            matching: find.byType(CategoryFilterChip),
          ),
        );

        expect(allChip.isEnabled, isFalse);
      });

      testWidgets('does not call onAllToggled when All chip is disabled', (
        tester,
      ) async {
        var allTapped = false;

        await pump(
          tester,
          onAllToggled: () => allTapped = true,
          isAllEnabled: false,
        );

        await tester.tap(find.text('All'));
        expect(allTapped, isFalse);
      });
    });

    group('interaction', () {
      testWidgets('calls onCategoryToggled with correct index when tapped', (
        tester,
      ) async {
        var tappedIndex = -1;

        await pump(
          tester,
          onCategoryToggled: (i) => tappedIndex = i,
        );

        await tester.tap(find.text('Category 3'));
        expect(tappedIndex, 2);
      });

      testWidgets('calls onAllToggled when All chip is tapped', (
        tester,
      ) async {
        var allTapped = false;

        await pump(
          tester,
          onAllToggled: () => allTapped = true,
        );

        await tester.tap(find.text('All'));
        expect(allTapped, isTrue);
      });

      testWidgets('updates selection when categories change', (tester) async {
        var categories = createCategories();

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: [colors],
            ),
            home: StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  body: FilterBar(
                    categories: categories,
                    onCategoryToggled: (i) {
                      setState(() {
                        categories = List.generate(
                          categories.length,
                          (index) => categories[index].copyWith(
                            isSelected: index == i
                                ? !categories[index].isSelected
                                : categories[index].isSelected,
                          ),
                        );
                      });
                    },
                    onAllToggled: () {},
                  ),
                );
              },
            ),
          ),
        );

        expect(find.text('0 of 6 categories selected'), findsOneWidget);

        await tester.tap(find.text('Category 1'));
        await tester.pump();

        expect(find.text('1 of 6 categories selected'), findsOneWidget);
      });
    });

    group('layout', () {
      testWidgets('renders wrapped chips layout', (tester) async {
        await pump(tester);

        expect(find.byType(Wrap), findsOneWidget);
      });
    });

    group('chip colors', () {
      testWidgets('renders chips with correct colors', (tester) async {
        final categories = [
          const FilterCategory(
            label: 'Mustard',
            color: FilterChipColor.mustard,
          ),
          const FilterCategory(
            label: 'LightBlue',
            color: FilterChipColor.lightBlue,
          ),
        ];

        await pump(tester, categories: categories);

        final mustardChip = tester.widget<CategoryFilterChip>(
          find.ancestor(
            of: find.text('Mustard'),
            matching: find.byType(CategoryFilterChip),
          ),
        );
        expect(mustardChip.color, FilterChipColor.mustard);

        final lightBlueChip = tester.widget<CategoryFilterChip>(
          find.ancestor(
            of: find.text('LightBlue'),
            matching: find.byType(CategoryFilterChip),
          ),
        );
        expect(lightBlueChip.color, FilterChipColor.lightBlue);
      });

      testWidgets('renders disabled category chip', (tester) async {
        final categories = [
          const FilterCategory(
            label: 'Enabled',
            color: FilterChipColor.mustard,
          ),
          const FilterCategory(
            label: 'Disabled',
            color: FilterChipColor.lightBlue,
            isEnabled: false,
          ),
        ];

        await pump(tester, categories: categories);

        final enabledChip = tester.widget<CategoryFilterChip>(
          find.ancestor(
            of: find.text('Enabled'),
            matching: find.byType(CategoryFilterChip),
          ),
        );
        expect(enabledChip.isEnabled, isTrue);

        final disabledChip = tester.widget<CategoryFilterChip>(
          find.ancestor(
            of: find.text('Disabled'),
            matching: find.byType(CategoryFilterChip),
          ),
        );
        expect(disabledChip.isEnabled, isFalse);
      });
    });

    group('empty state', () {
      testWidgets('renders with empty categories', (tester) async {
        await pump(
          tester,
          categories: [],
        );

        expect(find.text('0 of 0 categories selected'), findsOneWidget);
      });

      testWidgets('All chip is not selected with empty categories', (
        tester,
      ) async {
        await pump(
          tester,
          categories: [],
        );

        final allChip = tester.widget<CategoryFilterChip>(
          find.ancestor(
            of: find.text('All'),
            matching: find.byType(CategoryFilterChip),
          ),
        );

        expect(allChip.isSelected, isFalse);
      });
    });
  });
}
