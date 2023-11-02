import 'package:kiratoxz_flutter/game/models/score.dart';
import 'package:kiratoxz_flutter/game/presentation/drawer/latest_score_item.dart';
import 'package:kiratoxz_flutter/game/presentation/layout/spacing.dart';
import 'package:kiratoxz_flutter/game/presentation/styles/app_text_styles.dart';
import 'package:kiratoxz_flutter/game/providers/puzzle_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LatestScores extends StatelessWidget {
  const LatestScores({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PuzzleProvider, List<Score>>(
      selector: (c, puzzleProvider) => puzzleProvider.scores.reversed.toList(),
      builder: (c, List<Score> scores, child) => Container(
        padding: const EdgeInsets.symmetric(vertical: Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).padding.left == 0
                    ? Spacing.md
                    : MediaQuery.of(context).padding.left,
                right: Spacing.screenHPadding,
                bottom: Spacing.xs,
              ),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: Colors.yellow.withOpacity(0.5), width: 0.5)),
              ),
              child: Text(
                'Điểm số',
                style:
                    AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            if (scores.isEmpty)
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).padding.left == 0
                      ? Spacing.md
                      : MediaQuery.of(context).padding.left,
                  right: Spacing.screenHPadding,
                  top: Spacing.xs,
                  bottom: Spacing.xs,
                ),
                child: const Text(
                  'Giải những câu đó khó và bạn sẽ thấy điểm số của mình ở đây! Tôi tin bạn!',
                  style: AppTextStyles.bodySm,
                ),
              ),
            ...List.generate(scores.length, (i) => LatestScoreItem(scores[i])),
          ],
        ),
      ),
    );
  }
}
