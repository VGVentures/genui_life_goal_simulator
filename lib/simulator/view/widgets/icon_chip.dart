import 'package:flutter/material.dart';

class IconChip extends StatelessWidget {
  const IconChip({
    required this.icon,
    required this.onTap,
    this.gradient,
    this.borderColor,
    super.key,
  });

  final IconData icon;
  final VoidCallback onTap;
  final LinearGradient? gradient;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: gradient,
          shape: BoxShape.circle,
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: Center(
          child: SizedBox(
            height: 16,
            width: 16,
            child: FittedBox(
              child: Icon(
                icon,
                color: gradient != null
                    ? Colors.white
                    : borderColor ?? Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
