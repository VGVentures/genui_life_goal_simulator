import 'package:flutter/material.dart';
import 'package:vgv_genui_financial_advisor/design_system/app_colors.dart';

enum FilterChipColor {
  pink,
  mustard,
  orange,
  brightOrange,
  deepRed,
  plum,
  aqua,
  lightBlue,
  lightOlive,
  darkOlive,
  emerald,
}

extension FilterChipColorX on FilterChipColor {
  /// Aqua and Light Olive are too light for white text to be legible
  /// when selected.
  bool get useDarkTextWhenSelected =>
      this == FilterChipColor.aqua || this == FilterChipColor.lightOlive;

  Color toColor(AppColors colors) => switch (this) {
    FilterChipColor.pink => colors.pinkColor,
    FilterChipColor.mustard => colors.mustardColor,
    FilterChipColor.orange => colors.orangeColor,
    FilterChipColor.brightOrange => colors.brightOrangeColor,
    FilterChipColor.deepRed => colors.deepRedColor,
    FilterChipColor.plum => colors.plumColor,
    FilterChipColor.aqua => colors.aquaColor,
    FilterChipColor.lightBlue => colors.lightBlueColor,
    FilterChipColor.lightOlive => colors.lightOliveColor,
    FilterChipColor.darkOlive => colors.darkOliveColor,
    FilterChipColor.emerald => colors.emeraldColor,
  };
}
