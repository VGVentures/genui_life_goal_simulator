import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'MOBILE ONLY: a full-width hero banner with a background image and '
      'overlaid title/subtitle text.',
  properties: {
    'component': S.string(enumValues: ['CompactHero']),
    'imageChildId': S.string(
      description:
          'Optional ID of an Image widget to use as the background. '
          'The Image fit should typically be "cover". Be sure to create '
          'an Image widget with a matching ID.',
    ),
    'title': A2uiSchemas.stringReference(
      description: 'The hero title, displayed prominently over the image.',
    ),
    'subtitle': A2uiSchemas.stringReference(
      description: 'An optional subtitle displayed below the title.',
    ),
  },
  required: ['component', 'title'],
);

extension type _CompactHeroData.fromMap(Map<String, Object?> _json) {
  String? get imageChildId => _json['imageChildId'] as String?;
  Object get title => _json['title'] as Object;
  Object? get subtitle => _json['subtitle'];
}

final compactHero = CatalogItem(
  name: 'CompactHero',
  isImplicitlyFlexible: true,
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": "CompactHero",
          "title": "Explore Paris",
          "subtitle": "The City of Light awaits",
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
    final data = _CompactHeroData.fromMap(
      context.data as Map<String, Object?>,
    );
    final Widget? imageChild = data.imageChildId != null
        ? context.buildChild(data.imageChildId!)
        : null;

    return _CompactHero(
      imageChild: imageChild,
      dataContext: context.dataContext,
      title: data.title,
      subtitle: data.subtitle,
    );
  },
);

class _CompactHero extends StatelessWidget {
  const _CompactHero({
    required this.dataContext,
    required this.title,
    this.imageChild,
    this.subtitle,
  });

  final DataContext dataContext;
  final Object title;
  final Widget? imageChild;
  final Object? subtitle;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: double.infinity,
        height: 180,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ?imageChild,
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withAlpha(179)],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  BoundString(
                    dataContext: dataContext,
                    value: title,
                    builder: (context, title) => Text(
                      title ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  BoundString(
                    dataContext: dataContext,
                    value: subtitle,
                    builder: (context, subtitle) {
                      if (subtitle == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          subtitle,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
