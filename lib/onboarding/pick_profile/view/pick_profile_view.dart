import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';
import 'package:vgv_genui_financial_advisor/l10n/l10n.dart';
import 'package:vgv_genui_financial_advisor/onboarding/pick_profile/pick_profile.dart';

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
          mainAxisAlignment: responsiveValue<MainAxisAlignment>(
            context,
            mobile: MainAxisAlignment.start,
            desktop: MainAxisAlignment.center,
          ),
          spacing: responsiveValue<double>(
            context,
            mobile: Spacing.xl,
            desktop: Spacing.xxxl * 2,
          ),
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
              Expanded(
                child: SingleChildScrollView(
                  child: MobileCards(selectedProfile: state.selectedProfile),
                ),
              )
            else
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SizedBox(
                      width: _DesktopCardsSize.width,
                      height: _DesktopCardsSize.height,
                      child: DesktopCards(
                        selectedProfile: state.selectedProfile,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

abstract final class _DesktopCardsSize {
  static const double width = 1084;
  static const double height = 610;
}
