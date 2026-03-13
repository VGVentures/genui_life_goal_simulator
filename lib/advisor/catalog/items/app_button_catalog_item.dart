import 'package:finance_app/app/presentation.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A call-to-action button for navigating to a detail view, '
      'confirming a choice, or starting a workflow.',
  properties: {
    'label': A2uiSchemas.stringReference(
      description: 'The button text.',
    ),
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
    'action': A2uiSchemas.action(
      description: 'The action to perform when the button is pressed.',
    ),
  },
  required: ['label', 'variant', 'size', 'action'],
);

/// CatalogItem that renders an [AppButton] widget.
final appButtonItem = CatalogItem(
  name: 'AppButton',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;

    final labelValue = json['label']!;
    final variant = switch (json['variant']! as String) {
      'outlined' => AppButtonVariant.outlined,
      _ => AppButtonVariant.filled,
    };
    final size = switch (json['size']! as String) {
      'small' => AppButtonSize.small,
      _ => AppButtonSize.large,
    };
    final isLoading = json['isLoading'] as bool? ?? false;
    final action = json['action'] as Map<String, Object?>?;

    return BoundString(
      dataContext: ctx.dataContext,
      value: labelValue,
      builder: (context, label) {
        return AppButton(
          label: label ?? '',
          variant: variant,
          size: size,
          isLoading: isLoading,
          onPressed: () {
            if (action case {'event': final Map<String, Object?> event}) {
              ctx.dispatchEvent(
                UserActionEvent(
                  name: event['name']! as String,
                  sourceComponentId: ctx.id,
                  context: event['context'] as Map<String, Object?>? ?? {},
                ),
              );
            }
          },
        );
      },
    );
  },
);
