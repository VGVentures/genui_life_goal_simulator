import 'package:flutter/material.dart';

/// Design-system color tokens.
///
/// Subclass and override getters to define light/dark theme palettes.
///
/// Access from widgets via:
/// ```dart
/// Theme.of(context).extension<AppColors>()?.primary
/// ```
abstract class AppColors extends ThemeExtension<AppColors> {
  Brightness get brightness;

  /// Primary
  Color get primary;
  Color get onPrimary;
  Color get primaryContainer;
  Color get onPrimaryContainer;
  Color get primarySurface;
  Color get primaryStrong;

  /// Surface
  Color get surface;
  Color get surfaceVariant;
  Color get surfaceContainer;
  Color get surfaceContainerHigh;
  Color get surfaceContainerHighest;
  Color get onSurface;
  Color get onSurfaceVariant;
  Color get onSurfaceMuted;
  Color get onSurfaceDisabled;
  Color get inverseSurface;
  Color get onInverseSurface;

  /// Outline
  Color get outline;
  Color get outlineVariant;
  Color get outlineStrong;

  /// Error
  Color get error;
  Color get onError;
  Color get errorContainer;
  Color get onErrorContainer;

  /// Success
  Color get success;
  Color get onSuccess;
  Color get successContainer;
  Color get onSuccessContainer;

  /// Warning
  Color get warning;
  Color get onWarning;
  Color get warningContainer;
  Color get onWarningContainer;

  /// Gradient
  LinearGradient get geniusGradient;

  /// Extended Colors
  /// Charts, tags, highlights, and product categories.
  Color get emeraldColor;
  Color get emeraldSurface;
  Color get emeraldContainer;

  Color get darkOliveColor;
  Color get darkOliveSurface;
  Color get darkOliveContainer;

  Color get lightOliveColor;
  Color get lightOliveSurface;
  Color get lightOliveContainer;

  Color get lightBlueColor;
  Color get lightBlueSurface;
  Color get lightBlueContainer;

  Color get aquaColor;
  Color get aquaSurface;
  Color get aquaContainer;

  Color get plumColor;
  Color get plumSurface;
  Color get plumContainer;

  Color get deepRedColor;
  Color get deepRedSurface;
  Color get deepRedContainer;

  Color get brightOrangeColor;
  Color get brightOrangeSurface;
  Color get brightOrangeContainer;

  Color get orangeColor;
  Color get orangeSurface;
  Color get orangeContainer;

  Color get mustardColor;
  Color get mustardSurface;
  Color get mustardContainer;

  Color get pinkColor;
  Color get pinkSurface;
  Color get pinkContainer;
}

class LightThemeColors extends AppColors {
  @override
  AppColors copyWith() => LightThemeColors();

  @override
  AppColors lerp(AppColors? other, double t) => t < 0.5 ? this : other ?? this;

  @override
  Brightness get brightness => Brightness.light;

  /// Primary
  @override
  Color get primary => const Color(0xFF6D92F5);
  @override
  Color get onPrimary => const Color(0xFFFFFFFF);
  @override
  Color get primaryContainer => const Color(0xFFF3F6FF);
  @override
  Color get onPrimaryContainer => const Color(0xFF020F30);
  @override
  Color get primarySurface => const Color(0xFFE2E8F9);
  @override
  Color get primaryStrong => const Color(0xFF2C64F1);

  /// Surface
  @override
  Color get surface => const Color(0xFFF7F6F7);
  @override
  Color get surfaceVariant => const Color(0xFFFFFFFF);
  @override
  Color get surfaceContainer => const Color(0xFFF0F1F1);
  @override
  Color get surfaceContainerHigh => const Color(0xFFC6C6C7);
  @override
  Color get surfaceContainerHighest => const Color(0xFFAAABAB);
  @override
  Color get onSurface => const Color(0xFF1A1C1C);
  @override
  Color get onSurfaceVariant => const Color(0xFF5D5F5F);
  @override
  Color get onSurfaceMuted => const Color(0xFF909191);
  @override
  Color get onSurfaceDisabled => const Color(0xFFAAABAB);
  @override
  Color get inverseSurface => const Color(0xFF6D92F5);
  @override
  Color get onInverseSurface => const Color(0xFFFFFFFF);

