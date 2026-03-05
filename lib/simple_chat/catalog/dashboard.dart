import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A responsive dashboard that combines a visualization (like a BarChart) '
      'with interactive controls (like Sliders, ChoicePickers, or Buttons). '
      'On narrow screens the visualization is stacked above the controls. '
      'On wide screens they sit side-by-side.',
  properties: {
    'component': S.string(enumValues: ['Dashboard']),
    'title': A2uiSchemas.stringReference(
      description: 'The dashboard title.',
    ),
    'description': A2uiSchemas.stringReference(
      description: 'An optional description shown below the title.',
    ),
    'visualizationChildId': S.string(
      description:
          'The ID of a child widget to display in the visualization area '
          '(e.g. a BarChart). Be sure to create the child widget with a '
          'matching ID.',
    ),
    'controlChildIds': S.list(
      description:
          'A list of child widget IDs to display in the controls area '
          '(e.g. Sliders, ChoicePickers, CheckBoxes, Buttons). Be sure to '
          'create child widgets with matching IDs.',
      items: S.string(),
    ),
  },
  required: ['component', 'title', 'visualizationChildId', 'controlChildIds'],
);

extension type _DashboardData.fromMap(Map<String, Object?> _json) {
  Object get title => _json['title']!;
  Object? get description => _json['description'];
  String get visualizationChildId =>
      _json['visualizationChildId']! as String;
  List<String> get controlChildIds =>
      (_json['controlChildIds']! as List<Object?>).cast<String>();
}

final dashboard = CatalogItem(
  name: 'Dashboard',
  isImplicitlyFlexible: true,
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": "Dashboard",
          "title": "Budget Allocation",
          "description": "Adjust sliders to change allocation",
          "visualizationChildId": "chart",
          "controlChildIds": ["slider1", "slider2"]
        },
        {
          "id": "chart",
          "component": "BarChart",
          "title": "Spending",
          "orientation": "vertical",
          "bars": [
            { "label": "Housing", "value": { "path": "/housing" } },
            { "label": "Food", "value": { "path": "/food" } }
          ]
        },
        {
          "id": "slider1",
          "component": "Slider",
          "label": "Housing %",
          "min": 0,
          "max": 100,
          "value": { "path": "/housing" }
        },
        {
          "id": "slider2",
          "component": "Slider",
          "label": "Food %",
          "min": 0,
          "max": 100,
          "value": { "path": "/food" }
        }
      ]
    ''',
  ],
  widgetBuilder: (context) {
    final data = _DashboardData.fromMap(
      context.data as Map<String, Object?>,
    );

    final visualization = context.buildChild(
      data.visualizationChildId,
    );
    final controls = [
      for (final id in data.controlChildIds) context.buildChild(id),
    ];

    return _DashboardWidget(
      dataContext: context.dataContext,
      title: data.title,
      description: data.description,
      visualization: visualization,
      controls: controls,
    );
  },
);

class _DashboardWidget extends StatelessWidget {
  const _DashboardWidget({
    required this.dataContext,
    required this.title,
    required this.visualization,
    required this.controls,
    this.description,
  });

  final DataContext dataContext;
  final Object title;
  final Object? description;
  final Widget visualization;
  final List<Widget> controls;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 600;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                const SizedBox(height: 12),
                if (isWide)
                  _buildWideBody()
                else
                  _buildNarrowBody(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BoundString(
          dataContext: dataContext,
          value: title,
          builder: (context, title) => Text(
            title ?? '',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        BoundString(
          dataContext: dataContext,
          value: description,
          builder: (context, description) {
            if (description == null || description.isEmpty) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWideBody() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: visualization),
          const VerticalDivider(width: 32),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < controls.length; i++) ...[
                  if (i > 0) const SizedBox(height: 8),
                  controls[i],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        visualization,
        const Divider(height: 24),
        for (int i = 0; i < controls.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          controls[i],
        ],
      ],
    );
  }
}
