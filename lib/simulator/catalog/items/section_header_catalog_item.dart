import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A section header with a title, subtitle, and an optional chip '
      'selector for switching between time ranges or views. '
      'Title and subtitle can be literal strings or data model bindings '
      '(e.g. {"path": "/<componentId>/value"}) to reactively display '
      'values from input widgets like GCNSlider.',
  properties: {
    'title': A2uiSchemas.stringReference(
      description: 'Main title text of the section.',
    ),
    'subtitle': A2uiSchemas.stringReference(
      description: 'Subtitle text displayed below the title.',
    ),
    'selectorOptions': S.list(
      items: S.string(),
      description:
          'Optional chip labels for the HeaderSelector '
          '(e.g. ["1M", "3M", "6M"]). Omit to hide the selector.',
    ),
    'selectedIndex': S.integer(
      description:
          'Zero-based index of the selected chip. '
          'Only relevant when selectorOptions is provided. Defaults to 0.',
      minimum: 0,
    ),
  },
  required: ['title', 'subtitle'],
);

/// CatalogItem that renders a [SectionHeader] with an optional selector.
///
/// The `title` and `subtitle` properties support data model bindings via
/// `{"path": "..."}`, allowing them to reactively display values from input
/// widgets like GCNSlider.
final sectionHeaderItem = CatalogItem(
  name: 'SectionHeader',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;

    final titleValue = json['title']!;
    final subtitleValue = json['subtitle']!;
    final rawOptions = json['selectorOptions'] as List<Object?>?;
    final selectorOptions = rawOptions?.map((e) => e! as String).toList();
    final selectedIndex = (json['selectedIndex'] as num?)?.toInt() ?? 0;

    return BoundString(
      dataContext: ctx.dataContext,
      value: titleValue,
      builder: (context, title) {
        return BoundString(
          dataContext: ctx.dataContext,
          value: subtitleValue,
          builder: (context, subtitle) {
            return SectionHeader(
              title: title ?? '',
              subtitle: subtitle ?? '',
              selectorOptions: selectorOptions,
              selectedIndex: selectedIndex,
            );
          },
        );
      },
    );
  },
);
