import 'package:finance_app/advisor/catalog/items/app_button_catalog_item.dart';
import 'package:finance_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataModel extends Mock implements DataModel {}

Map<String, Object?> _data({
  String label = 'Get Started',
  String variant = 'filled',
  String size = 'large',
  bool? isLoading,
}) => {
  'label': label,
  'variant': variant,
  'size': size,
  'isLoading': isLoading,
};

CatalogItemContext _context(BuildContext context, Map<String, Object?> data) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'AppButton',
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
        body: Builder(
          builder: (context) =>
              appButtonItem.widgetBuilder(_context(context, data)),
        ),
      ),
    ),
  );
}

void main() {
  group(appButtonItem, () {
    test('has correct name and schema keys', () {
      expect(appButtonItem.name, 'AppButton');

      final schema = appButtonItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(
        props,
        containsAll(['label', 'variant', 'size', 'isLoading']),
      );

      final required = schema.value['required']! as List;
      expect(required, containsAll(['label', 'variant', 'size']));
    });

    group('renders', () {
      testWidgets('filled button with label', (tester) async {
        await _pump(tester, _data());

        expect(find.text('Get Started'), findsOneWidget);
        expect(find.byType(FilledButton), findsOneWidget);
      });

      testWidgets('outlined variant', (tester) async {
        await _pump(tester, _data(variant: 'outlined'));

        expect(find.text('Get Started'), findsOneWidget);
        expect(find.byType(OutlinedButton), findsOneWidget);
      });

      testWidgets('loading state', (tester) async {
        await _pump(tester, _data(isLoading: true));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('defaults isLoading to false when omitted', (tester) async {
        await _pump(tester, _data());

        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('Get Started'), findsOneWidget);
      });
    });
  });
}