  /// Outline
  @override
  Color get outline => const Color(0xFFF0F1F1);
  @override
  Color get outlineVariant => const Color(0xFFE2E2E2);
  @override
  Color get outlineStrong => const Color(0xFFAAABAB);

  /// Error
  @override
  Color get error => const Color(0xFFFF5446);
  @override
  Color get onError => const Color(0xFFFFFFFF);
  @override
  Color get errorContainer => const Color(0xFFFFDAD5);
  @override
  Color get onErrorContainer => const Color(0xFFB8201B);

  /// Success
  @override
  Color get success => const Color(0xFF00A65F);
  @override
  Color get onSuccess => const Color(0xFFFFFFFF);
  @override
  Color get successContainer => const Color(0xFFC2FFD1);
  @override
  Color get onSuccessContainer => const Color(0xFF006D3C);

  /// Warning
  @override
  Color get warning => const Color(0xFFF69426);
  @override
  Color get onWarning => const Color(0xFFFFFFFF);
  @override
  Color get warningContainer => const Color(0xFFFFEEE1);
  @override
  Color get onWarningContainer => const Color(0xFF8D4F00);

  /// Gradient
  @override
  LinearGradient get geniusGradient => const LinearGradient(
    colors: [Color(0xFF2461EB), Color(0xFFD4C6FB)],
  );

  /// Extended Colors
  /// Charts, tags, highlights, and product categories.
  @override
  Color get emeraldColor => const Color(0xFF0D3823);
  @override
  Color get emeraldSurface => const Color(0xFF0D3823);
  @override
  Color get emeraldContainer => const Color(0x260D3823);

  @override
  Color get darkOliveColor => const Color(0xFF486731);
  @override
  Color get darkOliveSurface => const Color(0xFF486731);
  @override
  Color get darkOliveContainer => const Color(0x26486731);

  @override
  Color get lightOliveColor => const Color(0xFFC1D112);
  @override
  Color get lightOliveSurface => const Color(0xFFC1D112);
  @override
  Color get lightOliveContainer => const Color(0x26C1D112);

  @override
  Color get lightBlueColor => const Color(0xFF83D1EC);
  @override
  Color get lightBlueSurface => const Color(0xFF83D1EC);
  @override
  Color get lightBlueContainer => const Color(0x2683D1EC);

  @override
  Color get aquaColor => const Color(0xFFAFEEF0);
  @override
  Color get aquaSurface => const Color(0xFFAFEEF0);
  @override
  Color get aquaContainer => const Color(0x26AFEEF0);

  @override
  Color get plumColor => const Color(0xFF9B3C6B);
  @override
  Color get plumSurface => const Color(0xFF9B3C6B);
  @override
  Color get plumContainer => const Color(0x269B3C6B);

  @override
  Color get deepRedColor => const Color(0xFF882003);
  @override
  Color get deepRedSurface => const Color(0xFF882003);
  @override
  Color get deepRedContainer => const Color(0x26882003);

  @override
  Color get brightOrangeColor => const Color(0xFFF6602D);
  @override
  Color get brightOrangeSurface => const Color(0xFFF6602D);
  @override
  Color get brightOrangeContainer => const Color(0x26F6602D);

  @override
  Color get orangeColor => const Color(0xFFFA912A);
  @override
  Color get orangeSurface => const Color(0xFFFA912A);
  @override
  Color get orangeContainer => const Color(0x26FA912A);

  @override
  Color get mustardColor => const Color(0xFFF2C01C);
  @override
  Color get mustardSurface => const Color(0xFFF2C01C);
  @override
  Color get mustardContainer => const Color(0x26F2C01C);

  @override
  Color get pinkColor => const Color(0xFFE98AD4);
  @override
  Color get pinkSurface => const Color(0xFFE98AD4);
  @override
  Color get pinkContainer => const Color(0x26E98AD4);
}
