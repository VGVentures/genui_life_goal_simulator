import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgv_genui_financial_advisor/design_system/app_colors.dart';
import 'package:vgv_genui_financial_advisor/design_system/breakpoints.dart';
import 'package:vgv_genui_financial_advisor/design_system/widgets/emoji_card.dart';

Widget _buildTestApp({required Widget child}) {
  return MaterialApp(
    theme: ThemeData(
      extensions: [LightThemeColors()],
    ),
    home: Scaffold(body: child),
  );
}

void addTeardownToResetView(WidgetTester tester) {
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

void main() {
  group('EmojiCard', () {
    testWidgets('renders emoji and label', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: const EmojiCard(emoji: '📊', label: 'Fixed costs'),
        ),
      );

      expect(find.text('📊'), findsOneWidget);
      expect(find.text('Fixed costs'), findsOneWidget);
    });

    testWidgets('default state has surface background and no visible border', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: const EmojiCard(emoji: '📊', label: 'Fixed costs'),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;

      expect(decoration.color, const Color(0xFFF7F6F7));
      expect(
        decoration.border,
        Border.all(color: Colors.transparent, width: 2),
      );
    });

    testWidgets(
      'selected state has primaryContainer background and primary border',
      (tester) async {
        await tester.pumpWidget(
          _buildTestApp(
            child: const EmojiCard(
              emoji: '📊',
              label: 'Fixed costs',
              isSelected: true,
            ),
          ),
        );

        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration! as BoxDecoration;

        expect(decoration.color, const Color(0xFFF3F6FF));
        expect(
          decoration.border,
          Border.all(color: const Color(0xFF6D92F5), width: 2),
        );
      },
    );

    testWidgets('wraps content in InkWell when onTap is provided', (
      tester,
    ) async {
      var tapped = false;

      await tester.pumpWidget(
        _buildTestApp(
          child: EmojiCard(
            emoji: '📊',
            label: 'Fixed costs',
            onTap: () => tapped = true,
          ),
        ),
      );

      expect(find.byType(InkWell), findsOneWidget);

      await tester.tap(find.byType(EmojiCard));
      expect(tapped, isTrue);
    });

    testWidgets('does not wrap in InkWell when onTap is null', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: const EmojiCard(emoji: '📊', label: 'Fixed costs'),
        ),
      );

      expect(find.byType(InkWell), findsNothing);
    });
  });

  group('EmojiCardLayout', () {
    final cards = [
      const EmojiCard(emoji: '📊', label: 'Fixed costs'),
      const EmojiCard(emoji: '💰', label: '% of income'),
      const EmojiCard(emoji: '🤝', label: 'Negotiable'),
      const EmojiCard(emoji: '💎', label: 'Potential Savings'),
    ];

    testWidgets('renders as Row on desktop', (tester) async {
      tester.view.physicalSize = const Size(Breakpoints.breakpoint, 800);
      tester.view.devicePixelRatio = 1;
      addTeardownToResetView(tester);

      await tester.pumpWidget(
        _buildTestApp(child: EmojiCardLayout(cards: cards)),
      );

      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(GridView), findsNothing);
      expect(find.byType(EmojiCard), findsNWidgets(4));
    });

    testWidgets('renders as GridView on mobile', (tester) async {
      tester.view.physicalSize = const Size(Breakpoints.breakpoint - 1, 800);
      tester.view.devicePixelRatio = 1;
      addTeardownToResetView(tester);

      await tester.pumpWidget(
        _buildTestApp(child: EmojiCardLayout(cards: cards)),
      );

      expect(find.byType(Row), findsNothing);
      expect(find.byType(EmojiCard), findsNWidgets(4));
    });

    testWidgets('desktop Row has Expanded children', (tester) async {
      tester.view.physicalSize = const Size(Breakpoints.breakpoint + 400, 800);
      tester.view.devicePixelRatio = 1;
      addTeardownToResetView(tester);

      await tester.pumpWidget(
        _buildTestApp(child: EmojiCardLayout(cards: cards)),
      );

      expect(find.byType(Expanded), findsNWidgets(cards.length));
    });
  });
}
