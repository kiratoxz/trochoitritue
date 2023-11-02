import 'package:kiratoxz_flutter/game/models/tile.dart';
import 'package:kiratoxz_flutter/game/presentation/common/animations/utils/animations_manager.dart';
import 'package:kiratoxz_flutter/game/presentation/layout/puzzle_layout.dart';
import 'package:kiratoxz_flutter/game/presentation/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class TileContent extends StatefulWidget {
  final Tile tile;
  final bool isPuzzleSolved;
  final int puzzleSize;

  const TileContent({
    Key? key,
    required this.tile,
    required this.isPuzzleSolved,
    required this.puzzleSize,
  }) : super(key: key);

  @override
  State<TileContent> createState() => _TileContentState();
}

class _TileContentState extends State<TileContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late Animation<double> _scale;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: AnimationsManager.tileHover.duration,
    );

    _scale = AnimationsManager.tileHover.tween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AnimationsManager.tileHover.curve,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isCorrect =
        widget.tile.currentLocation == widget.tile.correctLocation;
    return MouseRegion(
      onEnter: (_) {
        if (!widget.isPuzzleSolved) {
          _animationController.forward();
        }
      },
      onExit: (_) {
        if (!widget.isPuzzleSolved) {
          _animationController.reverse();
        }
      },
      child: ScaleTransition(
        scale: _scale,
        child: Padding(
          padding: EdgeInsets.all(
              widget.puzzleSize > 4 ? 2 : PuzzleLayout.tilePadding),
          child: Stack(
            children: [
              // TileRiveAnimation(
              //   isAtCorrectLocation:
              //       widget.tile.currentLocation == widget.tile.correctLocation,
              //   isPuzzleSolved: widget.isPuzzleSolved,
              // ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: isCorrect
                        ? Colors.white.withOpacity(0.2)
                        : Colors.yellow.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCorrect
                          ? Colors.white.withOpacity(0.6)
                          : Colors.yellow.withOpacity(0.6),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${widget.tile.value}',
                      style: AppTextStyles.tile.copyWith(
                        color: isCorrect ? Colors.white : Colors.yellow,
                        fontSize: PuzzleLayout.tileTextSize(widget.puzzleSize),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
