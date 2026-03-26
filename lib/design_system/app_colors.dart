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

class DarkThemeColors extends AppColors {
  @override
  AppColors copyWith() => DarkThemeColors();

  @override
  AppColors lerp(AppColors? other, double t) => t < 0.5 ? this : other ?? this;

  @override
  Brightness get brightness => Brightness.dark;

  /// Primary
  @override
  Color get primary => const Color(0xFF8EAAF7);
  @override
  Color get onPrimary => const Color(0xFF0A1A3E);
  @override
  Color get primaryContainer => const Color(0xFF1C2D5A);
  @override
  Color get onPrimaryContainer => const Color(0xFFD6E0FF);
  @override
  Color get primarySurface => const Color(0xFF1A2744);
  @override
  Color get primaryStrong => const Color(0xFF5B8AF3);

  /// Surface
  @override
  Color get surface => const Color(0xFF121212);
  @override
  Color get surfaceVariant => const Color(0xFF1E1E1E);
  @override
  Color get surfaceContainer => const Color(0xFF252525);
  @override
  Color get surfaceContainerHigh => const Color(0xFF3A3A3A);
  @override
  Color get surfaceContainerHighest => const Color(0xFF4E4E4E);
  @override
  Color get onSurface => const Color(0xFFE4E4E4);
  @override
  Color get onSurfaceVariant => const Color(0xFFBDBDBD);
  @override
  Color get onSurfaceMuted => const Color(0xFF8A8A8A);
  @override
  Color get onSurfaceDisabled => const Color(0xFF5E5E5E);
  @override
  Color get inverseSurface => const Color(0xFF8EAAF7);
  @override
  Color get onInverseSurface => const Color(0xFF0A1A3E);

  /// Outline
  @override
  Color get outline => const Color(0xFF2E2E2E);
  @override
  Color get outlineVariant => const Color(0xFF3A3A3A);
  @override
  Color get outlineStrong => const Color(0xFF5E5E5E);

  /// Error
  @override
  Color get error => const Color(0xFFFF6B5E);
  @override
  Color get onError => const Color(0xFF3B0907);
  @override
  Color get errorContainer => const Color(0xFF5C1410);
  @override
  Color get onErrorContainer => const Color(0xFFFFDAD5);

  /// Success
  @override
  Color get success => const Color(0xFF33C07F);
  @override
  Color get onSuccess => const Color(0xFF00391D);
  @override
  Color get successContainer => const Color(0xFF004D2B);
  @override
  Color get onSuccessContainer => const Color(0xFFC2FFD1);

  /// Warning
  @override
  Color get warning => const Color(0xFFF8A94E);
  @override
  Color get onWarning => const Color(0xFF3D2200);
  @override
  Color get warningContainer => const Color(0xFF5C3600);
  @override
  Color get onWarningContainer => const Color(0xFFFFEEE1);

  /// Gradient
  @override
  LinearGradient get geniusGradient => const LinearGradient(
    colors: [Color(0xFF5B8AF3), Color(0xFF9E8EE0)],
  );

  /// Extended Colors
  /// Charts, tags, highlights, and product categories.
  @override
  Color get emeraldColor => const Color(0xFF4CAF78);
  @override
  Color get emeraldSurface => const Color(0xFF1A3D2A);
  @override
  Color get emeraldContainer => const Color(0x264CAF78);

  @override
  Color get darkOliveColor => const Color(0xFF7DA05A);
  @override
  Color get darkOliveSurface => const Color(0xFF2A3D1E);
  @override
  Color get darkOliveContainer => const Color(0x267DA05A);

  @override
  Color get lightOliveColor => const Color(0xFFD4E34A);
  @override
  Color get lightOliveSurface => const Color(0xFF3A3D0A);
  @override
  Color get lightOliveContainer => const Color(0x26D4E34A);

  @override
  Color get lightBlueColor => const Color(0xFF9DDEF2);
  @override
  Color get lightBlueSurface => const Color(0xFF1A3640);
  @override
  Color get lightBlueContainer => const Color(0x269DDEF2);

  @override
  Color get aquaColor => const Color(0xFFC5F4F5);
  @override
  Color get aquaSurface => const Color(0xFF1A3A3B);
  @override
  Color get aquaContainer => const Color(0x26C5F4F5);

  @override
  Color get plumColor => const Color(0xFFBB6C93);
  @override
  Color get plumSurface => const Color(0xFF3D1A2D);
  @override
  Color get plumContainer => const Color(0x26BB6C93);

  @override
  Color get deepRedColor => const Color(0xFFBF5A3D);
  @override
  Color get deepRedSurface => const Color(0xFF3D1508);
  @override
  Color get deepRedContainer => const Color(0x26BF5A3D);

  @override
  Color get brightOrangeColor => const Color(0xFFF88A63);
  @override
  Color get brightOrangeSurface => const Color(0xFF3D2014);
  @override
  Color get brightOrangeContainer => const Color(0x26F88A63);

  @override
  Color get orangeColor => const Color(0xFFFBA95A);
  @override
  Color get orangeSurface => const Color(0xFF3D2810);
  @override
  Color get orangeContainer => const Color(0x26FBA95A);

  @override
  Color get mustardColor => const Color(0xFFF5D04A);
  @override
  Color get mustardSurface => const Color(0xFF3D340A);
  @override
  Color get mustardContainer => const Color(0x26F5D04A);

  @override
  Color get pinkColor => const Color(0xFFEFA4DE);
  @override
  Color get pinkSurface => const Color(0xFF3D1A35);
  @override
  Color get pinkContainer => const Color(0x26EFA4DE);
}
