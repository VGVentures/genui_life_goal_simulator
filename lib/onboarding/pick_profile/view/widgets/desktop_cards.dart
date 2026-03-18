import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';
import 'package:vgv_genui_financial_advisor/onboarding/pick_profile/pick_profile.dart';

class DesktopCards extends StatelessWidget {
  const DesktopCards({required this.selectedProfile, super.key});

  final ProfileType? selectedProfile;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final type in ProfileType.values)
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: Spacing.xxxl * 2),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: _Dimensions.cardWidth,
                ),
                child: ProfileCard(
                  profileType: type,
                  isSelected: selectedProfile == type,
                  onTap: () =>
                      context.read<PickProfileCubit>().selectProfile(type),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

abstract final class _Dimensions {
  static const double cardWidth = 450;
}
