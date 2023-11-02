import 'package:kiratoxz_flutter/game/presentation/common/animations/utils/animations_manager.dart';
import 'package:kiratoxz_flutter/game/presentation/common/animations/widgets/fade_in_transition.dart';
import 'package:kiratoxz_flutter/game/presentation/layout/puzzle_layout.dart';
import 'package:kiratoxz_flutter/game/presentation/layout/spacing.dart';
import 'package:kiratoxz_flutter/game/presentation/puzzle/ui/correct_tiles_count.dart';
import 'package:kiratoxz_flutter/game/presentation/puzzle/ui/moves_count.dart';
import 'package:kiratoxz_flutter/game/presentation/puzzle/ui/puzzle_stop_watch.dart';
import 'package:kiratoxz_flutter/game/presentation/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class PuzzleHeader extends StatelessWidget {
  const PuzzleHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PuzzleLayout puzzleLayout = PuzzleLayout(context);

    return FadeInTransition(
      delay: AnimationsManager.bgLayerAnimationDuration,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 4, right: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.yellow.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.yellow, width: 2)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('Số Đỏ', style: AppTextStyles.title),
            const SizedBox(height: 5),
            const Text(
              'Giải trò chơi này',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 8),
            Wrap(
              runSpacing: 5,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: (puzzleLayout.containerWidth / 3) - Spacing.md),
                  child: const PuzzleStopWatch(),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: (puzzleLayout.containerWidth / 3) - Spacing.md),
                  child: const MovesCount(),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: (puzzleLayout.containerWidth / 3) - Spacing.md),
                  child: const CorrectTilesCount(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
