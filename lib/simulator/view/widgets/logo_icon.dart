import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/gen/assets.gen.dart';

class LogoIcon extends StatelessWidget {
  const LogoIcon({
    super.key,
    this.size = 40,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Assets.images.advisor.advisorLogo.svg(
      width: size,
      height: size,
    );
  }
}
