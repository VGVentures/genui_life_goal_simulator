import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/gen/assets.gen.dart';
import 'package:finance_app/onboarding/pick_profile/pick_profile.dart';
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
            colorExtensions?.primarySurface ?? Colors.grey.shade200,
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
        floatingActionButton: Builder(
          builder: (context) => SizedBox(
            width: fabSize,
            height: fabSize,
            child: FloatingActionButton(
              onPressed: () {
                // TODO(paulinacrespi): Add navigation to next screen.
              },
              backgroundColor: Colors.transparent,
              hoverColor: colorExtensions?.primarySurface,
              elevation: 0,
              shape: CircleBorder(
                side: BorderSide(
                  color: colorExtensions?.primary ?? Colors.transparent,
                ),
              ),
              child: Assets.images.onboarding.rightArrow.image(
                color: colorExtensions?.primary,
                width: fabIconSize,
                height: fabIconSize,
              ),
            ),
          ),
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
