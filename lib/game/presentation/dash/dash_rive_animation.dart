import 'package:flutter/foundation.dart';
import 'package:kiratoxz_flutter/game/presentation/presentation.dart';
import 'package:kiratoxz_flutter/game/providers/phrases_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:kiratoxz_flutter/gen/assets.gen.dart';

class DashRiveAnimation extends StatefulWidget {
  const DashRiveAnimation({Key? key}) : super(key: key);

  @override
  DashRiveAnimationState createState() => DashRiveAnimationState();
}

class DashRiveAnimationState extends State<DashRiveAnimation> {
  late final PhrasesProvider phrasesProvider;

  final ValueNotifier<bool> canTapDashNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    phrasesProvider = Provider.of<PhrasesProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DashLayout dash = DashLayout(context);

    return Positioned(
      right: dash.position.right,
      bottom: dash.position.bottom,
      child: ValueListenableBuilder(
        valueListenable: canTapDashNotifier,
        child: SizedBox(
          width: dash.size.width,
          height: dash.size.height,
          child: Assets.images.background.meothantai.image(),
        ),
        builder: (c, bool canTapDash, child) => GestureDetector(
          onTap: () {
            if (canTapDash) {
              canTapDashNotifier.value = false;
              phrasesProvider.setPhraseState(PhraseState.dashTapped);
              HapticFeedback.lightImpact();
              Future.delayed(
                  AnimationsManager.phraseBubbleTotalAnimationDuration, () {
                phrasesProvider.setPhraseState(PhraseState.none);
                canTapDashNotifier.value = true;
              });
            }
            if (kDebugMode) {
              TileGestureDetector.showDemoWiner(context);
            }
          },
          child: child,
        ),
      ),
    );
  }
}
