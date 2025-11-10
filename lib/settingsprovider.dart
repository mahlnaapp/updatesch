import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsProvider extends ChangeNotifier {
  static const _storage = FlutterSecureStorage();
  static const _themeKey = 'isDarkMode';

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  SettingsProvider() {
    // Load theme after construction
    Future.microtask(() => _loadTheme());
  }

  /// Toggle theme and save persistently
  void toggleTheme(bool value) {
    _isDarkMode = value;
    notifyListeners();
    _saveTheme(value);
  }

  /// Load theme from secure storage
  Future<void> _loadTheme() async {
    try {
      final saved = await _storage.read(key: _themeKey);
      if (saved != null) {
        _isDarkMode = saved.toLowerCase() == 'true';
        notifyListeners(); // safe, UI will react
      }
    } catch (e) {
      debugPrint('Failed to load theme: $e');
    }
  }

  /// Save theme to secure storage
  Future<void> _saveTheme(bool value) async {
    try {
      await _storage.write(key: _themeKey, value: value.toString());
    } catch (e) {
      debugPrint('Failed to save theme: $e');
    }
  }
}
