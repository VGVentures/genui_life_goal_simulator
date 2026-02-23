import 'package:finance_app/app/presentation/breakpoints.dart';
import 'package:finance_app/app/presentation/widgets/responsive_scaffold.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(Breakpoints, () {
    test('isMobile returns true for width below threshold', () {
      expect(Breakpoints.isMobile(Breakpoints.mobile - 1), isTrue);
      expect(Breakpoints.isMobile(0), isTrue);
      expect(Breakpoints.isMobile(Breakpoints.mobile - 0.1), isTrue);
    });

    test('isMobile returns false for width at or above threshold', () {
      expect(Breakpoints.isMobile(Breakpoints.mobile), isFalse);
      expect(Breakpoints.isMobile(Breakpoints.mobile + 1), isFalse);
      expect(Breakpoints.isMobile(Breakpoints.mobile * 2), isFalse);
    });

    test('isDesktop returns true for width at or above threshold', () {
      expect(Breakpoints.isDesktop(Breakpoints.desktop), isTrue);
      expect(Breakpoints.isDesktop(Breakpoints.desktop + 1), isTrue);
      expect(Breakpoints.isDesktop(Breakpoints.desktop * 2), isTrue);
    });

    test('isDesktop returns false for width below threshold', () {
      expect(Breakpoints.isDesktop(Breakpoints.desktop - 1), isFalse);
      expect(Breakpoints.isDesktop(0), isFalse);
      expect(Breakpoints.isDesktop(Breakpoints.desktop - 0.1), isFalse);
    });
  });

  group(ResponsiveScaffold, () {
    const mobileKey = Key('mobile');
    const desktopKey = Key('desktop');

    Widget buildTestWidget({required double width}) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: width,
            height: 800,
            child: const ResponsiveScaffold(
              mobile: SizedBox(key: mobileKey),
              desktop: SizedBox(key: desktopKey),
            ),
          ),
        ),
      );
    }

    testWidgets('renders mobile widget when width is below threshold', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(width: Breakpoints.mobile - 1),
      );

      expect(find.byKey(mobileKey), findsOneWidget);
      expect(find.byKey(desktopKey), findsNothing);
    });

    testWidgets('renders desktop widget when width is at or above threshold', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(width: Breakpoints.desktop),
      );

      expect(find.byKey(desktopKey), findsOneWidget);
      expect(find.byKey(mobileKey), findsNothing);
    });

    testWidgets('renders desktop widget at exact boundary', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(width: Breakpoints.desktop),
      );

      expect(find.byKey(desktopKey), findsOneWidget);
      expect(find.byKey(mobileKey), findsNothing);
    });

    testWidgets('responds to dynamic resize from mobile to desktop', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(width: Breakpoints.mobile - 100),
      );
      expect(find.byKey(mobileKey), findsOneWidget);

      await tester.pumpWidget(
        buildTestWidget(width: Breakpoints.desktop + 200),
      );
      expect(find.byKey(desktopKey), findsOneWidget);
      expect(find.byKey(mobileKey), findsNothing);
    });

    testWidgets('responds to dynamic resize from desktop to mobile', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(width: Breakpoints.desktop + 200),
      );
      expect(find.byKey(desktopKey), findsOneWidget);

      await tester.pumpWidget(
        buildTestWidget(width: Breakpoints.mobile - 100),
      );
      expect(find.byKey(mobileKey), findsOneWidget);
      expect(find.byKey(desktopKey), findsNothing);
    });

    testWidgets('uses parent constraints not screen size', (tester) async {
      // Set a large screen size but constrain the widget to mobile width
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox(
              width: Breakpoints.mobile - 200,
              height: 800,
              child: ResponsiveScaffold(
                mobile: SizedBox(key: mobileKey),
                desktop: SizedBox(key: desktopKey),
              ),
            ),
          ),
        ),
      );

      // Should render mobile even though screen is large
      expect(find.byKey(mobileKey), findsOneWidget);
      expect(find.byKey(desktopKey), findsNothing);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
