import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:finance_app/onboarding/pick_profile/pick_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PickProfileView extends StatelessWidget {
  const PickProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(MediaQuery.of(context).size.width);
    final l10n = context.l10n;
    final themeOf = Theme.of(context);
    final colorScheme = themeOf.colorScheme;

    return BlocBuilder<PickProfileCubit, PickProfileState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: Spacing.xxxl,
          children: [
            Text(
              l10n.pickProfileTitle,
              textAlign: TextAlign.center,
              style: responsiveValue<TextStyle>(
                context,
                mobile: AppTextStyles.displaySmallMobile,
                desktop: AppTextStyles.displayLargeDesktop,
              ).copyWith(color: colorScheme.onSurface),
            ),
            if (isMobile)
              MobileCards(selectedProfile: state.selectedProfile)
            else
              DesktopCards(selectedProfile: state.selectedProfile),
          ],
        );
      },
    );
  }
}
