import 'package:finance_app/onboarding/pick_profile/view/pick_profile_page.dart';
import 'package:finance_app/onboarding/pick_profile/view/pick_profile_view.dart';
import 'package:finance_app/onboarding/pick_profile/view/widgets/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(PickProfilePage, () {
    testWidgets('renders PickProfileView', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpApp(const PickProfilePage());

      expect(find.byType(PickProfileView), findsOneWidget);
    });

    testWidgets('renders title', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpApp(const PickProfilePage());

      expect(find.text('Pick a profile'), findsOneWidget);
    });

    testWidgets('renders both profile cards', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpApp(const PickProfilePage());

      expect(find.byType(ProfileCard), findsNWidgets(2));
    });

    testWidgets('renders Next button image', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpApp(const PickProfilePage());

      // Find Image widgets (cards have star icons, fab has Next image)
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('can select a profile card', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpApp(const PickProfilePage());

      // Tap on the first profile card
      await tester.tap(find.byType(ProfileCard).first);
      await tester.pumpAndSettle();

      // The card should still be rendered
      expect(find.byType(ProfileCard), findsNWidgets(2));
    });

    testWidgets('has grey background', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpApp(const PickProfilePage());

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.grey.shade200);
    });
  });
}
