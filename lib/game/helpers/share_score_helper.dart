import 'package:kiratoxz_flutter/game/helpers/duration_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareScoreHelper {
  static const String officialWebsiteUrl = 'https://t.me/kiratoxz';

  static const String puzzleSolvedImagesUrlRoot =
      '$officialWebsiteUrl/images/puzzle-solved';

  static const String twitterIntentUrl = 'https://twitter.com/intent/tweet';

  static String getPuzzleSolvedImageUrl(int size) {
    return '$puzzleSolvedImagesUrlRoot/solved-${size}x$size.png';
  }

  static Future<void> openLink(String url, {VoidCallback? onError}) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (onError != null) {
      onError();
    }
  }

  static String getPuzzleSolvedText(
      int movesCount, Duration duration, int tilesCount) {
    return 'Tôi đã giải câu đó này $tilesCount-ô chữ của trò chơi Số Đỏ trong ${DurationHelper.toFormattedTime(duration)} với $movesCount bước!';
  }

  static String getPuzzleSolvedTextMobile(
      int movesCount, Duration duration, int tilesCount) {
    return '${getPuzzleSolvedText(movesCount, duration, tilesCount)} \n\n$officialWebsiteUrl';
  }

  static String getTwitterShareLink(
      int movesCount, Duration duration, int tilesCount) {
    return '$twitterIntentUrl?text=${getPuzzleSolvedText(movesCount, duration, tilesCount)}&url=$officialWebsiteUrl';
  }
}
