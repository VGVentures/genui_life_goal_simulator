import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'DESKTOP ONLY: a split-layout hero with image on the left and '
      'title/subtitle/description on the right.',
  properties: {
    'component': S.string(enumValues: ['WideHero']),
    'imageChildId': S.string(
      description:
          'Optional ID of an Image widget to display on the left half. '
          'The Image fit should typically be "cover". Be sure to create '
          'an Image widget with a matching ID.',
    ),
    'title': A2uiSchemas.stringReference(
      description: 'The hero title.',
    ),
    'subtitle': A2uiSchemas.stringReference(
      description: 'An optional subtitle displayed below the title.',
    ),
    'body': A2uiSchemas.stringReference(
      description: 'An optional body description.',
    ),
  },
  required: ['component', 'title'],
);

extension type _WideHeroData.fromMap(Map<String, Object?> _json) {
  String? get imageChildId => _json['imageChildId'] as String?;
  Object get title => _json['title'] as Object;
  Object? get subtitle => _json['subtitle'];
  Object? get body => _json['body'];
}

final wideHero = CatalogItem(
  name: 'WideHero',
  isImplicitlyFlexible: true,
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": "WideHero",
          "title": "Explore Paris",
          "subtitle": "The City of Light",
          "body": "Discover world-class art and cuisine.",
          "imageChildId": "hero_img"
        },
        {
          "id": "hero_img",
          "component": "Image",
          "url": "https://example.com/paris.jpg"
        }
      ]
    ''',
  ],
  widgetBuilder: (context) {
    final data = _WideHeroData.fromMap(
      context.data as Map<String, Object?>,
    );
    final Widget? imageChild = data.imageChildId != null
        ? context.buildChild(data.imageChildId!)
        : null;

    return _WideHero(
      imageChild: imageChild,
      dataContext: context.dataContext,
      title: data.title,
      subtitle: data.subtitle,
      body: data.body,
    );
  },
);

class _WideHero extends StatelessWidget {
  const _WideHero({
    required this.dataContext,
    required this.title,
    this.imageChild,
    this.subtitle,
    this.body,
  });

  final DataContext dataContext;
  final Object title;
  final Widget? imageChild;
  final Object? subtitle;
  final Object? body;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 240,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (imageChild != null)
              Expanded(child: imageChild!),
            Expanded(
              child: Container(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    BoundString(
                      dataContext: dataContext,
                      value: title,
                      builder: (context, title) => Text(
                        title ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium,
                      ),
                    ),
                    BoundString(
                      dataContext: dataContext,
                      value: subtitle,
                      builder: (context, subtitle) {
                        if (subtitle == null) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding:
                              const EdgeInsets.only(top: 4),
                          child: Text(
                            subtitle,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium,
                          ),
                        );
                      },
                    ),
                    BoundString(
                      dataContext: dataContext,
                      value: body,
                      builder: (context, body) {
                        if (body == null) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding:
                              const EdgeInsets.only(top: 12),
                          child: Text(
                            body,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge,
                          ),
                        );
                      },
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
