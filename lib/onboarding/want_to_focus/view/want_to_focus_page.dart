import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv_genui_financial_advisor/advisor/view/advisor_page.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';
import 'package:vgv_genui_financial_advisor/onboarding/pick_profile/models/profile_type.dart';
import 'package:vgv_genui_financial_advisor/onboarding/want_to_focus/want_to_focus.dart';
import 'package:vgv_genui_financial_advisor/onboarding/widgets/widgets.dart';

class WantToFocusPage extends StatelessWidget {
  const WantToFocusPage({required this.profileType, super.key});

  final ProfileType profileType;

  @override
  Widget build(BuildContext context) {
    final colorExtensions = Theme.of(context).extension<AppColors>();

    return BlocProvider(
      create: (_) => WantToFocusCubit(),
      child: Scaffold(
        backgroundColor: colorExtensions?.primarySurface,
        body: SafeArea(
          child: SingleChildScrollView(
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
              child: const WantToFocusView(),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: BlocBuilder<WantToFocusCubit, WantToFocusState>(
          builder: (context, state) => OnboardingNextButton(
            onPressed: state.hasSelection
                ? () {
                    unawaited(
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => AdvisorPage(
                            profileType: profileType,
                            focusOptions: state.selectedOptions,
                            customOption: state.customOption,
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
  static const double verticalPadding = 120;
}
