import 'package:equatable/equatable.dart';

class Location extends Equatable implements Comparable<Location> {
  final int x;
  final int y;

  const Location({
    required this.x,
    required this.y,
  });

  bool isLocatedAround(Location location) {
    return isLeftOf(location) ||
        isRightOf(location) ||
        isBottomOf(location) ||
        isTopOf(location);
  }

  bool isLeftOf(Location location) {
    return location.y == y && location.x == x + 1;
  }

  bool isRightOf(Location location) {
    return location.y == y && location.x == x - 1;
  }

  bool isTopOf(Location location) {
    return location.x == x && location.y == y + 1;
  }

  bool isBottomOf(Location location) {
    return location.x == x && location.y == y - 1;
  }

  @override
  String toString() => '($y, $x)';

  @override
  int compareTo(Location other) {
    if (y < other.y) {
      return -1;
    } else if (y > other.y) {
      return 1;
    } else {
      if (x < other.x) {
        return -1;
      } else if (x > other.x) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  @override
  List<Object> get props => [x, y];

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      x: json['x'],
      y: json['y'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }
}
