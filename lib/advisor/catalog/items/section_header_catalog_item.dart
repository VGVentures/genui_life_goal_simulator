import 'package:finance_app/app/presentation.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A section header with a title, subtitle, and an optional chip '
      'selector for switching between time ranges or views.',
  properties: {
    'title': S.string(description: 'Main title text of the section.'),
    'subtitle': S.string(
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
final sectionHeaderItem = CatalogItem(
  name: 'SectionHeader',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;

    final title = json['title']! as String;
    final subtitle = json['subtitle']! as String;
    final rawOptions = json['selectorOptions'] as List<Object?>?;
    final selectorOptions = rawOptions?.map((e) => e! as String).toList();
    final selectedIndex = (json['selectedIndex'] as num?)?.toInt() ?? 0;

    return SectionHeader(
      title: title,
      subtitle: subtitle,
      selectorOptions: selectorOptions,
      selectedIndex: selectedIndex,
    );
  },
);
