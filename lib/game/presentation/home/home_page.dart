import 'package:kiratoxz_flutter/game/presentation/drawer/app_drawer.dart';
import 'package:kiratoxz_flutter/game/presentation/puzzle/puzzle.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: AppDrawer(),
      body: PuzzleView(),
      // body: PuzzleWinView(),
    );
  }
}
