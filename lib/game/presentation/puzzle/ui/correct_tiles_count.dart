import 'package:kiratoxz_flutter/game/presentation/styles/app_text_styles.dart';
import 'package:kiratoxz_flutter/game/providers/puzzle_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CorrectTilesCount extends StatelessWidget {
  const CorrectTilesCount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PuzzleProvider>(
      builder: (c, puzzleProvider, _) => RichText(
        text: TextSpan(
          text: 'Số ô đúng: ',
          style: AppTextStyles.body.copyWith(color: Colors.yellow),
          children: <TextSpan>[
            TextSpan(
              text:
                  '${puzzleProvider.correctTilesCount}/${puzzleProvider.puzzle.tiles.length - 1}',
              style: AppTextStyles.bodyBold.copyWith(color: Colors.yellow),
            ),
          ],
        ),
      ),
    );
  }
}
