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
          Padding(
            padding: const EdgeInsets.only(right: Spacing.xxxl * 2),
            child: _HoverableCard(
              profileType: type,
              isSelected: selectedProfile == type,
              onTap: () => context.read<PickProfileCubit>().selectProfile(type),
            ),
          ),
      ],
    );
  }
}

class _HoverableCard extends StatefulWidget {
  const _HoverableCard({
    required this.profileType,
    required this.isSelected,
    required this.onTap,
  });

  final ProfileType profileType;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_HoverableCard> createState() => _HoverableCardState();
}

class _HoverableCardState extends State<_HoverableCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      opaque: false,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? _Dimensions.cardScaleHover : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: SizedBox(
          width: _Dimensions.cardWidth,
          height: _Dimensions.cardHeight,
          child: ProfileCard(
            profileType: widget.profileType,
            isSelected: widget.isSelected,
            onTap: widget.onTap,
          ),
        ),
      ),
    );
  }
}

abstract final class _Dimensions {
  static const double cardWidth = 450;
  static const double cardHeight = 572;
  static const double cardScaleHover = 1.06;
}
