import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgv_genui_financial_advisor/onboarding/pick_profile/pick_profile.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(ProfileCard, () {
    setUp(TestWidgetsFlutterBinding.ensureInitialized);

    testWidgets('renders beginner profile correctly', (tester) async {
      // Use mobile size to avoid overflow
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpApp(
        ProfileCard(
          profileType: ProfileType.beginner,
          isSelected: false,
          onTap: () {},
        ),
      );

      expect(find.text('The Beginner'), findsOneWidget);
      expect(
        find.textContaining('Just getting started'),
        findsOneWidget,
      );
    });

    testWidgets('renders optimizer profile correctly', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpApp(
        ProfileCard(
          profileType: ProfileType.optimizer,
          isSelected: false,
          onTap: () {},
        ),
      );

      expect(find.text('The Optimizer'), findsOneWidget);
      expect(
        find.textContaining('Established career'),
        findsOneWidget,
      );
    });

    testWidgets('calls onTap when tapped', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      var tapped = false;

      await tester.pumpApp(
        ProfileCard(
          profileType: ProfileType.beginner,
          isSelected: false,
          onTap: () => tapped = true,
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('renders star icon for beginner', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpApp(
        ProfileCard(
          profileType: ProfileType.beginner,
          isSelected: false,
          onTap: () {},
        ),
      );

      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('renders star icon for optimizer', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpApp(
        ProfileCard(
          profileType: ProfileType.optimizer,
          isSelected: false,
          onTap: () {},
        ),
      );

      expect(find.byType(SvgPicture), findsOneWidget);
    });
  });
}
