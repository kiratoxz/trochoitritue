import 'package:kiratoxz_flutter/game/models/position.dart';
import 'package:flutter/animation.dart';

class PositionTween extends Tween<Position> {
  PositionTween({Position? begin, Position? end})
      : super(begin: begin, end: end);

  @override
  Position lerp(double t) => Position.lerp(begin, end, t);
}
