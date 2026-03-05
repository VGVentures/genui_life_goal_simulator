import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'MOBILE ONLY: information card with a vertical layout: image on '
      'top, title and body text below.',
  properties: {
    'component': S.string(enumValues: ['CompactInfoCard']),
    'imageChildId': S.string(
      description:
          'Optional ID of an Image widget to display at the top of the '
          'card. The Image fit should typically be "cover". Be sure to create '
          'an Image widget with a matching ID.',
    ),
    'title': A2uiSchemas.stringReference(description: 'The title of the card.'),
    'body': A2uiSchemas.stringReference(
      description: 'The body text of the card.',
    ),
  },
  required: ['component', 'title', 'body'],
);

extension type _CompactInfoCardData.fromMap(Map<String, Object?> _json) {
  String? get imageChildId => _json['imageChildId'] as String?;
  Object get title => _json['title'] as Object;
  Object get body => _json['body'] as Object;
}

final compactInfoCard = CatalogItem(
  name: 'CompactInfoCard',
  isImplicitlyFlexible: true,
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": "CompactInfoCard",
          "title": "Beautiful Beach",
          "body": "A lovely sandy beach perfect for a day trip.",
          "imageChildId": "image1"
        },
        {
          "id": "image1",
          "component": "Image",
          "url": "https://example.com/beach.jpg"
        }
      ]
    ''',
  ],
  widgetBuilder: (context) {
    final cardData = _CompactInfoCardData.fromMap(
      context.data as Map<String, Object?>,
    );
    final Widget? imageChild = cardData.imageChildId != null
        ? context.buildChild(cardData.imageChildId!)
        : null;

    return _CompactInfoCard(
      imageChild: imageChild,
      dataContext: context.dataContext,
      title: cardData.title,
      body: cardData.body,
    );
  },
);

class _CompactInfoCard extends StatelessWidget {
  const _CompactInfoCard({
    required this.dataContext,
    required this.title,
    required this.body,
    this.imageChild,
  });

  final DataContext dataContext;
  final Object title;
  final Object body;
  final Widget? imageChild;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageChild != null)
            SizedBox(width: double.infinity, height: 150, child: imageChild),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BoundString(
                  dataContext: dataContext,
                  value: title,
                  builder: (context, title) => Text(
                    '${title ?? ''} - Compact',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
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
        ],
      ),
    );
  }
}
