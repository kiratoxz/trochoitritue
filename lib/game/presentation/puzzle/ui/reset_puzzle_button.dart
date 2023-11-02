import 'package:kiratoxz_flutter/game/presentation/common/animations/utils/animations_manager.dart';
import 'package:kiratoxz_flutter/game/presentation/common/animations/widgets/fade_in_transition.dart';
import 'package:kiratoxz_flutter/game/presentation/common/dialogs/app_alert_dialog.dart';
import 'package:kiratoxz_flutter/game/presentation/styles/app_text_styles.dart';
import 'package:kiratoxz_flutter/game/providers/puzzle_provider.dart';
import 'package:kiratoxz_flutter/game/providers/stop_watch_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPuzzleButton extends StatelessWidget {
  const ResetPuzzleButton({Key? key}) : super(key: key);

  void initResetPuzzle(
    BuildContext context,
    PuzzleProvider puzzleProvider,
    StopWatchProvider stopWatchProvider,
  ) {
    if (puzzleProvider.hasStarted && !puzzleProvider.puzzle.isSolved) {
      showDialog(
        context: context,
        builder: (context) {
          return AppAlertDialog(
            title: 'Are you sure you want to reset your puzzle?',
            onConfirm: () {
              stopWatchProvider.stop();
              puzzleProvider.generate(forceRefresh: true);
            },
          );
        },
      );
    } else {
      stopWatchProvider.stop();
      puzzleProvider.generate(forceRefresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    StopWatchProvider stopWatchProvider =
        Provider.of<StopWatchProvider>(context, listen: false);

    return FadeInTransition(
      delay: AnimationsManager.bgLayerAnimationDuration,
      child: Consumer<PuzzleProvider>(
        builder: (c, puzzleProvider, _) => Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ElevatedButton(
            onPressed: () =>
                initResetPuzzle(context, puzzleProvider, stopWatchProvider),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.refresh,
                  color: Colors.yellow,
                ),
                SizedBox(width: 7),
                Text('Làm mới', style: AppTextStyles.button),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
