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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final image = isDark
        ? Assets.images.advisor.vgvunicornAppbarDarkmode
        : Assets.images.advisor.vgvunicornAppbar;
    return image.svg(
      width: size,
      height: size,
    );
  }
}
