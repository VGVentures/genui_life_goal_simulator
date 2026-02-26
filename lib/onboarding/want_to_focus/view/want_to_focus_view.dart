import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:finance_app/onboarding/want_to_focus/view/widgets/focus_options_desktop.dart';
import 'package:finance_app/onboarding/want_to_focus/view/widgets/focus_options_mobile.dart';
import 'package:flutter/material.dart';

class WantToFocusView extends StatelessWidget {
  const WantToFocusView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final themeOf = Theme.of(context);
    final textTheme = themeOf.textTheme;
    final colorScheme = themeOf.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: Spacing.xxxl,
        children: [
          Text(
            responsiveValue(
              context,
              mobile: l10n.whatWouldYouLikeToFocusLabel,
              desktop: l10n.whatDoYouWantToFocusLabel,
            ),
            style: textTheme.displayLarge?.copyWith(
              fontSize: responsiveValue(
                context,
                mobile: _Dimensions.mobileTitleSize,
                desktop: _Dimensions.titleSize,
              ),
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const ResponsiveScaffold(
            desktop: FocusOptionsDesktop(),
            mobile: FocusOptionsMobile(),
          ),
        ],
      ),
    );
  }
}

abstract final class _Dimensions {
  static const double titleSize = 48;
  static const double mobileTitleSize = 28;
}
