// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// Directory path: assets/images/intro
  $AssetsImagesIntroGen get intro => const $AssetsImagesIntroGen();

  /// Directory path: assets/images/onboarding
  $AssetsImagesOnboardingGen get onboarding =>
      const $AssetsImagesOnboardingGen();
}

class $AssetsImagesIntroGen {
  const $AssetsImagesIntroGen();

  /// File path: assets/images/intro/circles.svg
  String get circles => 'assets/images/intro/circles.svg';

  /// File path: assets/images/intro/softstar.svg
  String get softstar => 'assets/images/intro/softstar.svg';

  /// File path: assets/images/intro/softstargradient.svg
  String get softstargradient => 'assets/images/intro/softstargradient.svg';

  /// File path: assets/images/intro/star6.svg
  String get star6 => 'assets/images/intro/star6.svg';

  /// File path: assets/images/intro/star7.svg
  String get star7 => 'assets/images/intro/star7.svg';

  /// File path: assets/images/intro/star8.svg
  String get star8 => 'assets/images/intro/star8.svg';

  /// File path: assets/images/intro/star9.svg
  String get star9 => 'assets/images/intro/star9.svg';

  /// File path: assets/images/intro/waveline1.svg
  String get waveline1 => 'assets/images/intro/waveline1.svg';

  /// File path: assets/images/intro/waveline2.svg
  String get waveline2 => 'assets/images/intro/waveline2.svg';

  /// File path: assets/images/intro/waveline3.svg
  String get waveline3 => 'assets/images/intro/waveline3.svg';

  /// List of all assets
  List<String> get values => [
    circles,
    softstar,
    softstargradient,
    star6,
    star7,
    star8,
    star9,
    waveline1,
    waveline2,
    waveline3,
  ];
}

class $AssetsImagesOnboardingGen {
  const $AssetsImagesOnboardingGen();

  /// File path: assets/images/onboarding/StarBegginer.png
  AssetGenImage get starBegginer =>
      const AssetGenImage('assets/images/onboarding/StarBegginer.png');

  /// File path: assets/images/onboarding/StarOptimizer.png
  AssetGenImage get starOptimizer =>
      const AssetGenImage('assets/images/onboarding/StarOptimizer.png');

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
  List<AssetGenImage> get values => [
    starBegginer,
    starOptimizer,
    checkedOption,
    editPencil,
    rightArrow,
  ];
}

class Assets {
  const Assets._();

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
