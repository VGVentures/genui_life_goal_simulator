import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, Widget widget) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme(LightThemeColors()).themeData,
      home: Scaffold(body: widget),
    ),
  );
}

void main() {
  group(ActionItem, () {
    group('no-button variant', () {
      testWidgets('renders', (tester) async {
        await _pump(
          tester,
          const ActionItem(
            title: 'Restaurant',
            subtitle: 'Dining • Feb 18',
            amount: r'$87',
          ),
        );

        expect(find.text('Restaurant'), findsOneWidget);
        expect(find.text('Dining • Feb 18'), findsOneWidget);
        expect(find.text(r'$87'), findsOneWidget);
        expect(find.byType(FilledButton), findsNothing);
        expect(find.byType(OutlinedButton), findsNothing);
        expect(find.byType(Divider), findsOneWidget);
      });
    });

    group('primary button variant', () {
      testWidgets('renders FilledButton with label', (tester) async {
        await _pump(
          tester,
          ActionItem(
            title: 'Restaurant',
            subtitle: 'Dining • Feb 18',
            amount: r'$450',
            delta: '+28%',
            buttonLabel: 'Details',
            buttonVariant: ActionItemButtonVariant.primary,
            onButtonTap: () {},
          ),
        );

        expect(find.byType(FilledButton), findsOneWidget);
        expect(find.text('Details'), findsOneWidget);
      });

      testWidgets('calls onButtonTap when pressed', (tester) async {
        var tapped = false;
        await _pump(
          tester,
          ActionItem(
            title: 'Restaurant',
            subtitle: 'Dining • Feb 18',
            amount: r'$450',
            buttonLabel: 'Details',
            buttonVariant: ActionItemButtonVariant.primary,
            onButtonTap: () => tapped = true,
          ),
        );

        await tester.tap(find.byType(FilledButton));
        expect(tapped, isTrue);
      });

      testWidgets('renders no OutlinedButton', (tester) async {
        await _pump(
          tester,
          ActionItem(
            title: 'Restaurant',
            subtitle: 'Dining • Feb 18',
            amount: r'$450',
            buttonLabel: 'Details',
            buttonVariant: ActionItemButtonVariant.primary,
            onButtonTap: () {},
          ),
        );

        expect(find.byType(OutlinedButton), findsNothing);
      });
    });

    group('secondary button variant', () {
      testWidgets('renders OutlinedButton with label', (tester) async {
        await _pump(
          tester,
          ActionItem(
            title: 'Netflix',
            subtitle: 'Subscriptions • Feb 15',
            amount: r'$18',
            buttonLabel: 'Cancel Subscription',
            buttonVariant: ActionItemButtonVariant.secondary,
            onButtonTap: () {},
          ),
        );

        expect(find.byType(OutlinedButton), findsOneWidget);
        expect(find.text('Cancel Subscription'), findsOneWidget);
      });

      testWidgets('calls onButtonTap when pressed', (tester) async {
        var tapped = false;
        await _pump(
          tester,
          ActionItem(
            title: 'Netflix',
            subtitle: 'Subscriptions • Feb 15',
            amount: r'$18',
            buttonLabel: 'Cancel Subscription',
            buttonVariant: ActionItemButtonVariant.secondary,
            onButtonTap: () => tapped = true,
          ),
        );

        await tester.tap(find.byType(OutlinedButton));
        expect(tapped, isTrue);
      });

      testWidgets('renders no FilledButton', (tester) async {
        await _pump(
          tester,
          ActionItem(
            title: 'Netflix',
            subtitle: 'Subscriptions • Feb 15',
            amount: r'$18',
            buttonLabel: 'Cancel Subscription',
            buttonVariant: ActionItemButtonVariant.secondary,
            onButtonTap: () {},
          ),
        );

        expect(find.byType(FilledButton), findsNothing);
      });
    });

    group('delta', () {
      testWidgets('renders delta text when provided', (tester) async {
        await _pump(
          tester,
          const ActionItem(
            title: 'Restaurant',
            subtitle: 'Dining • Feb 18',
            amount: r'$450',
            delta: '+28%',
          ),
        );

        expect(find.text('+28%'), findsOneWidget);
      });

      testWidgets('does not render delta text when null', (tester) async {
        await _pump(
          tester,
          const ActionItem(
            title: 'Restaurant',
            subtitle: 'Dining • Feb 18',
            amount: r'$87',
          ),
        );

        // title + subtitle + amount = 3 Text widgets
        expect(find.byType(Text), findsNWidgets(3));
      });

      testWidgets('delta uses success colour from theme', (tester) async {
        await _pump(
          tester,
          const ActionItem(
            title: 'Restaurant',
            subtitle: 'Dining • Feb 18',
            amount: r'$450',
            delta: '+28%',
          ),
        );

        final deltaText = tester
            .widgetList<Text>(find.byType(Text))
            .firstWhere((t) => t.data == '+28%');
        // LightThemeColors.success
        expect(deltaText.style?.color, const Color(0xFF00A65F));
      });
    });

    testWidgets('renders without error without AppColors extension', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ActionItem(
              title: 'Restaurant',
              subtitle: 'Dining • Feb 18',
              amount: r'$87',
            ),
          ),
        ),
      );

      expect(find.text('Restaurant'), findsOneWidget);
    });
  });

  group('ActionItemsGroup', () {
    final items = [
      ActionItem(
        title: 'Restaurant',
        subtitle: 'Dining • Feb 18',
        amount: r'$450',
        delta: '+28%',
        buttonLabel: 'Details',
        buttonVariant: ActionItemButtonVariant.primary,
        onButtonTap: () {},
      ),
      ActionItem(
        title: 'Netflix',
        subtitle: 'Subscriptions • Feb 15',
        amount: r'$18',
        buttonLabel: 'Cancel Subscription',
        buttonVariant: ActionItemButtonVariant.secondary,
        onButtonTap: () {},
      ),
      const ActionItem(
        title: 'Restaurant',
        subtitle: 'Dining • Feb 18',
        amount: r'$87',
      ),
    ];

    testWidgets('renders all item titles', (tester) async {
      await _pump(tester, ActionItemsGroup(items: items));

      expect(find.text('Restaurant'), findsNWidgets(2));
      expect(find.text('Netflix'), findsOneWidget);
    });

    testWidgets('renders one FilledButton and one OutlinedButton', (
      tester,
    ) async {
      await _pump(tester, ActionItemsGroup(items: items));

      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('renders a Divider for each item', (tester) async {
      await _pump(tester, ActionItemsGroup(items: items));

      expect(find.byType(Divider), findsNWidgets(items.length));
    });

    testWidgets('renders all items in a Column', (tester) async {
      await _pump(tester, ActionItemsGroup(items: items));

      expect(find.byType(ActionItem), findsNWidgets(items.length));
    });
  });
}
