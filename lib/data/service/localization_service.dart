import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';

import 'support_locale.dart';

String _defaultLanguageCode = SupportLocale.vi;

class LocalizationService {
  static final LocalizationService _singleton = LocalizationService._internal();

  factory LocalizationService() {
    return _singleton;
  }

  LocalizationService._internal();

  //public
  String currentLanguageCode = _defaultLanguageCode;

  Future<String> loadDeviceLanguageCode() {
    return getDeviceLanguage().then((deviceLanguageCode) {
      //if there is deviceLanguageCode
      // ignore: unnecessary_null_comparison
      if (deviceLanguageCode != null) {
        deviceLanguageCode = deviceLanguageCode.substring(0, 2);
      } else {
        deviceLanguageCode = _defaultLanguageCode;
      }
      return Future.value(deviceLanguageCode);
    }).catchError((onError) {
      return Future.value(_defaultLanguageCode);
    });
  }

  Future<bool> isUsingLanguage(String codeToCheck) async {
    final currentCode = await loadDeviceLanguageCode();
    return currentCode == codeToCheck;
  }

  Future<String> changeLanguageCode(String newLanguageCode) {
    currentLanguageCode = newLanguageCode;
    return Future.value(currentLanguageCode);
  }

  void resetCurrentLanguage() {
    /* loadDeviceLanguageCode().then((deviceLanguageCode) {
      currentLanguageCode = deviceLanguageCode;
    });*/
    currentLanguageCode = SupportLocale.vi;
  }

  static Future<String> getDeviceLanguage() async {
    var systemLocale = await findSystemLocale();
    Intl.defaultLocale = Intl.verifiedLocale(
        systemLocale, NumberFormat.localeExists,
        onFailure: (_) => SupportLocale.vi);
    return Intl.getCurrentLocale();
  }
}
