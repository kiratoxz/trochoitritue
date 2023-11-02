import 'package:kiratoxz_flutter/game/presentation/layout/background_layer_layout.dart';
import 'package:flutter/material.dart';

class BackgroundLayers {
  static List<BackgroundLayerType> types = [
    // BackgroundLayerType.topBgPlanet,
    // BackgroundLayerType.topRightPlanet,
    // BackgroundLayerType.topLeftPlanet,
    BackgroundLayerType.bottomLeftPlanet,
    // BackgroundLayerType.bottomRightPlanet,
  ];

  List<BackgroundLayerLayout> call(BuildContext context) {
    return List.generate(
      types.length,
      (i) => BackgroundLayerLayout(context, type: types[i]),
    );
  }
}
