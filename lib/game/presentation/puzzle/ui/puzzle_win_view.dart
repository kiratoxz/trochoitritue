import 'package:kiratoxz_flutter/game/presentation/presentation.dart';
import 'package:kiratoxz_flutter/game/providers/puzzle_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kiratoxz_flutter/gen/assets.gen.dart';

class PuzzleWinView extends StatefulWidget {
  const PuzzleWinView({Key? key}) : super(key: key);

  @override
  State<PuzzleWinView> createState() => _PuzzleWinViewState();
}

class _PuzzleWinViewState extends State<PuzzleWinView> {
  late PuzzleProvider puzzleProvider;

  @override
  void initState() {
    puzzleProvider = Provider.of<PuzzleProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.images.background.newYear.path),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Assets.images.background.newYear.image(
                fit: BoxFit.fitWidth,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            const BackgroundStack(),
            // ...puzzleLayout.buildUIElements,
            _buildTitle(),
            Positioned(
              bottom: -30,
              right: -30,
              child: Assets.images.background.meothantai.image(width: 200),
            ),
            Positioned(
              bottom: 24,
              left: 34,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: Text(
                      "Đỉnh của chóp!",
                      style: AppTextStyles.h1Bold.copyWith(color: Colors.black),
                    ),
                  ),
                  Container(
                    width: 16,
                    height: 16,
                    margin: const EdgeInsets.only(left: 4, top: 18),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.9),
                      border: Border.all(color: Colors.black),
                    ),
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(left: 4, top: 12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.9),
                      border: Border.all(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Số Đỏ",
                  style: AppTextStyles.h1Bold,
                ),
                Text(
                  "Câu đố 35 ô đã được giải",
                  style: AppTextStyles.bodySm
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 140.0, left: 16),
              child: Align(
                alignment: Alignment.topLeft,
                child: FittedBox(
                  child: PuzzleBoard(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
