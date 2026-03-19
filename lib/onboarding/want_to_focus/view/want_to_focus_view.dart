import 'package:flutter/material.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';
import 'package:vgv_genui_financial_advisor/l10n/l10n.dart';
import 'package:vgv_genui_financial_advisor/onboarding/want_to_focus/view/widgets/focus_options_desktop.dart';
import 'package:vgv_genui_financial_advisor/onboarding/want_to_focus/view/widgets/focus_options_mobile.dart';

class WantToFocusView extends StatelessWidget {
  const WantToFocusView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final themeOf = Theme.of(context);
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
            style: responsiveValue<TextStyle>(
              context,
              mobile: AppTextStyles.displaySmallMobile,
              desktop: AppTextStyles.displayLargeDesktop,
            ).copyWith(color: colorScheme.onPrimaryContainer),
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
