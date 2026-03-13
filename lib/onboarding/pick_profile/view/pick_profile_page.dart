import 'dart:async';

import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/onboarding/pick_profile/pick_profile.dart';
import 'package:finance_app/onboarding/want_to_focus/view/want_to_focus_page.dart';
import 'package:finance_app/onboarding/widgets/widgets.dart';
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
        floatingActionButton: BlocBuilder<PickProfileCubit, PickProfileState>(
          builder: (context, state) => OnboardingNextButton(
            onPressed: state.hasSelection
                ? () {
                    unawaited(
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => WantToFocusPage(
                            profileType: state.selectedProfile!,
                          ),
                        ),
                      ),
                    );
                  }
                : null,
          ),
        ),
      ),
    );
  }
}

abstract final class _Dimensions {
  static const double mobileHorizontalPadding = Spacing.xxl;
  static const double mobileVerticalPadding = 0;
  static const double horizontalPadding = 200;
  static const double verticalPadding = 0;
}
