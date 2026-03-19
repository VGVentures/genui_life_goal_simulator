import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv_genui_financial_advisor/advisor/catalog/items/transaction_list.dart';
import 'package:vgv_genui_financial_advisor/design_system/widgets/app_button.dart';
import 'package:vgv_genui_financial_advisor/design_system/widgets/transaction_list.dart';
import 'package:vgv_genui_financial_advisor/l10n/l10n.dart';

class _MockDataModel extends Mock implements DataModel {}

Map<String, Object?> _data({
  List<Map<String, Object?>>? items,
}) => {
  'items':
      items ??
      [
        {
          'title': 'Nobu Restaurant',
          'description': 'Dining',
          'amount': r'$450',
        },
        {
          'title': 'Netflix',
          'description': 'Entertainment',
          'amount': r'$15',
        },
      ],
};

CatalogItemContext _context(
  BuildContext context,
  Map<String, Object?> data, {
  DispatchEventCallback? dispatchEvent,
}) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'TransactionList',
    buildChild: (id, [dataContext]) => const SizedBox.shrink(),
    dispatchEvent: dispatchEvent ?? (_) {},
    buildContext: context,
    dataContext: DataContext(_MockDataModel(), DataPath.root),
    getComponent: (_) => null,
    getCatalogItem: (_) => null,
    surfaceId: 'surface',
    reportError: (_, _) {},
  );
}

Future<void> _pump(
  WidgetTester tester,
  Map<String, Object?> data, {
  DispatchEventCallback? dispatchEvent,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Builder(
            builder: (context) => transactionListItem.widgetBuilder(
              _context(context, data, dispatchEvent: dispatchEvent),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group(transactionListItem, () {
    test('has correct name and schema keys', () {
      expect(transactionListItem.name, 'TransactionList');

      final schema = transactionListItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(props, contains('items'));

      final required = schema.value['required']! as List;
      expect(required, contains('items'));
    });

    group('', () {
      testWidgets('renders items with valid data', (tester) async {
        await _pump(tester, _data());

        expect(find.text('Nobu Restaurant'), findsOneWidget);
        expect(find.text('Dining'), findsOneWidget);
        expect(find.text(r'$450'), findsOneWidget);
        expect(find.text('Netflix'), findsOneWidget);
        expect(find.text('Entertainment'), findsOneWidget);
        expect(find.text(r'$15'), findsOneWidget);
        expect(
          find.byType(TransactionList),
          findsOneWidget,
        );
      });

      testWidgets('renders single item', (tester) async {
        await _pump(
          tester,
          _data(
            items: [
              {
                'title': 'Gym',
                'description': 'Fitness',
                'amount': r'$50',
              },
            ],
          ),
        );

        expect(find.text('Gym'), findsOneWidget);
        expect(find.text('Fitness'), findsOneWidget);
        expect(find.text(r'$50'), findsOneWidget);
      });

      testWidgets('shows AppButton when item has action', (tester) async {
        await _pump(
          tester,
          _data(
            items: [
              {
                'title': 'Nobu Restaurant',
                'description': 'Dining',
                'amount': r'$450',
                'action': {
                  'event': {
                    'name': 'view_transaction',
                    'context': <String, Object?>{},
                  },
                },
              },
            ],
          ),
        );

        expect(find.byType(AppButton), findsOneWidget);
      });

      testWidgets('dispatches event when View button is tapped', (
        tester,
      ) async {
        UserActionEvent? dispatched;

        await _pump(
          tester,
          _data(
            items: [
              {
                'title': 'Nobu Restaurant',
                'description': 'Dining',
                'amount': r'$450',
                'action': {
                  'event': {
                    'name': 'view_transaction',
                    'context': <String, Object?>{},
                  },
                },
              },
            ],
          ),
          dispatchEvent: (event) => dispatched = event as UserActionEvent,
        );

        await tester.tap(find.byType(AppButton));

        expect(dispatched, isNotNull);
        expect(dispatched!.name, 'view_transaction');
        expect(dispatched!.context['title'], 'Nobu Restaurant');
      });

      testWidgets('does not show AppButton when item has no action', (
        tester,
      ) async {
        await _pump(tester, _data());

        expect(find.byType(AppButton), findsNothing);
      });
    });
  });
}
