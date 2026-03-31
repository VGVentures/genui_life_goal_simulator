import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/l10n/l10n.dart';
import 'package:genui_life_goal_simulator/onboarding/want_to_focus/view/widgets/focus_options_desktop.dart';
import 'package:genui_life_goal_simulator/onboarding/want_to_focus/view/widgets/focus_options_mobile.dart';

class WantToFocusView extends StatelessWidget {
  const WantToFocusView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final themeOf = Theme.of(context);
    final colorExtension = themeOf.extension<AppColors>();

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
            ).copyWith(color: colorExtension?.onSurface),
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
