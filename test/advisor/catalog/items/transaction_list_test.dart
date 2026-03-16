import 'package:finance_app/advisor/catalog/items/transaction_list.dart';
import 'package:finance_app/app/presentation/widgets/transaction_list.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:mocktail/mocktail.dart';

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
  Map<String, Object?> data,
) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'TransactionList',
    buildChild: (id, [dataContext]) => const SizedBox.shrink(),
    dispatchEvent: (_) {},
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
  Map<String, Object?> data,
) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Builder(
            builder: (context) => transactionListItem.widgetBuilder(
              _context(context, data),
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
    });
  });
}
