import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/gen/assets.gen.dart';

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
    final colorExtension = themeOf.extension<AppColors>();
    final isActive = isEditing || _hasText;
    final iconSize = responsiveValue(
      context,
      mobile: Spacing.sm,
      desktop: _Dimensions.iconSize,
    );

    return Material(
      color: colorExtension?.onPrimary,
      borderRadius: BorderRadius.circular(Spacing.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (!isEditing) {
            setState(() => isEditing = true);
            _focusNode.requestFocus();
          }
        },
        hoverColor: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(Spacing.lg),
        child: Ink(
          decoration: BoxDecoration(
            color: isActive
                ? colorExtension?.primary.withValues(alpha: 0.1)
                : colorExtension?.surfaceVariant,
            borderRadius: BorderRadius.circular(Spacing.lg),
            border: Border.all(
              color: isActive
                  ? colorExtension?.primary ?? Colors.white
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
                    style:
                        responsiveValue<TextStyle>(
                          context,
                          mobile: AppTextStyles.titleMediumMobile,
                          desktop: AppTextStyles.headlineLargeDesktop,
                        ).copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorExtension?.onSurface,
                        ),
                    decoration: InputDecoration.collapsed(
                      hintText: widget.label,
                      hintStyle:
                          responsiveValue<TextStyle>(
                            context,
                            mobile: AppTextStyles.titleMediumMobile,
                            desktop: AppTextStyles.headlineLargeDesktop,
                          ).copyWith(
                            fontWeight: FontWeight.w500,
                            color: colorExtension?.onSurfaceDisabled,
                          ),
                    ),
                    onSubmitted: (value) {
                      setState(() => isEditing = false);
                      widget.onChanged?.call(value);
                    },
                    onChanged: (value) {
                      widget.onChanged?.call(value);
                    },
                    onTapUpOutside: (_) => setState(() => isEditing = false),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          _hasText ? _controller.text : widget.label,
                          style:
                              responsiveValue<TextStyle>(
                                context,
                                mobile: AppTextStyles.titleMediumMobile,
                                desktop: AppTextStyles.headlineLargeDesktop,
                              ).copyWith(
                                fontWeight: FontWeight.w500,
                                color: _hasText
                                    ? colorExtension?.onSurface
                                    : colorExtension?.onSurfaceVariant,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!_hasText) ...[
                        SizedBox(
                          width: responsiveValue(
                            context,
                            mobile: Spacing.xs,
                            desktop: Spacing.md,
                          ),
                        ),
                        Assets.images.onboarding.editPencil.svg(
                          width: iconSize,
                          height: iconSize,
                          colorFilter: ColorFilter.mode(
                            colorExtension?.onSurfaceVariant ?? Colors.black,
                            BlendMode.srcIn,
                          ),
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
}
