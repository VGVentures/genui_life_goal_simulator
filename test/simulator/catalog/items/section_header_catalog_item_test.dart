import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/simulator/simulator.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataModel extends Mock implements DataModel {}

class _MockSimulatorBloc extends MockBloc<SimulatorEvent, SimulatorState>
    implements SimulatorBloc {}

Map<String, Object?> _data({
  String title = 'Spending',
  String subtitle = 'January 2026',
  List<String>? selectorOptions,
  int? selectedIndex,
}) => {
  'title': title,
  'subtitle': subtitle,
  'selectorOptions': ?selectorOptions,
  'selectedIndex': ?selectedIndex,
};

CatalogItemContext _context(
  BuildContext context,
  Map<String, Object?> data, {
  DataModel? dataModel,
}) {
  return CatalogItemContext(
    data: data,
    id: 'test',
    type: 'SectionHeader',
    buildChild: (id, [dataContext]) => const SizedBox.shrink(),
    dispatchEvent: (_) {},
    buildContext: context,
    dataContext: DataContext(dataModel ?? _MockDataModel(), DataPath.root),
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
            builder: (context) => sectionHeaderItem.widgetBuilder(
              _context(context, data, dataModel: dataModel),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group(sectionHeaderItem, () {
    test('has correct name and schema keys', () {
      expect(sectionHeaderItem.name, 'SectionHeader');

      final schema = sectionHeaderItem.dataSchema;
      final props = (schema.value['properties']! as Map<String, Object?>).keys
          .toList();
      expect(
        props,
        containsAll(['title', 'subtitle', 'selectorOptions', 'selectedIndex']),
      );

      final required = schema.value['required']! as List;
      expect(required, containsAll(['title', 'subtitle']));
      expect(required, isNot(contains('selectorOptions')));
      expect(required, isNot(contains('selectedIndex')));
    });

    testWidgets('renders title and subtitle', (tester) async {
      await _pump(tester, _data());

      expect(find.byType(SectionHeader), findsOneWidget);
      expect(find.text('Spending'), findsOneWidget);
      expect(find.text('January 2026'), findsOneWidget);
    });

    testWidgets('renders without selector when selectorOptions is omitted', (
      tester,
    ) async {
      await _pump(tester, _data());

      expect(find.byType(HeaderSelector), findsNothing);
    });

    testWidgets('renders HeaderSelector when selectorOptions is provided', (
      tester,
    ) async {
      await _pump(
        tester,
        _data(selectorOptions: ['1M', '3M', '6M'], selectedIndex: 1),
      );

      expect(find.byType(HeaderSelector), findsOneWidget);
      expect(find.text('1M'), findsOneWidget);
      expect(find.text('3M'), findsOneWidget);
      expect(find.text('6M'), findsOneWidget);
    });

    testWidgets('defaults selectedIndex to 0 when omitted', (tester) async {
      await _pump(
        tester,
        _data(selectorOptions: ['1M', '3M', '6M']),
      );

      final widget = tester.widget<SectionHeader>(find.byType(SectionHeader));
      expect(widget.selectedIndex, 0);
    });

    testWidgets('writes selectedOption to data model on selector tap', (
      tester,
    ) async {
      registerFallbackValue(DataPath.root);

      final mockDataModel = _MockDataModel();
      final capturedPaths = <DataPath>[];
      final capturedValues = <Object?>[];

      when(
        () => mockDataModel.update(
          any(that: isA<DataPath>()),
          any<Object?>(),
        ),
      ).thenAnswer((invocation) {
        capturedPaths.add(invocation.positionalArguments[0] as DataPath);
        capturedValues.add(invocation.positionalArguments[1]);
      });

      await _pump(
        tester,
        _data(selectorOptions: ['1M', '3M', '6M'], selectedIndex: 0),
        dataModel: mockDataModel,
      );

      // Tap the '3M' chip
      await tester.tap(find.text('3M'));
      await tester.pump();

      expect(
        capturedPaths.any((p) => p.toString() == '/test/selectedOption'),
        isTrue,
      );
      expect(capturedValues, contains('3M'));
    });
  });
}
