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

  group('responsiveValue', () {
    testWidgets('returns mobile value when screen width is below threshold', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(Breakpoints.mobile - 1, 800);
      tester.view.devicePixelRatio = 1.0;
      addTeardownToResetView(tester);

      late String result;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              result = responsiveValue(
                context,
                mobile: 'mobile',
                desktop: 'desktop',
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(result, 'mobile');
    });

    testWidgets(
      'returns desktop value when screen width is at or above threshold',
      (tester) async {
        tester.view.physicalSize = const Size(Breakpoints.desktop, 800);
        tester.view.devicePixelRatio = 1.0;
        addTeardownToResetView(tester);

        late String result;
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) {
                result = responsiveValue(
                  context,
                  mobile: 'mobile',
                  desktop: 'desktop',
                );
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, 'desktop');
      },
    );
  });

  group(ResponsiveScaffold, () {
    const mobileKey = Key('mobile');
    const desktopKey = Key('desktop');

    const scaffold = ResponsiveScaffold(
      mobile: SizedBox(key: mobileKey),
      desktop: SizedBox(key: desktopKey),
    );

    testWidgets('renders mobile widget when screen width is below threshold', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(Breakpoints.mobile - 1, 800);
      tester.view.devicePixelRatio = 1.0;
      addTeardownToResetView(tester);

      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: scaffold,
        ),
      );

      expect(find.byKey(mobileKey), findsOneWidget);
      expect(find.byKey(desktopKey), findsNothing);
    });

    testWidgets(
      'renders desktop widget when screen width is at or above threshold',
      (tester) async {
        tester.view.physicalSize = const Size(Breakpoints.desktop, 800);
        tester.view.devicePixelRatio = 1.0;
        addTeardownToResetView(tester);

        await tester.pumpWidget(
          const Directionality(
            textDirection: TextDirection.ltr,
            child: scaffold,
          ),
        );

        expect(find.byKey(desktopKey), findsOneWidget);
        expect(find.byKey(mobileKey), findsNothing);
      },
    );

    testWidgets('responds to dynamic resize from mobile to desktop', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(Breakpoints.mobile - 100, 800);
      tester.view.devicePixelRatio = 1.0;
      addTeardownToResetView(tester);

      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: scaffold,
        ),
      );
      expect(find.byKey(mobileKey), findsOneWidget);

      tester.view.physicalSize = const Size(Breakpoints.desktop + 200, 800);
      await tester.pump();

      expect(find.byKey(desktopKey), findsOneWidget);
      expect(find.byKey(mobileKey), findsNothing);
    });

    testWidgets('responds to dynamic resize from desktop to mobile', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(Breakpoints.desktop + 200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTeardownToResetView(tester);

      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: scaffold,
        ),
      );
      expect(find.byKey(desktopKey), findsOneWidget);

      tester.view.physicalSize = const Size(Breakpoints.mobile - 100, 800);
      await tester.pump();

      expect(find.byKey(mobileKey), findsOneWidget);
      expect(find.byKey(desktopKey), findsNothing);
    });

    testWidgets('uses screen size not parent constraints', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTeardownToResetView(tester);

      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox(
              width: 200,
              height: 800,
              child: scaffold,
            ),
          ),
        ),
      );

      // Should render desktop because screen is large,
      // even though parent SizedBox is narrow
      expect(find.byKey(desktopKey), findsOneWidget);
      expect(find.byKey(mobileKey), findsNothing);
    });
  });
}

void addTeardownToResetView(WidgetTester tester) {
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
