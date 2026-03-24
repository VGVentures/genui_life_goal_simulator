import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

Future<void> _pumpButton(WidgetTester tester, Widget widget) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: Scaffold(body: Center(child: widget)),
    ),
  );
}

void main() {
  group(AiButton, () {
    testWidgets('renders text and sparkle icon', (tester) async {
      await _pumpButton(
        tester,
        AiButton(
          text: "What's eating my money?",
          onTap: () {},
        ),
      );

      expect(find.text("What's eating my money?"), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('renders text with correct style', (tester) async {
      await _pumpButton(
        tester,
        AiButton(
          text: 'Test prompt',
          onTap: () {},
        ),
      );

      final text = tester.widget<Text>(find.text('Test prompt'));
      expect(text.style?.fontWeight, FontWeight.w500);
      expect(text.style?.fontSize, 16);
      expect(text.style?.color, const Color(0xFF1A1C1C));
    });

    testWidgets('calls onTap callback when tapped', (tester) async {
      var tapped = false;
      await _pumpButton(
        tester,
        AiButton(
          text: 'Tap me',
          onTap: () => tapped = true,
        ),
      );

      await tester.tap(find.text('Tap me'));
      expect(tapped, isTrue);
    });

    testWidgets('accepts dynamic text content', (tester) async {
      const dynamicText = 'Dynamic AI prompt text';
      await _pumpButton(
        tester,
        AiButton(
          text: dynamicText,
          onTap: () {},
        ),
      );

      expect(find.text(dynamicText), findsOneWidget);
    });
  });
}
