import 'package:finance_app/app/presentation.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A call-to-action button for navigating to a detail view, '
      'confirming a choice, or starting a workflow.',
  properties: {
    'label': S.string(description: 'The button text.'),
    'variant': S.string(
      description: 'Visual style of the button.',
      enumValues: ['filled', 'outlined'],
    ),
    'size': S.string(
      description: 'Size of the button.',
      enumValues: ['large', 'small'],
    ),
    'isLoading': S.boolean(
      description: 'Whether the button shows a loading indicator.',
    ),
  },
  required: ['label', 'variant', 'size'],
);

/// CatalogItem that renders an [AppButton] widget.
final appButtonItem = CatalogItem(
  name: 'AppButton',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;

    final label = json['label']! as String;
    final variant = switch (json['variant']! as String) {
      'outlined' => AppButtonVariant.outlined,
      _ => AppButtonVariant.filled,
    };
    final size = switch (json['size']! as String) {
      'small' => AppButtonSize.small,
      _ => AppButtonSize.large,
    };
    final isLoading = json['isLoading'] as bool? ?? false;

    return AppButton(
      label: label,
      variant: variant,
      size: size,
      isLoading: isLoading,
      onPressed: () {},
    );
  },
);
