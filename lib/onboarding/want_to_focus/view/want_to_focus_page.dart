import 'dart:async';

import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/chat/view/chat_page.dart';
import 'package:finance_app/gen/assets.gen.dart';
import 'package:finance_app/onboarding/pick_profile/models/profile_type.dart';
import 'package:finance_app/onboarding/want_to_focus/want_to_focus.dart';
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
        backgroundColor: colorExtensions?.primarySurface,
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
        floatingActionButton: Builder(
          builder: (context) => SizedBox(
            width: fabSize,
            height: fabSize,
            child: FloatingActionButton(
              onPressed: () {
                final focusState = context.read<WantToFocusCubit>().state;
                unawaited(
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => ChatPage(
                        profileType: profileType,
                        focusOptions: focusState.selectedOptions,
                        customOption: focusState.customOption,
                      ),
                    ),
                  ),
                );
              },
              backgroundColor: Colors.transparent,
              hoverColor: colorExtensions?.primaryContainer,
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
  static const double horizontalPadding = 200;
  static const double verticalPadding = 120;
  static const double fabSize = 140;
  static const double fabIconSize = 22;
  static const double mobileFabSize = 80;
  static const double mobileFabIconSize = 13;
}
