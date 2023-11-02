import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:kiratoxz_flutter/game/helpers/duration_helper.dart';
import 'package:kiratoxz_flutter/game/helpers/file_helper.dart';
import 'package:kiratoxz_flutter/game/helpers/share_score_helper.dart';
import 'package:kiratoxz_flutter/game/presentation/layout/spacing.dart';
import 'package:kiratoxz_flutter/game/presentation/styles/app_text_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

class PuzzleScore extends StatelessWidget {
  final Duration duration;
  final int movesCount;
  final int puzzleSize;

  const PuzzleScore({
    Key? key,
    required this.duration,
    required this.movesCount,
    required this.puzzleSize,
  }) : super(key: key);

  int get tilesCount => (puzzleSize * puzzleSize) - 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chúc mừng! Bạn đã thành công!',
              style: AppTextStyles.title,
            ),
            const SizedBox(height: Spacing.xs),
            const Text(
              'Bạn đã giải xong câu đố này! Chia sẻ ngay cho bạn bè để họ cùng chơi với bạn',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: Spacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.watch_later_outlined,
                        color: Colors.yellow,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        DurationHelper.toFormattedTime(duration),
                        style: AppTextStyles.h1Bold,
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child:
                        Text('$movesCount bước', style: AppTextStyles.h1Bold)),
              ],
            ),
            const SizedBox(height: Spacing.md),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                label: const Text(
                  'Chơi lại',
                  style: AppTextStyles.bodySm,
                ),
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.yellow,
                ),
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    if (kIsWeb) {
                      await ShareScoreHelper.openLink(
                          ShareScoreHelper.getTwitterShareLink(
                              movesCount, duration, tilesCount));
                    } else {
                      File file = await FileHelper.getFileFromUrl(
                          ShareScoreHelper.getPuzzleSolvedImageUrl(puzzleSize));
                      await Share.shareXFiles(
                        [XFile(file.path)],
                        text: ShareScoreHelper.getPuzzleSolvedTextMobile(
                            movesCount, duration, tilesCount),
                      );
                    }
                  } catch (e) {
                    await ShareScoreHelper.openLink(
                        ShareScoreHelper.getTwitterShareLink(
                            movesCount, duration, tilesCount));
                    rethrow;
                  }
                },
                label: const Text(
                  'Share',
                  style: AppTextStyles.bodySm,
                ),
                icon: kIsWeb
                    ? const Icon(FontAwesomeIcons.twitter)
                    : const Icon(
                        Icons.share,
                        color: Colors.yellow,
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
