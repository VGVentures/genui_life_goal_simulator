import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';
import 'package:vgv_genui_financial_advisor/onboarding/pick_profile/pick_profile.dart';

class MobileCards extends StatelessWidget {
  const MobileCards({required this.selectedProfile, super.key});

  final ProfileType? selectedProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final type in ProfileType.values)
          Padding(
            padding: const EdgeInsets.only(bottom: Spacing.md),
            child: ProfileCard(
              profileType: type,
              isSelected: selectedProfile == type,
              onTap: () => context.read<PickProfileCubit>().selectProfile(type),
            ),
          ),
      ],
    );
  }
}
