import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpCard(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  group('MetricCard', () {
    group('plain variant', () {
      testWidgets('renders label and value', (tester) async {
        await _pumpCard(
          tester,
          const MetricCard(label: 'Fixed costs', value: r'$4,319'),
        );

        expect(find.text('Fixed costs'), findsOneWidget);
        expect(find.text(r'$4,319'), findsOneWidget);
      });

      testWidgets('renders exactly 2 Text widgets when no delta or subtitle', (
        tester,
      ) async {
        await _pumpCard(
          tester,
          const MetricCard(label: 'Potential Savings', value: r'$94/mo'),
        );

        // label + value only
        expect(find.byType(Text), findsNWidgets(2));
      });

      testWidgets('is non-interactive when onTap is null', (tester) async {
        await _pumpCard(
          tester,
          const MetricCard(label: 'Fixed costs', value: r'$4,319'),
        );

        expect(find.byType(InkWell), findsNothing);
      });
    });

    group('subtitle', () {
      testWidgets('renders subtitle when provided', (tester) async {
        await _pumpCard(
          tester,
          const MetricCard(
            label: 'Fixed costs',
            value: r'$4,319',
            subtitle: 'vs last month',
          ),
        );

        expect(find.text('vs last month'), findsOneWidget);
      });

      testWidgets('renders exactly 3 Text widgets with subtitle but no delta', (
        tester,
      ) async {
        await _pumpCard(
          tester,
          const MetricCard(
            label: 'Potential Savings',
            value: r'$94/mo',
            subtitle: 'vs benchmarks',
          ),
        );

        // label + value + subtitle
        expect(find.byType(Text), findsNWidgets(3));
      });
    });

    group('Delta+ variant', () {
      testWidgets('renders delta text when provided', (tester) async {
        await _pumpCard(
          tester,
          const MetricCard(
            label: 'Negotiable',
            value: r'$645',
            delta: '+12%',
            deltaDirection: MetricDeltaDirection.positive,
          ),
        );

        expect(find.text('+12%'), findsOneWidget);
      });

      testWidgets('positive delta uses green colour', (tester) async {
        await _pumpCard(
          tester,
          const MetricCard(
            label: 'Negotiable',
            value: r'$645',
            delta: '+12%',
            deltaDirection: MetricDeltaDirection.positive,
          ),
        );

        final deltaText = tester
            .widgetList<Text>(find.byType(Text))
            .firstWhere((t) => t.data == '+12%');
        // LightThemeColors.success
        expect(deltaText.style?.color, const Color(0xFF00A65F));
      });

      testWidgets('renders 4 Text widgets with delta and subtitle', (
        tester,
      ) async {
        await _pumpCard(
          tester,
          const MetricCard(
            label: 'Negotiable',
            value: r'$645',
            delta: '+12%',
            deltaDirection: MetricDeltaDirection.positive,
            subtitle: r'+$40 above 3mo avg',
          ),
        );

        // label + value + delta + subtitle
        expect(find.byType(Text), findsNWidgets(4));
      });
    });

    group('Delta- variant', () {
      testWidgets('negative delta uses red colour', (tester) async {
        await _pumpCard(
          tester,
          const MetricCard(
            label: 'Fixed costs',
            value: r'$4,319',
            delta: r'$4,319',
            deltaDirection: MetricDeltaDirection.negative,
          ),
        );

        final allTexts = tester.widgetList<Text>(find.byType(Text)).toList();
        final deltaText = allTexts.last;
        // LightThemeColors.error
        expect(deltaText.style?.color, const Color(0xFFFF5446));
      });

      testWidgets('positive and negative deltas use different colours', (
        tester,
      ) async {
        Color? positiveColor;
        Color? negativeColor;

        await _pumpCard(
          tester,
          const MetricCard(
            label: 'A',
            value: '100',
            delta: '+5%',
            deltaDirection: MetricDeltaDirection.positive,
          ),
        );
        positiveColor = tester
            .widgetList<Text>(find.byType(Text))
            .firstWhere((t) => t.data == '+5%')
            .style
            ?.color;

        await _pumpCard(
          tester,
          const MetricCard(
            label: 'A',
            value: '100',
            delta: '-5%',
            deltaDirection: MetricDeltaDirection.negative,
          ),
        );
        negativeColor = tester
            .widgetList<Text>(find.byType(Text))
            .firstWhere((t) => t.data == '-5%')
            .style
            ?.color;

        expect(positiveColor, isNotNull);
        expect(negativeColor, isNotNull);
        expect(positiveColor, isNot(negativeColor));
      });
    });

    group('selected variant', () {
      testWidgets('renders without error in selected state', (tester) async {
        await _pumpCard(
          tester,
          const MetricCard(
            label: 'Fixed costs',
            value: r'$4,319',
            subtitle: 'vs last month',
            isSelected: true,
          ),
        );

        expect(find.text('Fixed costs'), findsOneWidget);
        expect(find.text(r'$4,319'), findsOneWidget);
        expect(find.text('vs last month'), findsOneWidget);
      });

      testWidgets(
        'selected and unselected cards have different border colours',
        (tester) async {
          Color? selectedBorderColor;
          Color? unselectedBorderColor;

          Future<Color?> borderColorOf({required bool selected}) async {
            await _pumpCard(
              tester,
              MetricCard(
                label: 'A',
                value: '1',
                isSelected: selected,
              ),
            );
            final container = tester.widget<Container>(
              find.byType(Container).first,
            );
            final decoration = container.decoration as BoxDecoration?;
            return (decoration?.border as Border?)?.top.color;
          }

          selectedBorderColor = await borderColorOf(selected: true);
          unselectedBorderColor = await borderColorOf(selected: false);

          expect(selectedBorderColor, isNotNull);
          expect(unselectedBorderColor, isNotNull);
          expect(selectedBorderColor, isNot(unselectedBorderColor));
        },
      );
    });

    group('interaction', () {
      testWidgets('calls onTap when tapped', (tester) async {
        var tapped = false;
        await _pumpCard(
          tester,
          MetricCard(
            label: 'Fixed costs',
            value: r'$4,319',
            onTap: () => tapped = true,
          ),
        );

        await tester.tap(find.byType(MetricCard));
        expect(tapped, isTrue);
      });

      testWidgets('wraps content in InkWell when onTap is provided', (
        tester,
      ) async {
        await _pumpCard(
          tester,
          MetricCard(
            label: 'Fixed costs',
            value: r'$4,319',
            onTap: () {},
          ),
        );

        expect(find.byType(InkWell), findsOneWidget);
      });
    });
  });

  group('MetricCardLayout', () {
    final cards = [
      const MetricCard(
        label: 'Fixed costs',
        value: r'$4,319',
        delta: r'$4,319',
        deltaDirection: MetricDeltaDirection.negative,
        subtitle: 'vs last month',
      ),
      const MetricCard(
        label: '% of income',
        value: r'$45%',
        delta: '+1.2%',
        deltaDirection: MetricDeltaDirection.negative,
        subtitle: 'benchmark 38%',
      ),
      const MetricCard(
        label: 'Negotiable',
        value: r'$645',
        delta: '+12%',
        deltaDirection: MetricDeltaDirection.positive,
        subtitle: r'+$40 above 3mo avg',
      ),
      const MetricCard(
        label: 'Potential Savings',
        value: r'$94/mo',
        subtitle: 'vs benchmarks',
      ),
    ];

    Widget buildLayout() => MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: Scaffold(body: MetricCardsLayout(cards: cards)),
    );

    testWidgets('renders all card labels on desktop', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildLayout());

      expect(find.text('Fixed costs'), findsOneWidget);
      expect(find.text('% of income'), findsOneWidget);
      expect(find.text('Negotiable'), findsOneWidget);
      expect(find.text('Potential Savings'), findsOneWidget);
    });

    testWidgets('uses horizontal Row on desktop', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildLayout());

      expect(find.byType(Row), findsWidgets);
      expect(find.byType(GridView), findsNothing);
    });

    testWidgets('uses Column on mobile', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildLayout());

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('renders all card labels on mobile', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildLayout());
      await tester.pump();

      expect(find.text('Fixed costs'), findsOneWidget);
      expect(find.text('% of income'), findsOneWidget);
    });
  });
}
