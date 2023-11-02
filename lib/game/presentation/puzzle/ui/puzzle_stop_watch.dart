import 'package:kiratoxz_flutter/game/helpers/duration_helper.dart';
import 'package:kiratoxz_flutter/game/presentation/styles/app_text_styles.dart';
import 'package:kiratoxz_flutter/game/providers/stop_watch_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PuzzleStopWatch extends StatelessWidget {
  const PuzzleStopWatch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<StopWatchProvider>(
      builder: (c, stopWatchProvider, _) {
        Duration duration = Duration(seconds: stopWatchProvider.secondsElapsed);

        return Text(
          DurationHelper.toFormattedTime(duration),
          style: AppTextStyles.bodyBold,
        );
      },
    );
  }
}
