import 'dart:math';

import 'package:kiratoxz_flutter/game/presentation/layout/phrase_bubble_layout.dart';
import 'package:flutter/cupertino.dart';

class PhrasesProvider with ChangeNotifier {
  static const List<String> puzzleStartedPhrases = [
    'Chúc may mắn!',
    'Bạn có thể làm được!',
    'Tôi tin bạn!',
  ];

  static const List<String> doingGreatPhrases = [
    'Cố gắng lên!',
    'Bạn đang làm rất tốt!',
    'Đừng bỏ cuộc nhé!',
  ];

  static const List<String> puzzleSolvedPhrases = [
    'Thật tuyệt vời!',
    'Bạn quá đỉnh!',
    'Đỉnh của chóp!',
  ];

  static const List<String> hardPuzzlePhrases = [
    'Bạn có chắc chắn sẽ làm được không?!',
    'WOW! Thật không dễ dàng!',
    'Dễ quá thì chán lắm 😉',
  ];

  static const List<String> puzzleTakingTooLongPhrases = [
    'Tốn nhiều thời gian nhỉ!',
    'Đừng bỏ lỡ cơ hội cuối',
    'Dù trễ vẫn hơn là không bao giờ',
  ];

  static const List<String> dashTappedPhrases = [
    'Chào bạn, tôi là Kira',
    'Tôi sẽ mang lại may mắn cho bạn',
    'Úng dụng này được xây dựng bởi!',
    'Và tôi là linh vật may mắn',
    'Vì vậy bạn có thể gọi tôi là Mèo Thần Tài 😻',
    'Bạn đừng có nịnh tôi nha 😃',
    'Tại sao bạn không chơi giải đố với tôi???',
    'Bạn đang chọc tức tôi đấy!',
    'Meow! Đừng để ý!',
    'Bạn chắc chắn phải tiếp tục 😒',
    'Tôi có thể nhanh hơn bạn!!',
    'Xin chào, tôi là Kira',
    'Aww Tôi chưa bắt đầu',
    'Bây giờ tôi sẽ...',
    'Xin chào, tôi là Kira',
    'Vẫn không làm ư?',
  ];

  static final Random random = Random();

  static int maxDashTaps = dashTappedPhrases.length - 1;

  int dashTapCount = -1;

  String getPhrase(PhraseState phraseState) {
    assert(phraseState != PhraseState.none);
    switch (phraseState) {
      case PhraseState.puzzleStarted:
        return puzzleStartedPhrases[
            random.nextInt(puzzleSolvedPhrases.length - 1)];
      case PhraseState.puzzleSolved:
        return puzzleSolvedPhrases[
            random.nextInt(puzzleSolvedPhrases.length - 1)];
      case PhraseState.hardPuzzleSelected:
        return hardPuzzlePhrases[random.nextInt(hardPuzzlePhrases.length - 1)];
      case PhraseState.doingGreat:
        return doingGreatPhrases[random.nextInt(doingGreatPhrases.length - 1)];
      case PhraseState.dashTapped:
        return dashTappedPhrases[dashTapCount];
      default:
        return '';
    }
  }

  PhraseState phraseState = PhraseState.none;

  void setPhraseState(PhraseState phraseState) {
    phraseState = phraseState;
    if (phraseState == PhraseState.dashTapped) {
      if (dashTapCount == maxDashTaps) {
        dashTapCount = 0;
      } else {
        dashTapCount++;
      }
    }
    notifyListeners();
  }
}
