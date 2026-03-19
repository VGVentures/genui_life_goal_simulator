import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';
import 'package:vgv_genui_financial_advisor/onboarding/want_to_focus/view/widgets/selectable_option_card.dart';

Future<void> _pumpCard(
  WidgetTester tester,
  Widget widget, {
  Size size = const Size(1200, 800),
}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: widget,
    ),
  );
}

void main() {
  group(SelectableOptionCard, () {
    testWidgets(
      'renders label, check icon and bold text when selected',
      (tester) async {
        await _pumpCard(
          tester,
          SelectableOptionCard(
            label: 'Option 1',
            isSelected: true,
            onTap: () {},
          ),
        );

        expect(find.text('Option 1'), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
        final text = tester.widget<Text>(find.text('Option 1'));
        expect(text.style?.fontWeight, FontWeight.w600);
        expect(text.style?.fontSize, 32);
      },
    );

    testWidgets(
      'hides check icon and uses normal font weight when not selected',
      (tester) async {
        await _pumpCard(
          tester,
          SelectableOptionCard(
            label: 'Option 1',
            isSelected: false,
            onTap: () {},
          ),
        );

        expect(find.text('Option 1'), findsOneWidget);
        expect(find.byType(Image), findsNothing);
        final text = tester.widget<Text>(find.text('Option 1'));
        expect(text.style?.fontWeight, FontWeight.w400);
        expect(text.style?.fontSize, 32);
      },
    );

    testWidgets(
      'applies mobile font size and shows check icon '
      'when screen width is below threshold',
      (tester) async {
        await _pumpCard(
          tester,
          SelectableOptionCard(
            label: 'Option 1',
            isSelected: true,
            onTap: () {},
          ),
          size: const Size(400, 800),
        );

        expect(find.byType(Image), findsOneWidget);
        final text = tester.widget<Text>(find.text('Option 1'));
        expect(text.style?.fontSize, 16);
      },
    );

    testWidgets('calls onTap callback when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: SelectableOptionCard(
            label: 'Option 1',
            isSelected: false,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.text('Option 1'));
      expect(tapped, isTrue);
    });
  });
}
