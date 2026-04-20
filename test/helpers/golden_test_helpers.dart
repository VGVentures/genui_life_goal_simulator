import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/l10n/l10n.dart';

/// Wraps a widget under test with the app's [ThemeData] and localizations
/// without the overhead of a full [MaterialApp].
///
/// [MaterialApp] expects unbounded layout constraints for its Navigator,
/// which conflicts with the bounded constraints Alchemist sets per golden
/// test scenario. This wrapper provides everything most design-system
/// widgets expect — [Directionality], [Theme], [AppLocalizations],
/// [MediaQuery], and [Material] — while still sizing itself to its child.
///
/// Widgets that internally use an [Overlay] (e.g. `Slider`) need
/// [themedAppWithOverlay] instead.
Widget themedApp({
  required Widget child,
  ThemeType themeType = ThemeType.light,
  EdgeInsets padding = const EdgeInsets.all(16),
  Size mediaQuerySize = Size.zero,
}) {
  final appTheme = AppThemes.getAppTheme(themeType).themeData;
  final themeData = appTheme.themeData;
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Theme(
      data: themeData,
      child: Localizations(
        locale: const Locale('en'),
        delegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        child: MediaQuery(
          data: MediaQueryData(size: mediaQuerySize),
          child: Material(
            color: themeData.colorScheme.surface,
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    ),
  );
}

/// Same as [themedApp] but forces a fixed [size] and adds an [Overlay]
/// ancestor for widgets that need one (e.g. `Slider`).
///
/// [Overlay] uses a [LayoutBuilder] internally, which cannot answer
/// intrinsic-dimension queries. Alchemist's golden test group lays
/// scenarios out in a [Table] that needs intrinsic dimensions, so we
/// side-step by pinning the scenario to a fixed [size].
Widget themedAppWithOverlay({
  required Widget child,
  required Size size,
  ThemeType themeType = ThemeType.light,
  EdgeInsets padding = const EdgeInsets.all(16),
}) {
  final appTheme = AppThemes.getAppTheme(themeType).themeData;
  final themeData = appTheme.themeData;
  return SizedBox.fromSize(
    size: size,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Theme(
        data: themeData,
        child: Localizations(
          locale: const Locale('en'),
          delegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          child: MediaQuery(
            data: const MediaQueryData(),
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (_) => Material(
                    color: themeData.colorScheme.surface,
                    child: Padding(padding: padding, child: child),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
