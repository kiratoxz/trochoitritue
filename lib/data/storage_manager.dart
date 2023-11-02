import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static final StorageManager _instance = StorageManager._internal();
  StorageManager._internal();

  factory StorageManager() {
    return _instance;
  }

  late SharedPreferences prefs;

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> setLastTimeAccessStaticPage(DateTime time) async {
    await initPrefs();
    prefs.setString(
        StorageKey._lastTimeAccessStaticPage, time.toIso8601String());
    await initPrefs();
  }

  DateTime get lastTimeAccessStaticPage {
    DateTime time = DateTime(2000);
    try {
      final timeStr =
          prefs.getString(StorageKey._lastTimeAccessStaticPage) ?? '';
      time = DateTime.tryParse(timeStr) ?? time;
      return time;
    } catch (_) {
      return time;
    }
  }
}

abstract class StorageKey {
  static const _lastTimeAccessStaticPage = "_lastTimeAccessStaticPage";
}
