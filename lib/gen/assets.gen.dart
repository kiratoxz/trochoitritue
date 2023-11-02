/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  $AssetsImagesBackgroundGen get background =>
      const $AssetsImagesBackgroundGen();
  $AssetsImagesPuzzleSolvedGen get puzzleSolved =>
      const $AssetsImagesPuzzleSolvedGen();
}

class $AssetsLogoGen {
  const $AssetsLogoGen();

  /// File path: assets/logo/logo.jpg
  AssetGenImage get logo => const AssetGenImage('assets/logo/logo.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [logo];
}

class $AssetsImagesBackgroundGen {
  const $AssetsImagesBackgroundGen();

  /// File path: assets/images/background/bottomBgPlanet.png
  AssetGenImage get bottomBgPlanet =>
      const AssetGenImage('assets/images/background/bottomBgPlanet.png');

  /// File path: assets/images/background/bottomLeftPlanet.png
  AssetGenImage get bottomLeftPlanet =>
      const AssetGenImage('assets/images/background/bottomLeftPlanet.png');

  /// File path: assets/images/background/bottomRightPlanet.png
  AssetGenImage get bottomRightPlanet =>
      const AssetGenImage('assets/images/background/bottomRightPlanet.png');

  /// File path: assets/images/background/meothantai.png
  AssetGenImage get meothantai =>
      const AssetGenImage('assets/images/background/meothantai.png');

  /// File path: assets/images/background/new_year.jpg
  AssetGenImage get newYear =>
      const AssetGenImage('assets/images/background/new_year.jpg');

  /// File path: assets/images/background/topBgPlanet.png
  AssetGenImage get topBgPlanet =>
      const AssetGenImage('assets/images/background/topBgPlanet.png');

  /// File path: assets/images/background/topLeftPlanet.png
  AssetGenImage get topLeftPlanet =>
      const AssetGenImage('assets/images/background/topLeftPlanet.png');

  /// File path: assets/images/background/topRightPlanet.png
  AssetGenImage get topRightPlanet =>
      const AssetGenImage('assets/images/background/topRightPlanet.png');

  /// File path: assets/images/background/tuitien.png
  AssetGenImage get tuitien =>
      const AssetGenImage('assets/images/background/tuitien.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        bottomBgPlanet,
        bottomLeftPlanet,
        bottomRightPlanet,
        meothantai,
        newYear,
        topBgPlanet,
        topLeftPlanet,
        topRightPlanet,
        tuitien
      ];
}

class $AssetsImagesPuzzleSolvedGen {
  const $AssetsImagesPuzzleSolvedGen();

  /// File path: assets/images/puzzle-solved/solved-3x3.png
  AssetGenImage get solved3x3 =>
      const AssetGenImage('assets/images/puzzle-solved/solved-3x3.png');

  /// File path: assets/images/puzzle-solved/solved-4x4.png
  AssetGenImage get solved4x4 =>
      const AssetGenImage('assets/images/puzzle-solved/solved-4x4.png');

  /// File path: assets/images/puzzle-solved/solved-5x5.png
  AssetGenImage get solved5x5 =>
      const AssetGenImage('assets/images/puzzle-solved/solved-5x5.png');

  /// File path: assets/images/puzzle-solved/solved-6x6.png
  AssetGenImage get solved6x6 =>
      const AssetGenImage('assets/images/puzzle-solved/solved-6x6.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [solved3x3, solved4x4, solved5x5, solved6x6];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLogoGen logo = $AssetsLogoGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

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
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
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

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
