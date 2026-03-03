import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class WriteYourOwnOptionCard extends StatefulWidget {
  const WriteYourOwnOptionCard({
    required this.label,
    this.onChanged,
    super.key,
  });

  final String label;
  final ValueChanged<String>? onChanged;

  @override
  State<WriteYourOwnOptionCard> createState() => _WriteYourOwnOptionCardState();
}

class _WriteYourOwnOptionCardState extends State<WriteYourOwnOptionCard> {
  bool isEditing = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && isEditing) {
        setState(() => isEditing = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get _hasText => _controller.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final themeOf = Theme.of(context);
    final colorScheme = themeOf.colorScheme;
    final colorExtension = themeOf.extension<AppColors>();
    final textTheme = themeOf.textTheme;
    final isActive = isEditing || _hasText;
    final textSize = responsiveValue(
      context,
      mobile: _Dimensions.mobileTextSize,
      desktop: _Dimensions.fontSize,
    );
    final iconSize = responsiveValue(
      context,
      mobile: Spacing.sm,
      desktop: _Dimensions.iconSize,
    );

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(Spacing.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (!isEditing) {
            setState(() => isEditing = true);
            _focusNode.requestFocus();
          }
        },
        borderRadius: BorderRadius.circular(Spacing.lg),
        child: Ink(
          decoration: BoxDecoration(
            color: isActive
                ? colorExtension?.primaryContainer
                : colorExtension?.surfaceVariant,
            borderRadius: BorderRadius.circular(Spacing.lg),
            border: Border.all(
              color: isActive
                  ? colorExtension?.primary ?? colorScheme.primary
                  : Colors.transparent,
              width: _Dimensions.borderWidth,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: responsiveValue(
                context,
                mobile: Spacing.md,
                desktop: _Dimensions.verticalPadding,
              ),
              horizontal: responsiveValue(
                context,
                mobile: Spacing.xs,
                desktop: _Dimensions.horizontalPadding,
              ),
            ),
            child: isEditing
                ? TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      fontSize: textSize,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    decoration: InputDecoration.collapsed(
                      hintText: widget.label,
                      hintStyle: textTheme.bodyLarge?.copyWith(
                        fontSize: textSize,
                        fontWeight: FontWeight.w400,
                        color: colorExtension?.onSurfaceMuted,
                      ),
                    ),
                    onSubmitted: (value) {
                      setState(() => isEditing = false);
                      widget.onChanged?.call(value);
                    },
                    onChanged: (value) {
                      widget.onChanged?.call(value);
                    },
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          _hasText ? _controller.text : widget.label,
                          style: textTheme.bodyLarge?.copyWith(
                            fontSize: textSize,
                            fontWeight: _hasText
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: colorScheme.onPrimaryContainer,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!_hasText) ...[
                        const SizedBox(width: Spacing.xs),
                        Assets.images.onboarding.editPencil.image(
                          width: iconSize,
                          height: iconSize,
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

abstract final class _Dimensions {
  static const double iconSize = 20;
  static const double borderWidth = 2;
  static const double horizontalPadding = 20;
  static const double verticalPadding = 44;
  static const double fontSize = 32;
  static const double mobileTextSize = 18;
}
