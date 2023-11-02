import 'dart:convert';
import 'dart:developer';
import 'dart:math' show Random;

import 'package:kiratoxz_flutter/game/models/location.dart';
import 'package:kiratoxz_flutter/game/models/puzzle.dart';
import 'package:kiratoxz_flutter/game/models/score.dart';
import 'package:kiratoxz_flutter/game/models/tile.dart';
import 'package:kiratoxz_flutter/game/services/storage/storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class PuzzleProvider with ChangeNotifier {
  final StorageService storageService;

  PuzzleProvider(this.storageService);

  int n = Puzzle.supportedPuzzleSizes[1];

  void resetPuzzleSize(int size) {
    assert(Puzzle.supportedPuzzleSizes.contains(size));
    n = size;
    movesCount = 0;
    storageService.remove(StorageKey.puzzle);
    generate(forceRefresh: true);
  }

  final Random random = Random();

  late List<Tile> tiles;

  List<Tile> get tilesWithoutWhitespace =>
      tiles.where((tile) => !tile.tileIsWhiteSpace).toList();

  int movesCount = 0;

  bool get hasStarted => movesCount > 0;

  int get correctTilesCount {
    int count = 0;
    for (Tile tile in tiles) {
      if (tile.isAtCorrectLocation && !tile.tileIsWhiteSpace) {
        count++;
      }
    }
    return count;
  }

  Puzzle get puzzle => Puzzle(
        n: n,
        tiles: tiles,
        movesCount: movesCount,
      );

  void handleKeyboardEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final physicalKey = event.data.physicalKey;
      Tile? tile;
      if (physicalKey == PhysicalKeyboardKey.arrowDown) {
        tile = puzzle.tileTopOfWhitespace;
      } else if (physicalKey == PhysicalKeyboardKey.arrowUp) {
        tile = puzzle.tileBottomOfWhitespace;
      } else if (physicalKey == PhysicalKeyboardKey.arrowRight) {
        tile = puzzle.tileLeftOfWhitespace;
      } else if (physicalKey == PhysicalKeyboardKey.arrowLeft) {
        tile = puzzle.tileRightOfWhitespace;
      }

      if (tile != null) {
        swapTilesAndUpdatePuzzle(tile);
      }
    }
  }

  void swapTilesAndUpdatePuzzle(Tile tile) {
    int movedTileIndex = tiles
        .indexWhere((ctile) => ctile.currentLocation == tile.currentLocation);
    int whiteSpaceTileIndex = tiles.indexWhere((tile) => tile.tileIsWhiteSpace);
    Tile movedTile = tiles[movedTileIndex];
    Tile whiteSpaceTile = tiles[whiteSpaceTileIndex];

    tiles[movedTileIndex] = tiles[movedTileIndex]
        .copyWith(currentLocation: whiteSpaceTile.currentLocation);
    tiles[whiteSpaceTileIndex] =
        whiteSpaceTile.copyWith(currentLocation: movedTile.currentLocation);

    if (tiles[movedTileIndex].isAtCorrectLocation) {
      if (puzzle.isSolved) {
        HapticFeedback.vibrate();
        _updateScoresInStorage();
      } else {
        HapticFeedback.mediumImpact();
      }
    }

    movesCount++;
    _updatePuzzleInStorage();
    notifyListeners();
  }

  List<Score> scores = <Score>[];

  static const int maxStorableScores = 10;

  void _updateScoresInStorage() {
    Score newScore = Score(
      movesCount: movesCount,
      puzzleSize: n,
      secondsElapsed: storageService.get(StorageKey.secondsElapsed),
    );
    try {
      List<Score> scores = _getScoresFromStorage();
      if (scores.length == maxStorableScores) {
        scores.removeAt(0);
      }
      scores.add(newScore);
      storageService.set(StorageKey.scores, Score.toJsonList(scores));
      scores = scores;
    } catch (e) {
      storageService.remove(StorageKey.scores);
    }
  }

  List<Score> _getScoresFromStorage() {
    List<Score> storedScores = [];
    try {
      final scores = storageService.get(StorageKey.scores);
      if (scores != null) {
        storedScores = Score.fromJsonList(scores);
      }
    } catch (e) {
      storageService.remove(StorageKey.scores);
    }
    return storedScores;
  }

  Puzzle? _getPuzzleFromStorage() {
    try {
      dynamic puzzle = storageService.get(StorageKey.puzzle);
      return Puzzle.fromJson(json.decode(json.encode(puzzle)));
    } catch (e) {
      storageService.clear();
      return null;
    }
  }

  void _updatePuzzleInStorage() {
    try {
      storageService.set(StorageKey.puzzle, puzzle.toJson());
    } catch (e) {
      log('Error updating puzzle in storage');
      log('$e');
    }
  }

  void generate({bool forceRefresh = false}) {
    if (storageService.has(StorageKey.scores)) {
      scores = _getScoresFromStorage();
    }
    if (storageService.has(StorageKey.puzzle) && !forceRefresh) {
      Puzzle? puzzle = _getPuzzleFromStorage();
      if (puzzle != null) {
        tiles = puzzle.tiles;
        n = puzzle.n;
        movesCount = puzzle.movesCount;
        return;
      }
    }
    movesCount = 0;
    _generateNew();
    _updatePuzzleInStorage();
    notifyListeners();
  }

  void _generateNew() {
    List<Location> tilesCorrectLocations =
        Puzzle.generateTileCorrectLocations(n);
    List<Location> tilesCurrentLocations = List.from(tilesCorrectLocations);

    tiles = Puzzle.getTilesFromLocations(
      correctLocations: tilesCorrectLocations,
      currentLocations: tilesCurrentLocations,
    );

    while (!puzzle.isSolvable() || puzzle.getNumberOfCorrectTiles() != 0) {
      tilesCurrentLocations.shuffle(random);

      tiles = Puzzle.getTilesFromLocations(
        correctLocations: tilesCorrectLocations,
        currentLocations: tilesCurrentLocations,
      );
    }
  }
}
