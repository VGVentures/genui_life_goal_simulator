import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv_genui_financial_advisor/advisor/catalog/items/ai_button.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

class _MockDataModel extends Mock implements DataModel {}

CatalogItemContext _context(
  BuildContext context,
  Map<String, Object?> data, {
  void Function(UiEvent)? dispatchEvent,
}) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'AiButton',
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
      home: Scaffold(
        body: Builder(
          builder: (context) => aiButtonItem.widgetBuilder(
            _context(
              context,
              data,
              dispatchEvent: dispatchEvent,
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group(aiButtonItem, () {
    test('has correct name and schema keys', () {
      expect(aiButtonItem.name, 'AiButton');

      final schema = aiButtonItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(props, contains('text'));

      final required = schema.value['required']! as List;
      expect(required, contains('text'));
    });

    testWidgets('renders AiButton with provided text', (tester) async {
      await _pump(tester, {'text': "What's eating my money?"});

      expect(find.byType(AiButton), findsOneWidget);
      expect(find.text("What's eating my money?"), findsOneWidget);
    });

    testWidgets('onTap dispatches UserActionEvent', (tester) async {
      UiEvent? dispatched;
      await _pump(
        tester,
        {'text': 'Tap me'},
        dispatchEvent: (event) => dispatched = event,
      );

      await tester.tap(find.byType(AiButton));
      await tester.pumpAndSettle();

      expect(dispatched, isNotNull);
      final action = dispatched! as UserActionEvent;
      expect(action.name, 'ai_button_tapped');
      expect(action.sourceComponentId, 'test');
    });
  });
}
