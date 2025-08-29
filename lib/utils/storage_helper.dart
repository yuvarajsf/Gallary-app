import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class StorageHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveServerUrl(String url) async {
    await init();
    await _prefs!.setString(AppConstants.serverUrlKey, url);
  }

  static Future<String?> getServerUrl() async {
    await init();
    return _prefs!.getString(AppConstants.serverUrlKey);
  }

  static Future<void> saveLastUsedPath(String path) async {
    await init();
    await _prefs!.setString(AppConstants.lastUsedPathKey, path);
  }

  static Future<String?> getLastUsedPath() async {
    await init();
    return _prefs!.getString(AppConstants.lastUsedPathKey);
  }

  static Future<void> clearAll() async {
    await init();
    await _prefs!.clear();
  }
}