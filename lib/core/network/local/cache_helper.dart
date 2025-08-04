import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? _sharedPreferences;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  /// Save data to SharedPreferences
  static Future<bool> setData(String key, dynamic value) async {
    if (_sharedPreferences == null) return false;

    if (value is String) {
      return await _sharedPreferences!.setString(key, value);
    } else if (value is int) {
      return await _sharedPreferences!.setInt(key, value);
    } else if (value is bool) {
      return await _sharedPreferences!.setBool(key, value);
    } else if (value is double) {
      return await _sharedPreferences!.setDouble(key, value);
    } else if (value is List<String>) {
      return await _sharedPreferences!.setStringList(key, value);
    }

    return false;
  }

  /// Get data from SharedPreferences
  static dynamic getData(String key) {
    return _sharedPreferences?.get(key);
  }

  /// Remove a specific key from SharedPreferences
  static Future<bool> removeData(String key) async {
    if (_sharedPreferences == null) return false;
    return await _sharedPreferences!.remove(key);
  }

  /// Clear all stored data in SharedPreferences
  static Future<void> clearData() async {
    await _sharedPreferences?.clear();
  }
}
