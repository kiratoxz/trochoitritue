class DurationHelper {
  static String twoDigits(int n) => n.toString().padLeft(2, '0');

  static String toFormattedTime(Duration duration) {
    final String minutes = twoDigits(duration.inMinutes.remainder(60));
    final String seconds = twoDigits(duration.inSeconds.remainder(60));

    return '$minutes:$seconds';
  }
}
