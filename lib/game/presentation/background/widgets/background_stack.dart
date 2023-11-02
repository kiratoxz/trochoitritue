import 'package:kiratoxz_flutter/game/presentation/background/utils/background_layers.dart';
import 'package:kiratoxz_flutter/game/presentation/background/widgets/animated_background_layer.dart';
import 'package:kiratoxz_flutter/game/presentation/background/widgets/stars.dart';
import 'package:kiratoxz_flutter/game/presentation/layout/background_layer_layout.dart';
import 'package:flutter/material.dart';
import 'package:kiratoxz_flutter/gen/assets.gen.dart';

class BackgroundStack extends StatelessWidget {
  const BackgroundStack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    List<BackgroundLayerLayout> backgroundLayers = BackgroundLayers()(context);

    return Positioned.fill(
      child: Container(
        height: screenSize.height,
        width: screenSize.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.images.background.newYear.path),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: Stars()),
            ...List.generate(
              backgroundLayers.length,
              (i) => AnimatedBackgroundLayer(layer: backgroundLayers[i]),
            ),
          ],
        ),
      ),
    );
  }
}
