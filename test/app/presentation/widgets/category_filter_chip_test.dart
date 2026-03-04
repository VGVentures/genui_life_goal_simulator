import 'package:finance_app/app/presentation/app_colors.dart';
import 'package:finance_app/app/presentation/widgets/category_filter_chip.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final colors = LightThemeColors();

  Future<void> pump(
    WidgetTester tester, {
    FilterChipColor color = FilterChipColor.pink,
    bool? isSelected,
    bool isEnabled = true,
    VoidCallback? onTap,
    String label = 'Category 1',
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: [colors],
        ),
        home: Scaffold(
          body: CategoryFilterChip(
            color: color,
            label: label,
            isSelected: isSelected,
            isEnabled: isEnabled,
            onTap: onTap,
          ),
        ),
      ),
    );
  }

  BoxDecoration getDecoration(WidgetTester tester) {
    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(CategoryFilterChip),
        matching: find.byType(Container),
      ),
    );
    return container.decoration! as BoxDecoration;
  }

  Color? getTextColor(WidgetTester tester, String label) {
    return tester.widget<Text>(find.text(label)).style?.color;
  }

  group('CategoryFilterChip', () {
    testWidgets('renders label text', (tester) async {
      await pump(tester);
      expect(find.text('Category 1'), findsOneWidget);
    });

    group('unselected state (isSelected: false)', () {
      testWidgets('shows white background when not hovered', (tester) async {
        await pump(tester, isSelected: false);
        expect(getDecoration(tester).color, equals(colors.surfaceVariant));
      });

      testWidgets('shows 1px solid color border', (tester) async {
        await pump(tester, isSelected: false);
        final base = colors.pinkColor;
        final border = getDecoration(tester).border! as Border;
        expect(border.top.color, equals(base));
        expect(border.top.width, equals(1.0));
      });

      testWidgets('shows dark text', (tester) async {
        await pump(tester, isSelected: false);
        expect(
          getTextColor(tester, 'Category 1'),
          equals(colors.onSurfaceVariant),
        );
      });
    });

    group('selected state (isSelected: true)', () {
      testWidgets('shows solid base color background with no border', (
        tester,
      ) async {
        await pump(tester, isSelected: true);
        final base = colors.pinkColor;
        final decoration = getDecoration(tester);
        expect(decoration.color, equals(base));
        expect(decoration.border, isNull);
      });

      testWidgets('shows white text for standard colors', (tester) async {
        await pump(tester, isSelected: true);
        expect(getTextColor(tester, 'Category 1'), equals(colors.onPrimary));
      });

      testWidgets('shows dark text for aqua variant', (tester) async {
        await pump(tester, color: FilterChipColor.aqua, isSelected: true);
        expect(
          getTextColor(tester, 'Category 1'),
          equals(colors.onSurfaceVariant),
        );
      });

      testWidgets('shows dark text for lightOlive variant', (tester) async {
        await pump(tester, color: FilterChipColor.lightOlive, isSelected: true);
        expect(
          getTextColor(tester, 'Category 1'),
          equals(colors.onSurfaceVariant),
        );
      });
    });

    group('disabled unselected state', () {
      testWidgets('shows grey background', (tester) async {
        await pump(tester, isSelected: false, isEnabled: false);
        expect(getDecoration(tester).color, equals(colors.surfaceContainer));
      });

      testWidgets('shows grey border', (tester) async {
        await pump(tester, isSelected: false, isEnabled: false);
        final border = getDecoration(tester).border! as Border;
        expect(border.top.color, equals(colors.outlineVariant));
      });

      testWidgets('shows muted text', (tester) async {
        await pump(tester, isSelected: false, isEnabled: false);
        expect(
          getTextColor(tester, 'Category 1'),
          equals(colors.onSurfaceDisabled),
        );
      });

      testWidgets('does not call onTap when tapped', (tester) async {
        var tapped = false;
        await pump(tester, isEnabled: false, onTap: () => tapped = true);
        await tester.tap(find.byType(CategoryFilterChip));
        expect(tapped, isFalse);
      });
    });

    group('disabled selected state', () {
      testWidgets('shows darker grey background with no border', (
        tester,
      ) async {
        await pump(tester, isSelected: true, isEnabled: false);
        final decoration = getDecoration(tester);
        expect(decoration.color, equals(colors.surfaceContainerHigh));
        expect(decoration.border, isNull);
      });

      testWidgets('shows muted text', (tester) async {
        await pump(tester, isSelected: true, isEnabled: false);
        expect(
          getTextColor(tester, 'Category 1'),
          equals(colors.onSurfaceDisabled),
        );
      });
    });

    group('interaction', () {
      testWidgets('calls onTap when tapped and enabled', (tester) async {
        var tapped = false;
        await pump(tester, onTap: () => tapped = true);
        await tester.tap(find.byType(CategoryFilterChip));
        expect(tapped, isTrue);
      });

      testWidgets('shows 15% tint on hover when unselected', (tester) async {
        await pump(tester, isSelected: false);
        final base = colors.pinkColor;

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);
        await tester.pump();

        await gesture.moveTo(tester.getCenter(find.byType(CategoryFilterChip)));
        await tester.pump();

        expect(
          getDecoration(tester).color,
          equals(base.withValues(alpha: 0.15)),
        );
      });

      testWidgets('reverts to white background when mouse exits', (
        tester,
      ) async {
        await pump(tester, isSelected: false);

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);
        await tester.pump();

        await gesture.moveTo(tester.getCenter(find.byType(CategoryFilterChip)));
        await tester.pump();
        await gesture.moveTo(const Offset(1000, 1000));
        await tester.pump();

        expect(
          getDecoration(tester).color,
          equals(colors.surfaceVariant),
        );
      });
    });

    group('pill shape', () {
      testWidgets('has 32px border radius', (tester) async {
        await pump(tester);
        expect(
          getDecoration(tester).borderRadius,
          equals(BorderRadius.circular(32)),
        );
      });
    });

    group('color variants sampling', () {
      final colorToAppColor = {
        FilterChipColor.pink: colors.pinkColor,
        FilterChipColor.mustard: colors.mustardColor,
        FilterChipColor.deepRed: colors.deepRedColor,
        FilterChipColor.lightBlue: colors.lightBlueColor,
        FilterChipColor.emerald: colors.emeraldColor,
      };

      for (final entry in colorToAppColor.entries) {
        testWidgets('${entry.key} selected shows correct color', (
          tester,
        ) async {
          await pump(tester, color: entry.key, isSelected: true);
          expect(
            getDecoration(tester).color,
            equals(entry.value),
          );
        });
      }
    });
  });
}
