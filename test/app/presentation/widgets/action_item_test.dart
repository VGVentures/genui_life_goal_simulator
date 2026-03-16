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
    group('without trailing', () {
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
        expect(find.byType(Divider), findsOneWidget);
      });
    });

    group('with trailing widget', () {
      testWidgets('renders trailing widget', (tester) async {
        await _pump(
          tester,
          ActionItem(
            title: 'Restaurant',
            subtitle: 'Dining • Feb 18',
            amount: r'$450',
            delta: '+28%',
            trailing: FilledButton(
              onPressed: () {},
              child: const Text('Details'),
            ),
          ),
        );

        expect(find.byType(FilledButton), findsOneWidget);
        expect(find.text('Details'), findsOneWidget);
      });

      testWidgets('trailing button is tappable', (tester) async {
        var tapped = false;
        await _pump(
          tester,
          ActionItem(
            title: 'Restaurant',
            subtitle: 'Dining • Feb 18',
            amount: r'$450',
            trailing: FilledButton(
              onPressed: () => tapped = true,
              child: const Text('Details'),
            ),
          ),
        );

        await tester.tap(find.byType(FilledButton));
        expect(tapped, isTrue);
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
        trailing: FilledButton(
          onPressed: () {},
          child: const Text('Details'),
        ),
      ),
      ActionItem(
        title: 'Netflix',
        subtitle: 'Subscriptions • Feb 15',
        amount: r'$18',
        trailing: OutlinedButton(
          onPressed: () {},
          child: const Text('Cancel'),
        ),
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
