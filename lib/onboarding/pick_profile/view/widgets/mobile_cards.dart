import 'package:finance_app/app/presentation.dart';
import 'package:finance_app/onboarding/pick_profile/pick_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
