import 'package:kiratoxz_flutter/game/models/location.dart';
import 'package:kiratoxz_flutter/game/models/tile.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

class Puzzle extends Equatable {
  final int n;
  final List<Tile> tiles;
  final int movesCount;

  const Puzzle({
    required this.n,
    required this.tiles,
    this.movesCount = 0,
  }) : assert(n < 10);

  static List<int> supportedPuzzleSizes = [3, 4, 5, 6];

  Tile get whiteSpaceTile => tiles.firstWhere((tile) => tile.tileIsWhiteSpace);

  bool tileIsMovable(Tile tile) {
    if (tile.tileIsWhiteSpace) {
      return false;
    }
    return tile.currentLocation.isLocatedAround(whiteSpaceTile.currentLocation);
  }

  bool tileIsLeftOfWhiteSpace(Tile tile) {
    return tile.currentLocation.isLeftOf(whiteSpaceTile.currentLocation);
  }

  bool tileIsRightOfWhiteSpace(Tile tile) {
    return tile.currentLocation.isRightOf(whiteSpaceTile.currentLocation);
  }

  bool tileIsTopOfWhiteSpace(Tile tile) {
    return tile.currentLocation.isTopOf(whiteSpaceTile.currentLocation);
  }

  bool tileIsBottomOfWhiteSpace(Tile tile) {
    return tile.currentLocation.isBottomOf(whiteSpaceTile.currentLocation);
  }

  Tile? get tileTopOfWhitespace =>
      tiles.firstWhereOrNull((tile) => tileIsTopOfWhiteSpace(tile));

  Tile? get tileBottomOfWhitespace =>
      tiles.firstWhereOrNull((tile) => tileIsBottomOfWhiteSpace(tile));

  /// Returns the tile at the right of the whitespace tile
  Tile? get tileRightOfWhitespace =>
      tiles.firstWhereOrNull((tile) => tileIsRightOfWhiteSpace(tile));

  Tile? get tileLeftOfWhitespace =>
      tiles.firstWhereOrNull((tile) => tileIsLeftOfWhiteSpace(tile));

  static List<Location> generateTileCorrectLocations(int n) {
    List<Location> tilesCorrectLocations = [];
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        Location location = Location(y: i + 1, x: j + 1);
        tilesCorrectLocations.add(location);
      }
    }
    return tilesCorrectLocations;
  }

  static List<Tile> getTilesFromLocations({
    required List<Location> correctLocations,
    required List<Location> currentLocations,
  }) {
    return List.generate(
      correctLocations.length,
      (i) => Tile(
        value: i + 1,
        correctLocation: correctLocations[i],
        currentLocation: currentLocations[i],
        tileIsWhiteSpace: i == correctLocations.length - 1,
      ),
    );
  }

  bool _isInversion(Tile a, Tile b) {
    if (!b.tileIsWhiteSpace && a.value != b.value) {
      if (b.value < a.value) {
        return b.currentLocation.compareTo(a.currentLocation) > 0;
      } else {
        return a.currentLocation.compareTo(b.currentLocation) > 0;
      }
    }
    return false;
  }

  int countInversions() {
    var count = 0;
    for (var a = 0; a < tiles.length; a++) {
      final tileA = tiles[a];
      if (tileA.tileIsWhiteSpace) {
        continue;
      }

      for (var b = a + 1; b < tiles.length; b++) {
        final tileB = tiles[b];
        if (_isInversion(tileA, tileB)) {
          count++;
        }
      }
    }
    return count;
  }

  bool isSolvable() {
    final height = tiles.length ~/ n;
    assert(
      n * height == tiles.length,
      'tiles must be equal to n * height',
    );
    final inversions = countInversions();

    if (n.isOdd) {
      return inversions.isEven;
    }

    final whitespace = tiles.singleWhere((tile) => tile.tileIsWhiteSpace);
    final whitespaceRow = whitespace.currentLocation.y;

    if (((height - whitespaceRow) + 1).isOdd) {
      return inversions.isEven;
    } else {
      return inversions.isOdd;
    }
  }

  bool get isSolved => getNumberOfCorrectTiles() == tiles.length - 1;

  int getNumberOfCorrectTiles() {
    var numberOfCorrectTiles = 0;
    for (final tile in tiles) {
      if (!tile.tileIsWhiteSpace) {
        if (tile.currentLocation == tile.correctLocation) {
          numberOfCorrectTiles++;
        }
      }
    }
    return numberOfCorrectTiles;
  }

  factory Puzzle.fromJson(Map<String, dynamic> json) {
    return Puzzle(
      tiles: List<Tile>.from(json['tiles'].map((x) => Tile.fromJson(x))),
      movesCount: json['movesCount'] ?? 0,
      n: json['n'],
    );
  }

  Map<String, dynamic> toJson() => {
        'tiles': List<dynamic>.from(tiles.map((x) => x.toJson())),
        'movesCount': movesCount,
        'n': n,
      };

  @override
  List<Object?> get props => [n, movesCount, tiles];
}
