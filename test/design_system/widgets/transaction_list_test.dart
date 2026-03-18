import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';
import 'package:vgv_genui_financial_advisor/l10n/l10n.dart';

const _items = [
  TransactionListItem(
    title: 'Nobu Restaurant',
    description: 'Dining',
    amount: r'$450',
  ),
  TransactionListItem(
    title: 'Whole Foods',
    description: 'Groceries',
    amount: r'$120',
  ),
  TransactionListItem(
    title: 'Uber',
    description: 'Transport',
    amount: r'$35',
  ),
];

Future<void> _pumpList(WidgetTester tester, {bool withTheme = true}) {
  const widget = Scaffold(
    body: TransactionList(items: _items),
  );
  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: withTheme ? AppTheme(LightThemeColors()).themeData : null,
      home: widget,
    ),
  );
}

void main() {
  group(TransactionList, () {
    group('renders', () {
      testWidgets('titles for each item', (tester) async {
        await _pumpList(tester);

        expect(find.text('Nobu Restaurant'), findsOneWidget);
        expect(find.text('Whole Foods'), findsOneWidget);
        expect(find.text('Uber'), findsOneWidget);
      });

      testWidgets('descriptions for each item', (tester) async {
        await _pumpList(tester);

        expect(find.text('Dining'), findsOneWidget);
        expect(find.text('Groceries'), findsOneWidget);
        expect(find.text('Transport'), findsOneWidget);
      });

      testWidgets('amounts for each item', (tester) async {
        await _pumpList(tester);

        expect(find.text(r'$450'), findsOneWidget);
        expect(find.text(r'$120'), findsOneWidget);
        expect(find.text(r'$35'), findsOneWidget);
      });

      testWidgets('dividers between rows', (tester) async {
        await _pumpList(tester);

        expect(find.byType(Divider), findsNWidgets(_items.length));
      });

      testWidgets('without $AppColors extension', (tester) async {
        await _pumpList(tester, withTheme: false);

        expect(find.byType(TransactionList), findsOneWidget);
      });

      testWidgets('empty list without error', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme(LightThemeColors()).themeData,
            home: const Scaffold(
              body: TransactionList(items: []),
            ),
          ),
        );

        expect(find.byType(TransactionList), findsOneWidget);
        expect(find.byType(Divider), findsNothing);
      });
    });

    testWidgets('shows View button when onViewDetails is provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme(LightThemeColors()).themeData,
          home: Scaffold(
            body: TransactionList(
              items: [
                TransactionListItem(
                  title: 'Test',
                  description: 'Category',
                  amount: r'$100',
                  onViewDetails: () {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('View'), findsOneWidget);
      expect(find.byType(AppButton), findsOneWidget);
    });

    testWidgets('does not show View button when onViewDetails is null', (
      tester,
    ) async {
      await _pumpList(tester);

      expect(find.text('View'), findsNothing);
      expect(find.byType(AppButton), findsNothing);
    });

    testWidgets('tapping View button triggers callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme(LightThemeColors()).themeData,
          home: Scaffold(
            body: TransactionList(
              items: [
                TransactionListItem(
                  title: 'Test',
                  description: 'Category',
                  amount: r'$100',
                  onViewDetails: () => tapped = true,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('View'));
      expect(tapped, isTrue);
    });
  });
}
