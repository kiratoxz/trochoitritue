import 'package:kiratoxz_flutter/game/presentation/styles/app_text_styles.dart';
import 'package:kiratoxz_flutter/game/providers/puzzle_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovesCount extends StatelessWidget {
  const MovesCount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PuzzleProvider, int>(
      selector: (c, puzzleProvider) => puzzleProvider.movesCount,
      builder: (c, int movesCount, _) => RichText(
        text: TextSpan(
          text: 'Bước: ',
          style: AppTextStyles.body.copyWith(color: Colors.yellow),
          children: <TextSpan>[
            TextSpan(
              text: '$movesCount',
              style: AppTextStyles.bodyBold.copyWith(color: Colors.yellow),
            ),
          ],
        ),
      ),
    );
  }
}
