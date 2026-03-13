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
    final textTheme = themeOf.textTheme;
    final colorScheme = themeOf.colorScheme;

    return BlocBuilder<PickProfileCubit, PickProfileState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              height: isMobile ? 60 : _Dimensions.titleSpacing,
            ),
            Text(
              l10n.pickProfileTitle,
              textAlign: TextAlign.center,
              style: textTheme.displayLarge?.copyWith(
                fontSize: responsiveValue(
                  context,
                  mobile: _Dimensions.mobileTitleSize,
                  desktop: _Dimensions.titleSize,
                ),
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            SizedBox(
              height: isMobile ? Spacing.xl : _Dimensions.cardsTopSpacing,
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

abstract final class _Dimensions {
  static const double titleSize = 36;
  static const double mobileTitleSize = 25;
  static const double titleSpacing = 40;
  static const double cardsTopSpacing = 70;
}
