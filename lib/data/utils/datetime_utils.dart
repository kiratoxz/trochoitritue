import 'package:ntp/ntp.dart';

class DateTimeUtils {
  /// Get timezone offset for request header
  static String getTimezoneOffset() {
    final offsetDuration = DateTime.now().timeZoneOffset;
    var gmtString = "GMT+";
    if (offsetDuration.inHours < 0) {
      gmtString = "GMT";
    }
    final offsetHours = offsetDuration.inHours.toString().padLeft(2, '0');
    final offsetMinutes = (offsetDuration.inMinutes % Duration.minutesPerHour)
        .toString()
        .padLeft(2, '0');
    return "$gmtString$offsetHours:$offsetMinutes";
  }

  // Used to detect if a user has changed their device time
  // There is a 26 hour allowed difference.
  static Future<int> getDeviceAgainstNTPTimeDifference() async {
    DateTime deviceDateTime = DateTime.now().toLocal();
    try {
      return (await NTP.getNtpOffset(localTime: deviceDateTime)).abs();
    } catch (error) {
      return -1;
    }
  }

  static DateTime? fromStringMMYYYY(String time) {
    try {
      final data = time.split('/');
      return DateTime(int.parse(data.last), int.parse(data.first));
    } catch (error) {
      return null;
    }
  }
}
