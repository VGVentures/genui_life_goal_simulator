import 'package:finance_app/advisor/catalog/items/app_button.dart';
import 'package:finance_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';

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
    buildChild: (id, [dataContext]) => const SizedBox.shrink(),
    dispatchEvent: (_) {},
    buildContext: context,
    dataContext: DataContext(DataModel(), '/'),
    getComponent: (_) => null,
    surfaceId: 'surface',
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
      final props =
          (schema.value['properties']! as Map<String, Object?>).keys.toList();
      expect(
        props,
        containsAll(['label', 'variant', 'size', 'isLoading']),
      );

      final required = schema.value['required']! as List;
      expect(required, hasLength(3));
      expect(required, containsAll(['label', 'variant', 'size']));
    });

    testWidgets('renders filled button with label', (tester) async {
      await _pump(tester, _data());

      expect(find.text('Get Started'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('renders outlined variant', (tester) async {
      await _pump(tester, _data(variant: 'outlined'));

      expect(find.text('Get Started'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('renders loading state', (tester) async {
      await _pump(tester, _data(isLoading: true));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('defaults isLoading to false when omitted', (tester) async {
      await _pump(tester, _data());

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Get Started'), findsOneWidget);
    });
  });
}
