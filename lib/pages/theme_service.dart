import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _key = "isDarkMode";

  // Temayı hafızaya kaydet
  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isDark);
  }

  // Hafızadaki temayı oku
  static Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    // Eğer daha önce hiç seçim yapılmadıysa (null ise) false (aydınlık) döndür
    return prefs.getBool(_key) ?? false;
  }
}