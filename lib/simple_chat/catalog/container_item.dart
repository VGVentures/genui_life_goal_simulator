import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A styled container that wraps other components with a background '
      'color, border, and padding. Use it to visually group related widgets.',
  properties: {
    'component': S.string(enumValues: ['Container']),
    'title': A2uiSchemas.stringReference(
      description: 'An optional heading displayed above the children.',
    ),
    'backgroundColor': S.string(
      description:
          'Optional background color as a hex string (e.g. "#E3F2FD").',
    ),
    'borderColor': S.string(
      description: 'Optional border color as a hex string (e.g. "#1565C0").',
    ),
    'borderWidth': S.number(
      description: 'Border thickness in logical pixels. Defaults to 1.',
    ),
    'borderRadius': S.number(
      description: 'Corner radius in logical pixels. Defaults to 8.',
    ),
    'padding': S.number(
      description: 'Inner padding in logical pixels. Defaults to 16.',
    ),
    'childIds': S.list(
      description:
          'A list of child widget IDs to render inside the container. '
          'Be sure to create child widgets with matching IDs.',
      items: S.string(),
    ),
  },
  required: ['component', 'childIds'],
);

extension type _ContainerData.fromMap(Map<String, Object?> _json) {
  Object? get title => _json['title'];
  String? get backgroundColor => _json['backgroundColor'] as String?;
  String? get borderColor => _json['borderColor'] as String?;
  num get borderWidth => (_json['borderWidth'] as num?) ?? 1;
  num get borderRadius => (_json['borderRadius'] as num?) ?? 8;
  num get padding => (_json['padding'] as num?) ?? 16;
  List<String> get childIds =>
      (_json['childIds']! as List<Object?>).cast<String>();
}

final containerItem = CatalogItem(
  name: 'Container',
  isImplicitlyFlexible: true,
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": "Container",
          "title": "Settings",
          "backgroundColor": "#E3F2FD",
          "borderColor": "#1565C0",
          "borderWidth": 2,
          "borderRadius": 12,
          "padding": 16,
          "childIds": ["slider1", "toggle1"]
        },
        {
          "id": "slider1",
          "component": "Slider",
          "label": "Volume",
          "min": 0,
          "max": 100,
          "value": 50
        },
        {
          "id": "toggle1",
          "component": "CheckBox",
          "label": "Mute",
          "value": false
        }
      ]
    ''',
  ],
  widgetBuilder: (context) {
    final data = _ContainerData.fromMap(
      context.data as Map<String, Object?>,
    );

    final children = [
      for (final id in data.childIds) context.buildChild(id),
    ];

    return _ContainerWidget(
      dataContext: context.dataContext,
      title: data.title,
      backgroundColor: _parseColor(data.backgroundColor),
      borderColor: _parseColor(data.borderColor),
      borderWidth: data.borderWidth.toDouble(),
      borderRadius: data.borderRadius.toDouble(),
      padding: data.padding.toDouble(),
      children: children,
    );
  },
);

Color? _parseColor(String? hex) {
  if (hex == null || hex.isEmpty) return null;
  var h = hex.replaceFirst('#', '');
  if (h.length == 6) h = 'FF$h';
  return Color(int.parse(h, radix: 16));
}

class _ContainerWidget extends StatelessWidget {
  const _ContainerWidget({
    required this.dataContext,
    required this.title,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.padding,
    required this.children,
  });

  final DataContext dataContext;
  final Object? title;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final double padding;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
      ),
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          BoundString(
            dataContext: dataContext,
            value: title,
            builder: (context, title) {
              if (title == null || title.isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            },
          ),
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            children[i],
          ],
        ],
      ),
    );
  }
}
