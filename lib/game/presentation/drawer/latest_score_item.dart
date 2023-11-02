import 'package:kiratoxz_flutter/game/helpers/duration_helper.dart';
import 'package:kiratoxz_flutter/game/models/score.dart';
import 'package:kiratoxz_flutter/game/presentation/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'package:kiratoxz_flutter/game/presentation/styles/style.dart';

class LatestScoreItem extends StatelessWidget {
  final Score score;

  const LatestScoreItem(this.score, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).padding.left == 0
            ? Spacing.md
            : MediaQuery.of(context).padding.left,
        right: Spacing.screenHPadding,
        top: Spacing.sm,
        bottom: Spacing.sm,
      ),
      decoration: BoxDecoration(
        border: Border(
            bottom:
                BorderSide(color: Colors.yellow.withOpacity(0.5), width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${score.puzzleSize}x${score.puzzleSize}',
              style: AppTextStyles.body,
            ),
          ),
          Expanded(
            child: Text(
              DurationHelper.toFormattedTime(
                Duration(seconds: score.secondsElapsed),
              ),
              style: AppTextStyles.body,
            ),
          ),
          Expanded(
            child: Text(
              '${score.movesCount} bước',
              style: AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }
}
