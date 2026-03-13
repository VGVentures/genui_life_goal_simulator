import 'package:finance_app/advisor/catalog/items/app_button_catalog_item.dart';
import 'package:finance_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataModel extends Mock implements DataModel {}

const _defaultAction = {
  'event': {'name': 'button_pressed'},
};

Map<String, Object?> _data({
  String label = 'Get Started',
  String variant = 'filled',
  String size = 'large',
  bool? isLoading,
  Map<String, Object?> action = _defaultAction,
}) => {
  'label': label,
  'variant': variant,
  'size': size,
  'isLoading': isLoading,
  'action': action,
};

CatalogItemContext _context(
  BuildContext context,
  Map<String, Object?> data, {
  void Function(UiEvent)? dispatchEvent,
}) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'AppButton',
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
  void Function(UiEvent)? dispatchEvent,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (context) => appButtonItem.widgetBuilder(
            _context(context, data, dispatchEvent: dispatchEvent),
          ),
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
        containsAll(['label', 'variant', 'size', 'isLoading', 'action']),
      );

      final required = schema.value['required']! as List;
      expect(required, containsAll(['label', 'variant', 'size', 'action']));
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

      testWidgets('dispatches event on press', (tester) async {
        final events = <UiEvent>[];
        await _pump(
          tester,
          _data(
            action: {
              'event': {
                'name': 'get_started',
                'context': {'page': 'home'},
              },
            },
          ),
          dispatchEvent: events.add,
        );

        await tester.tap(find.text('Get Started'));
        await tester.pump();

        expect(events, hasLength(1));
        final event = events.single as UserActionEvent;
        expect(event.name, 'get_started');
        expect(event.context, {'page': 'home'});
      });
    });
  });
}
