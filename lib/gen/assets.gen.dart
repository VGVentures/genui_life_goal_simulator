// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// Directory path: assets/images/intro
  $AssetsImagesIntroGen get intro => const $AssetsImagesIntroGen();

  /// Directory path: assets/images/onboarding
  $AssetsImagesOnboardingGen get onboarding =>
      const $AssetsImagesOnboardingGen();

  /// Directory path: assets/images/sparkline_cards
  $AssetsImagesSparklineCardsGen get sparklineCards =>
      const $AssetsImagesSparklineCardsGen();
}

class $AssetsImagesIntroGen {
  const $AssetsImagesIntroGen();

  /// File path: assets/images/intro/circles.svg
  SvgGenImage get circles =>
      const SvgGenImage('assets/images/intro/circles.svg');

  /// File path: assets/images/intro/softstar.svg
  SvgGenImage get softstar =>
      const SvgGenImage('assets/images/intro/softstar.svg');

  /// File path: assets/images/intro/softstargradient.svg
  SvgGenImage get softstargradient =>
      const SvgGenImage('assets/images/intro/softstargradient.svg');

  /// File path: assets/images/intro/star6.svg
  SvgGenImage get star6 => const SvgGenImage('assets/images/intro/star6.svg');

  /// File path: assets/images/intro/star7.svg
  SvgGenImage get star7 => const SvgGenImage('assets/images/intro/star7.svg');

  /// File path: assets/images/intro/star8.svg
  SvgGenImage get star8 => const SvgGenImage('assets/images/intro/star8.svg');

  /// File path: assets/images/intro/star9.svg
  SvgGenImage get star9 => const SvgGenImage('assets/images/intro/star9.svg');

  /// File path: assets/images/intro/waveline1.svg
  SvgGenImage get waveline1 =>
      const SvgGenImage('assets/images/intro/waveline1.svg');

  /// File path: assets/images/intro/waveline2.svg
  SvgGenImage get waveline2 =>
      const SvgGenImage('assets/images/intro/waveline2.svg');

  /// File path: assets/images/intro/waveline3.svg
  SvgGenImage get waveline3 =>
      const SvgGenImage('assets/images/intro/waveline3.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
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

class $AssetsImagesSparklineCardsGen {
  const $AssetsImagesSparklineCardsGen();

  /// File path: assets/images/sparkline_cards/negative_line.svg
  SvgGenImage get negativeLine =>
      const SvgGenImage('assets/images/sparkline_cards/negative_line.svg');

  /// File path: assets/images/sparkline_cards/positive_line.svg
  SvgGenImage get positiveLine =>
      const SvgGenImage('assets/images/sparkline_cards/positive_line.svg');

  /// File path: assets/images/sparkline_cards/stable_line.svg
  SvgGenImage get stableLine =>
      const SvgGenImage('assets/images/sparkline_cards/stable_line.svg');

  /// List of all assets
  List<SvgGenImage> get values => [negativeLine, positiveLine, stableLine];
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

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
