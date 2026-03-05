import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/gen/assets.gen.dart';
import 'package:finance_app/onboarding/pick_profile/models/profile_type.dart';
import 'package:finance_app/onboarding/want_to_focus/want_to_focus.dart';
import 'package:finance_app/simple_chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WantToFocusPage extends StatelessWidget {
  const WantToFocusPage({required this.profileType, super.key});

  final ProfileType profileType;

  @override
  Widget build(BuildContext context) {
    final colorExtensions = Theme.of(context).extension<AppColors>();
    final fabSize = responsiveValue(
      context,
      mobile: _Dimensions.mobileFabSize,
      desktop: _Dimensions.fabSize,
    );
    final fabIconSize = responsiveValue(
      context,
      mobile: _Dimensions.mobileFabIconSize,
      desktop: _Dimensions.fabIconSize,
    );

    return BlocProvider(
      create: (_) => WantToFocusCubit(),
      child: Scaffold(
        backgroundColor: colorExtensions?.secondary.shade200,
        body: SingleChildScrollView(
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: BlocBuilder<WantToFocusCubit, WantToFocusState>(
          builder: (context, state) => SizedBox(
            width: fabSize,
            height: fabSize,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => ChatScreen(
                      profileType: profileType,
                      customScenario: state.customOption,
                      selectedOptions: state.selectedOptions,
                    ),
                  ),
                );
              },
              backgroundColor: Colors.transparent,
              hoverColor: colorExtensions?.secondary.shade200,
              elevation: 0,
              shape: CircleBorder(
                side: BorderSide(
                  color:
                      colorExtensions?.secondary.shade700 ?? Colors.transparent,
                ),
              ),
              child: Assets.images.onboarding.rightArrow.image(
                color: colorExtensions?.secondary.shade700,
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
  static const double horizontalPadding = 200;
  static const double verticalPadding = 120;
  static const double fabSize = 140;
  static const double fabIconSize = 22;
  static const double mobileFabSize = 80;
  static const double mobileFabIconSize = 13;
}
