import 'package:flutter_app/injections.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static final LocalData _instance = LocalData._internal();

  factory LocalData() => _instance;

  LocalData._internal();

  static bool loadingActive = true;

  //! Setter Functions
  static Future<bool> setString(String key, String value) async {
    return await getIt<SharedPreferences>().setString(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    return await getIt<SharedPreferences>().setBool(key, value);
  }

  static Future<bool> setListString(String key, List<String> value) async {
    return await getIt<SharedPreferences>().setStringList(key, value);
  }

  static Future<bool> remove(String key) async {
    return await getIt<SharedPreferences>().remove(key);
  }

  static Future<bool> clear() async {
    return await getIt<SharedPreferences>().clear();
  }

  //! Getter Functions
  static String get token {
    return getIt<SharedPreferences>().getString(LocalKeys.token) ?? '';
  }
}

class LocalKeys {
  static const String token = 'TOKEN';
}
