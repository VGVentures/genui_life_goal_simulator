import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';
import 'package:vgv_genui_financial_advisor/dev_menu/dev_menu.dart';
import 'package:vgv_genui_financial_advisor/feature_flags/feature_flags.dart';

class _MockFeatureFlagsRepository extends Mock
    implements FeatureFlagsRepository {}

const _flag = FeatureFlag(
  id: 'flag_1',
  name: 'Flag 1',
  description: 'A test flag',
  value: true,
  defaultValue: false,
);

const _flag2 = FeatureFlag(
  id: 'flag_2',
  name: 'Flag 2',
  description: 'Another flag',
  value: false,
  defaultValue: false,
);

Future<void> _pump(
  WidgetTester tester,
  FeatureFlagsRepository repository,
) {
  return tester.pumpWidget(
    Provider<FeatureFlagsRepository>.value(
      value: repository,
      child: MaterialApp(
        theme: AppTheme(LightThemeColors()).themeData,
        home: const Scaffold(
          endDrawer: DevMenuDrawer(),
          body: SizedBox.shrink(),
        ),
      ),
    ),
  );
}

Future<void> _openDrawer(WidgetTester tester) async {
  tester.firstState<ScaffoldState>(find.byType(Scaffold)).openEndDrawer();
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  group(DevMenuDrawer, () {
    late _MockFeatureFlagsRepository repository;

    setUp(() {
      repository = _MockFeatureFlagsRepository();
    });

    group('renders', () {
      testWidgets('Dev Menu title and Design System tile', (
        tester,
      ) async {
        when(repository.getFeatureFlagIds).thenReturn(['flag_1']);
        when(
          () => repository.watchFeatureFlag('flag_1'),
        ).thenAnswer((_) => Stream.value(_flag));

        await _pump(tester, repository);
        await _openDrawer(tester);

        expect(find.text('Dev Menu'), findsOneWidget);
        expect(find.text('Design System'), findsOneWidget);
      });

      testWidgets('flag switch tiles for success state', (
        tester,
      ) async {
        when(repository.getFeatureFlagIds).thenReturn(['flag_1', 'flag_2']);
        when(
          () => repository.watchFeatureFlag('flag_1'),
        ).thenAnswer((_) => Stream.value(_flag));
        when(
          () => repository.watchFeatureFlag('flag_2'),
        ).thenAnswer((_) => Stream.value(_flag2));

        await _pump(tester, repository);
        await _openDrawer(tester);
        await tester.pump();

        expect(find.text('Flag 1'), findsOneWidget);
        expect(find.text('Flag 2'), findsOneWidget);
        expect(find.byType(SwitchListTile), findsNWidgets(2));
      });
    });

    group('shows', () {
      testWidgets('progress indicator before flags load', (
        tester,
      ) async {
        final controller = StreamController<FeatureFlag>();
        addTearDown(controller.close);

        when(repository.getFeatureFlagIds).thenReturn(['flag_1']);
        when(
          () => repository.watchFeatureFlag('flag_1'),
        ).thenAnswer((_) => controller.stream);

        await _pump(tester, repository);
        await _openDrawer(tester);

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('error when getFeatureFlagIds throws', (tester) async {
        when(repository.getFeatureFlagIds).thenThrow(Exception('boom'));

        await _pump(tester, repository);
        await _openDrawer(tester);

        expect(find.textContaining('Error:'), findsOneWidget);
      });

      testWidgets('error when stream errors', (tester) async {
        when(repository.getFeatureFlagIds).thenReturn(['flag_1']);
        when(
          () => repository.watchFeatureFlag('flag_1'),
        ).thenAnswer((_) => Stream.error('stream error'));

        await _pump(tester, repository);
        await _openDrawer(tester);
        await tester.pump();

        expect(find.textContaining('Error:'), findsOneWidget);
      });
    });

    testWidgets('toggling switch calls toggleFeatureFlag', (tester) async {
      when(repository.getFeatureFlagIds).thenReturn(['flag_1']);
      when(
        () => repository.watchFeatureFlag('flag_1'),
      ).thenAnswer((_) => Stream.value(_flag));
      when(
        () => repository.toggleFeatureFlag('flag_1'),
      ).thenAnswer((_) async {});

      await _pump(tester, repository);
      await _openDrawer(tester);
      await tester.pump();

      await tester.tap(find.byType(SwitchListTile));
      await tester.pump();

      verify(() => repository.toggleFeatureFlag('flag_1')).called(1);
    });

    testWidgets('tapping Design System navigates to catalog page', (
      tester,
    ) async {
      when(repository.getFeatureFlagIds).thenReturn(['flag_1']);
      when(
        () => repository.watchFeatureFlag('flag_1'),
      ).thenAnswer((_) => Stream.value(_flag));

      await _pump(tester, repository);
      await _openDrawer(tester);

      await tester.tap(find.text('Design System'));
      await tester.pumpAndSettle();

      expect(find.byType(DesignSystemCatalogPage), findsOneWidget);
    });
  });
}
