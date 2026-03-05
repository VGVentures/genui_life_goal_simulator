import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'DESKTOP ONLY: information panel with a horizontal layout: image '
      'on the left, title/subtitle/body on the right.',
  properties: {
    'component': S.string(enumValues: ['WideInfoPanel']),
    'imageChildId': S.string(
      description:
          'Optional ID of an Image widget to display on the left side of '
          'the panel. The Image fit should typically be "cover". Be sure to '
          'create an Image widget with a matching ID.',
    ),
    'title': A2uiSchemas.stringReference(
      description: 'The title of the panel.',
    ),
    'subtitle': A2uiSchemas.stringReference(
      description: 'An optional subtitle for the panel.',
    ),
    'body': A2uiSchemas.stringReference(
      description: 'The body text of the panel.',
    ),
  },
  required: ['component', 'title', 'body'],
);

extension type _WideInfoPanelData.fromMap(Map<String, Object?> _json) {
  String? get imageChildId => _json['imageChildId'] as String?;
  Object get title => _json['title'] as Object;
  Object? get subtitle => _json['subtitle'];
  Object get body => _json['body'] as Object;
}

final wideInfoPanel = CatalogItem(
  name: 'WideInfoPanel',
  isImplicitlyFlexible: true,
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": "WideInfoPanel",
          "title": "Mountain Retreat",
          "subtitle": "A weekend getaway",
          "body": "Escape to the mountains for a relaxing weekend with stunning views.",
          "imageChildId": "image1"
        },
        {
          "id": "image1",
          "component": "Image",
          "url": "https://example.com/mountain.jpg"
        }
      ]
    ''',
  ],
  widgetBuilder: (context) {
    final panelData = _WideInfoPanelData.fromMap(
      context.data as Map<String, Object?>,
    );
    final Widget? imageChild = panelData.imageChildId != null
        ? context.buildChild(panelData.imageChildId!)
        : null;

    return _WideInfoPanel(
      imageChild: imageChild,
      dataContext: context.dataContext,
      title: panelData.title,
      subtitle: panelData.subtitle,
      body: panelData.body,
    );
  },
);

class _WideInfoPanel extends StatelessWidget {
  const _WideInfoPanel({
    required this.dataContext,
    required this.title,
    required this.body,
    this.imageChild,
    this.subtitle,
  });

  final DataContext dataContext;
  final Object title;
  final Object body;
  final Widget? imageChild;
  final Object? subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (imageChild != null) SizedBox(width: 200, child: imageChild),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BoundString(
                      dataContext: dataContext,
                      value: title,
                      builder: (context, title) => Text(
                        '${title ?? ''} - Wide',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    BoundString(
                      dataContext: dataContext,
                      value: subtitle,
                      builder: (context, subtitle) {
                        if (subtitle == null) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            subtitle,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8.0),
                    BoundString(
                      dataContext: dataContext,
                      value: body,
                      builder: (context, body) => Text(body ?? ''),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
