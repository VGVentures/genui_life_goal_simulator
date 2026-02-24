import 'dart:developer';

import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/gen/assets.gen.dart';
import 'package:finance_app/onboarding/want_to_focus/want_to_focus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WantToFocusPage extends StatelessWidget {
  const WantToFocusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorExtensions = Theme.of(context).extension<AppColors>();

    return BlocProvider(
      create: (_) => WantToFocusCubit(),
      child: Scaffold(
        backgroundColor: colorExtensions?.secondary.shade200,
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _Dimensions.horizontalPadding,
              vertical: _Dimensions.verticalPadding,
            ),
            child: WantToFocusView(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Builder(
          builder: (context) => SizedBox(
            width: _Dimensions.fabSize,
            height: _Dimensions.fabSize,
            child: FloatingActionButton(
              onPressed: () {
                // TODO(juanRodriguez17): Add navigation to the next screen
                //when gets merged
                final bloc = context.read<WantToFocusCubit>();
                final focusOptions = bloc.state.selectedOptions.toList()
                  ..add(bloc.state.customOption);
                log('Focus Options($focusOptions)');
              },
              backgroundColor:
                  colorExtensions?.transparent ?? Colors.transparent,
              hoverColor: colorExtensions?.secondary.shade200,
              elevation: 0,
              shape: CircleBorder(
                side: BorderSide(
                  color:
                      colorExtensions?.secondary.shade700 ??
                      colorExtensions?.transparent ??
                      Colors.transparent,
                ),
              ),
              child: Assets.images.onboarding.rightArrow.image(
                color: colorExtensions?.secondary.shade700,
                width: _Dimensions.fabIconSize,
                height: _Dimensions.fabIconSize,
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
  static const double fabIconSize = 28;
}
