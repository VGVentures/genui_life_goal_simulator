import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/simulator/simulator.dart';
import 'package:mocktail/mocktail.dart';

class _MockSimulatorBloc extends MockBloc<SimulatorEvent, SimulatorState>
    implements SimulatorBloc {}

Map<String, Object?> _data({
  List<Map<String, Object?>>? categories,
}) => {
  'categories':
      categories ??
      [
        {'label': 'Food', 'color': 'orange', 'isSelected': true},
        {'label': 'Shopping', 'color': 'lightBlue', 'isSelected': false},
      ],
};

CatalogItemContext _context(
  BuildContext context,
  Map<String, Object?> data, {
  DataModel? dataModel,
  void Function(UiEvent)? dispatchEvent,
}) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'FilterBar',
    buildChild: (id, [dataContext]) => const SizedBox.shrink(),
    dispatchEvent: dispatchEvent ?? (_) {},
    buildContext: context,
    dataContext: DataContext(dataModel ?? InMemoryDataModel(), DataPath.root),
    getComponent: (_) => null,
    getCatalogItem: (_) => null,
    surfaceId: 'surface',
    reportError: (_, _) {},
  );
}

Future<void> _pump(
  WidgetTester tester,
  Map<String, Object?> data, {
  DataModel? dataModel,
  void Function(UiEvent)? dispatchEvent,
  SimulatorState state = const SimulatorState(),
}) async {
  final bloc = _MockSimulatorBloc();
  when(() => bloc.state).thenReturn(state);
  await tester.pumpWidget(
    BlocProvider<SimulatorBloc>.value(
      value: bloc,
      child: MaterialApp(
        theme: AppTheme(LightThemeColors()).themeData,
        home: Scaffold(
          body: Builder(
            builder: (context) => filterBarItem.widgetBuilder(
              _context(
                context,
                data,
                dataModel: dataModel,
                dispatchEvent: dispatchEvent,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group(filterBarItem, () {
    test('has correct name and schema keys', () {
      expect(filterBarItem.name, 'FilterBar');

      final schema = filterBarItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(props, contains('categories'));

      final required = schema.value['required']! as List;
      expect(required, contains('categories'));
    });

    group('renders', () {
      testWidgets('category chips', (tester) async {
        await _pump(tester, _data());

        expect(find.text('Food'), findsOneWidget);
        expect(find.text('Shopping'), findsOneWidget);
        expect(find.text('All'), findsOneWidget);
      });

      testWidgets('selection summary', (tester) async {
        await _pump(tester, _data());

        expect(find.text('1 of 2 categories selected'), findsOneWidget);
      });

      testWidgets('with empty categories', (tester) async {
        await _pump(tester, _data(categories: []));

        expect(find.text('All'), findsOneWidget);
        expect(find.text('0 of 0 categories selected'), findsOneWidget);
      });

      testWidgets('FilterBar widget', (tester) async {
        await _pump(tester, _data());

        expect(find.byType(FilterBar), findsOneWidget);
      });

      testWidgets('updates data model when category toggled', (tester) async {
        final dataModel = InMemoryDataModel();
        await _pump(tester, _data(), dataModel: dataModel);

        await tester.tap(find.text('Shopping'));
        await tester.pump();

        final stored = dataModel.getValue<List<Object?>>(
          DataPath('/test/selectedCategories'),
        );
        expect(stored, containsAll(['Food', 'Shopping']));
      });

      testWidgets('toggles all categories on All tap', (tester) async {
        await _pump(tester, _data());

        await tester.tap(find.text('All'));
        await tester.pump();

        expect(find.text('2 of 2 categories selected'), findsOneWidget);
      });
    });
  });
}
