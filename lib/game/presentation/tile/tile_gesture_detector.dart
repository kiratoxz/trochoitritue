import 'package:kiratoxz_flutter/game/models/tile.dart';
import 'package:kiratoxz_flutter/game/presentation/common/animations/utils/animations_manager.dart';
import 'package:kiratoxz_flutter/game/presentation/layout/phrase_bubble_layout.dart';
import 'package:kiratoxz_flutter/game/presentation/puzzle/share-dialog/puzzle_share_dialog.dart';
import 'package:kiratoxz_flutter/game/providers/phrases_provider.dart';
import 'package:kiratoxz_flutter/game/providers/puzzle_provider.dart';
import 'package:kiratoxz_flutter/game/providers/stop_watch_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TileGestureDetector extends StatelessWidget {
  final Tile tile;
  final Widget tileContent;

  const TileGestureDetector({
    Key? key,
    required this.tile,
    required this.tileContent,
  }) : super(key: key);

  Future<void> _showPuzzleSolvedDialog(
    BuildContext context,
    PuzzleProvider puzzleProvider,
    int secondsElapsed,
  ) async {
    await showDialog(
      context: context,
      builder: (c) {
        return PuzzleSolvedDialog(
          puzzleSize: puzzleProvider.n,
          movesCount: puzzleProvider.movesCount,
          solvingDuration: Duration(seconds: secondsElapsed),
        );
      },
    );
  }

  static Future<void> showDemoWiner(
    BuildContext context, {
    int puzzleSize = 3,
    int moves = 68,
    int duration = 79,
  }) async {
    await showDialog(
      context: context,
      builder: (c) {
        return PuzzleSolvedDialog(
          puzzleSize: puzzleSize,
          movesCount: moves,
          solvingDuration: Duration(seconds: duration),
        );
      },
    );
  }

  void _swapTilesAndUpdatePuzzle(
    BuildContext context,
    PuzzleProvider puzzleProvider,
    StopWatchProvider stopWatchProvider,
    PhrasesProvider phrasesProvider,
  ) {
    puzzleProvider.swapTilesAndUpdatePuzzle(tile);

    // Handle Phrases
    if (puzzleProvider.movesCount == 1) {
      stopWatchProvider.start();
      phrasesProvider.setPhraseState(PhraseState.puzzleStarted);
    } else if (puzzleProvider.puzzle.isSolved) {
      phrasesProvider.setPhraseState(PhraseState.puzzleSolved);
      Future.delayed(AnimationsManager.phraseBubbleTotalAnimationDuration, () {
        phrasesProvider.setPhraseState(PhraseState.none);
      });

      Future.delayed(AnimationsManager.puzzleSolvedDialogDelay, () {
        int secondsElapsed = stopWatchProvider.secondsElapsed;
        stopWatchProvider.stop();
        _showPuzzleSolvedDialog(
          context,
          puzzleProvider,
          secondsElapsed,
        ).then((_) {
          puzzleProvider.generate(forceRefresh: true);
        });
      });
    } else {
      if (phrasesProvider.phraseState != PhraseState.none) {
        if (phrasesProvider.phraseState == PhraseState.puzzleStarted ||
            phrasesProvider.phraseState == PhraseState.dashTapped ||
            phrasesProvider.phraseState == PhraseState.puzzleSolved) {
          Future.delayed(AnimationsManager.phraseBubbleTotalAnimationDuration,
              () {
            phrasesProvider.setPhraseState(PhraseState.none);
          });
        } else {
          phrasesProvider.setPhraseState(PhraseState.none);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    PuzzleProvider puzzleProvider =
        Provider.of<PuzzleProvider>(context, listen: false);
    StopWatchProvider stopWatchProvider =
        Provider.of<StopWatchProvider>(context, listen: false);
    PhrasesProvider phrasesProvider =
        Provider.of<PhrasesProvider>(context, listen: false);

    return IgnorePointer(
      ignoring: tile.tileIsWhiteSpace || puzzleProvider.puzzle.isSolved,
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          bool canMoveRight = details.velocity.pixelsPerSecond.dx >= 0 &&
              puzzleProvider.puzzle.tileIsLeftOfWhiteSpace(tile);
          bool canMoveLeft = details.velocity.pixelsPerSecond.dx <= 0 &&
              puzzleProvider.puzzle.tileIsRightOfWhiteSpace(tile);
          bool tileIsMovable = puzzleProvider.puzzle.tileIsMovable(tile);
          if (tileIsMovable && (canMoveLeft || canMoveRight)) {
            _swapTilesAndUpdatePuzzle(
                context, puzzleProvider, stopWatchProvider, phrasesProvider);
          }
        },
        onVerticalDragEnd: (details) {
          bool canMoveUp = details.velocity.pixelsPerSecond.dy <= 0 &&
              puzzleProvider.puzzle.tileIsBottomOfWhiteSpace(tile);
          bool canMoveDown = details.velocity.pixelsPerSecond.dy >= 0 &&
              puzzleProvider.puzzle.tileIsTopOfWhiteSpace(tile);
          bool tileIsMovable = puzzleProvider.puzzle.tileIsMovable(tile);
          if (tileIsMovable && (canMoveUp || canMoveDown)) {
            _swapTilesAndUpdatePuzzle(
                context, puzzleProvider, stopWatchProvider, phrasesProvider);
          }
        },
        onTap: () {
          bool tileIsMovable = puzzleProvider.puzzle.tileIsMovable(tile);
          if (tileIsMovable) {
            _swapTilesAndUpdatePuzzle(
                context, puzzleProvider, stopWatchProvider, phrasesProvider);
          }
        },
        child: tileContent,
      ),
    );
  }
}
