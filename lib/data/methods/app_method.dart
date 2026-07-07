import 'package:get_storage/get_storage.dart';

class AppMethod {
  static final GetStorage _storage = GetStorage();

  static const String _themeKey = 'theme_mode';
  static const String _visitedKey = 'has_visited';

  static Future<void> initStorage() async {
    await GetStorage.init();
  }

  static bool getHasVisited() => _storage.read<bool>(_visitedKey) ?? false;

  static Future<void> setHasVisited(bool value) async {
    await _storage.write(_visitedKey, value);
  }

  static String? getThemeMode() => _storage.read<String>(_themeKey);

  static Future<void> setThemeMode(String mode) async {
    await _storage.write(_themeKey, mode);
  }

  static Future<void> clearAll() async {
    await _storage.erase();
  }
}
