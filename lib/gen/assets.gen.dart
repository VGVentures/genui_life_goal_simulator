// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsKickOffGen {
  const $AssetsIconsKickOffGen();

  /// File path: assets/icons_kick_off/Ellipse 139.png
  AssetGenImage get ellipse139 =>
      const AssetGenImage('assets/icons_kick_off/Ellipse 139.png');

  /// File path: assets/icons_kick_off/Soft Star.png
  AssetGenImage get softStar =>
      const AssetGenImage('assets/icons_kick_off/Soft Star.png');

  /// File path: assets/icons_kick_off/Star 10.png
  AssetGenImage get star10 =>
      const AssetGenImage('assets/icons_kick_off/Star 10.png');

  /// File path: assets/icons_kick_off/Star 11.png
  AssetGenImage get star11 =>
      const AssetGenImage('assets/icons_kick_off/Star 11.png');

  /// File path: assets/icons_kick_off/Star 5.png
  AssetGenImage get star5 =>
      const AssetGenImage('assets/icons_kick_off/Star 5.png');

  /// File path: assets/icons_kick_off/Star 7.png
  AssetGenImage get star7 =>
      const AssetGenImage('assets/icons_kick_off/Star 7.png');

  /// File path: assets/icons_kick_off/Star 9.png
  AssetGenImage get star9 =>
      const AssetGenImage('assets/icons_kick_off/Star 9.png');

  /// File path: assets/icons_kick_off/activity_zone.png
  AssetGenImage get activityZone =>
      const AssetGenImage('assets/icons_kick_off/activity_zone.png');

  /// File path: assets/icons_kick_off/check_icon.png
  AssetGenImage get checkIcon =>
      const AssetGenImage('assets/icons_kick_off/check_icon.png');

  /// File path: assets/icons_kick_off/flare.png
  AssetGenImage get flare =>
      const AssetGenImage('assets/icons_kick_off/flare.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    ellipse139,
    softStar,
    star10,
    star11,
    star5,
    star7,
    star9,
    activityZone,
    checkIcon,
    flare,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// Directory path: assets/images/onboarding
  $AssetsImagesOnboardingGen get onboarding =>
      const $AssetsImagesOnboardingGen();
}

class $AssetsImagesOnboardingGen {
  const $AssetsImagesOnboardingGen();

  /// File path: assets/images/onboarding/checked_option.png
  AssetGenImage get checkedOption =>
      const AssetGenImage('assets/images/onboarding/checked_option.png');

  /// File path: assets/images/onboarding/edit_pencil.png
  AssetGenImage get editPencil =>
      const AssetGenImage('assets/images/onboarding/edit_pencil.png');

  /// File path: assets/images/onboarding/right_arrow.png
  AssetGenImage get rightArrow =>
      const AssetGenImage('assets/images/onboarding/right_arrow.png');

  /// List of all assets
  List<AssetGenImage> get values => [checkedOption, editPencil, rightArrow];
}

class Assets {
  const Assets._();

  static const $AssetsIconsKickOffGen iconsKickOff = $AssetsIconsKickOffGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
