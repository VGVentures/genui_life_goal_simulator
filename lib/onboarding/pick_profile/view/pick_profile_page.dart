import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/onboarding/pick_profile/pick_profile.dart';
import 'package:genui_life_goal_simulator/onboarding/want_to_focus/view/want_to_focus_page.dart';
import 'package:genui_life_goal_simulator/onboarding/widgets/widgets.dart';

class PickProfilePage extends StatelessWidget {
  const PickProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorExtensions = Theme.of(context).extension<AppColors>();

    return BlocProvider(
      create: (_) => PickProfileCubit(),
      child: Scaffold(
        backgroundColor:
            colorExtensions?.primarySurface ?? Colors.grey.shade200,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsiveValue(
                context,
                mobile: Spacing.xxl,
                desktop: _Dimensions.horizontalPadding,
              ),
              vertical: responsiveValue(
                context,
                mobile: Spacing.md,
                desktop: _Dimensions.verticalPadding,
              ),
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
  static const double horizontalPadding = 200;
  static const double verticalPadding = 80;
}
