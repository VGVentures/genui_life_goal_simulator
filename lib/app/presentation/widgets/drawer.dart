import 'dart:async';

import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';

/// {@template app_drawer}
/// A molecule widget that represents an expandable content panel with
/// collapsed and open states.
///
/// Displays a [title] in the header with an expand/collapse icon.
/// When expanded, shows the [content] widget below the header.
///
/// Use [ActionItemsGroup] as content to render a list of action items.
/// {@endtemplate}
class AppDrawer extends StatefulWidget {
  const AppDrawer({
    required this.title,
    required this.content,
    this.isExpanded = false,
    this.onToggle,
    super.key,
  });

  /// Header text displayed in the drawer.
  final String title;

  /// Content widget shown when the drawer is expanded.
  final Widget content;

  /// Whether the drawer starts in expanded state.
  final bool isExpanded;

  /// Callback when the drawer is toggled.
  final ValueChanged<bool>? onToggle;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late Animation<double> _iconRotation;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
    _controller = AnimationController(
      duration: _DrawerDimensions.animationDuration,
      vsync: this,
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
    _iconRotation = _controller.drive(
      Tween<double>(begin: 0, end: 0.5).chain(
        CurveTween(curve: Curves.easeInOut),
      ),
    );

    if (_isExpanded) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(AppDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      _setExpanded(widget.isExpanded);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleToggle() {
    final newExpanded = !_isExpanded;
    _setExpanded(newExpanded);
    widget.onToggle?.call(newExpanded);
  }

  void _setExpanded(bool expanded) {
    setState(() {
      _isExpanded = expanded;
      if (_isExpanded) {
        unawaited(_controller.forward());
      } else {
        unawaited(_controller.reverse());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colors?.surfaceVariant ?? _DrawerColors.surface,
        borderRadius: BorderRadius.circular(_DrawerDimensions.borderRadius),
        border: Border.all(
          color: colors?.outlineVariant ?? _DrawerColors.border,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DrawerHeader(
            title: widget.title,
            isExpanded: _isExpanded,
            iconRotation: _iconRotation,
            onToggle: _handleToggle,
            textTheme: textTheme,
            colors: colors,
          ),
          ClipRect(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _heightFactor.value,
                  child: child,
                );
              },
              child: _DrawerContent(
                content: widget.content,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({
    required this.title,
    required this.isExpanded,
    required this.iconRotation,
    required this.onToggle,
    required this.textTheme,
    required this.colors,
  });

  final String title;
  final bool isExpanded;
  final Animation<double> iconRotation;
  final VoidCallback onToggle;
  final TextTheme textTheme;
  final AppColors? colors;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(_DrawerDimensions.borderRadius),
      child: Container(
        height: _DrawerDimensions.collapsedHeight,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: textTheme.titleSmall?.copyWith(
                  color: colors?.onSurface ?? _DrawerColors.title,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            RotationTransition(
              turns: iconRotation,
              child: Icon(
                Icons.keyboard_arrow_down,
                color: colors?.onSurface ?? _DrawerColors.icon,
                size: _DrawerDimensions.iconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerContent extends StatelessWidget {
  const _DrawerContent({
    required this.content,
  });

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Spacing.lg,
        right: Spacing.lg,
        bottom: Spacing.md,
      ),
      child: content,
    );
  }
}

abstract final class _DrawerDimensions {
  static const double collapsedHeight = 56;
  static const double borderRadius = 16;
  static const double iconSize = 24;
  static const Duration animationDuration = Duration(milliseconds: 300);
}

abstract final class _DrawerColors {
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFF0F1F1);
  static const Color title = Color(0xFF1A1C1C);
  static const Color icon = Color(0xFF5D5F5F);
}
