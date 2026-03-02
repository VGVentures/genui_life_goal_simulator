import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/gen/assets.gen.dart';
import 'package:finance_app/onboarding/pick_profile/pick_profile.dart';
import 'package:finance_app/onboarding/want_to_focus/view/want_to_focus_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PickProfilePage extends StatelessWidget {
  const PickProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorExtensions = Theme.of(context).extension<AppColors>();
    final isMobile = Breakpoints.isMobile(MediaQuery.of(context).size.width);

    final horizontalPadding = isMobile
        ? _Dimensions.mobileHorizontalPadding
        : _Dimensions.horizontalPadding;
    final verticalPadding = isMobile
        ? _Dimensions.mobileVerticalPadding
        : _Dimensions.verticalPadding;
    final fabSize = isMobile ? _Dimensions.mobileFabSize : _Dimensions.fabSize;
    final fabIconSize = responsiveValue(
      context,
      mobile: _Dimensions.mobileFabIconSize,
      desktop: _Dimensions.fabIconSize,
    );

    return BlocProvider(
      create: (_) => PickProfileCubit(),
      child: Scaffold(
        backgroundColor:
            colorExtensions?.secondary.shade200 ?? Colors.grey.shade200,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: const PickProfileView(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: BlocBuilder<PickProfileCubit, PickProfileState>(
          builder: (context, state) {
            return SizedBox(
              width: fabSize,
              height: fabSize,
              child: FloatingActionButton(
                onPressed: state.selectedProfile != null
                    ? () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) => WantToFocusPage(
                              profileType: state.selectedProfile!,
                            ),
                          ),
                        );
                      }
                    : null,
                backgroundColor: Colors.transparent,
                hoverColor: colorExtensions?.secondary.shade200,
                elevation: 0,
                shape: CircleBorder(
                  side: BorderSide(
                    color:
                        colorExtensions?.secondary.shade700 ??
                        Colors.transparent,
                  ),
                ),
                child: Assets.images.onboarding.rightArrow.image(
                  color: colorExtensions?.secondary.shade700,
                  width: fabIconSize,
                  height: fabIconSize,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

abstract final class _Dimensions {
  // Mobile
  static const double mobileHorizontalPadding = Spacing.xxl;
  static const double mobileVerticalPadding = 0;
  static const double mobileFabSize = 80;
  static const double mobileFabIconSize = 13;

  // Desktop
  static const double horizontalPadding = 200;
  static const double verticalPadding = 0;
  static const double fabSize = 140;
  static const double fabIconSize = 22;
}
