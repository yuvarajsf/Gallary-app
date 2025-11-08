import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  static const _kPrimaryKey = 'theme_primary_color';
  static const _kSecondaryKey = 'theme_secondary_color';
  static const _kAccentKey = 'theme_accent_color';
  static const _kFontColorKey = 'theme_font_color';

  Color _primary;
  Color _secondary;
  Color _accent;
  Color _fontColor;

  ThemeNotifier()
      : _primary = const Color(0xFF6366F1),
        _secondary = const Color(0xFF8B5CF6),
        _accent = const Color(0xFFEC4899),
        _fontColor = const Color(0xFF1E293B) {
    _load();
  }

  Color get primary => _primary;
  Color get secondary => _secondary;
  Color get accent => _accent;
  Color get fontColor => _fontColor;

  ThemeData themeData({bool dark = false}) {
    final onSurface = dark ? const Color(0xFFE2E8F0) : _fontColor;
    final surface = dark ? const Color(0xFF1E293B) : Colors.white;
    final background = dark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

    final colorScheme = ColorScheme(
      brightness: dark ? Brightness.dark : Brightness.light,
      primary: _primary,
      onPrimary: Colors.white,
      secondary: _secondary,
      onSecondary: Colors.white,
      error: const Color(0xFFEF4444),
      onError: Colors.white,
      background: background,
      onBackground: onSurface,
      surface: surface,
      onSurface: onSurface,
      tertiary: _accent,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: dark ? Brightness.dark : Brightness.light,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: onSurface,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
      ),
      cardTheme: CardTheme(
        elevation: dark ? 4 : 2,
        shadowColor: Colors.black.withOpacity(dark ? 0.3 : 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: surface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? const Color(0xFF1E293B) : Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: dark ? Colors.grey.shade600 : Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<void> setPrimary(Color c) async { _primary = c; await _save(); notifyListeners(); }
  Future<void> setSecondary(Color c) async { _secondary = c; await _save(); notifyListeners(); }
  Future<void> setAccent(Color c) async { _accent = c; await _save(); notifyListeners(); }
  Future<void> setFontColor(Color c) async { _fontColor = c; await _save(); notifyListeners(); }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    _primary = Color(p.getInt(_kPrimaryKey) ?? _primary.value);
    _secondary = Color(p.getInt(_kSecondaryKey) ?? _secondary.value);
    _accent = Color(p.getInt(_kAccentKey) ?? _accent.value);
    _fontColor = Color(p.getInt(_kFontColorKey) ?? _fontColor.value);
    notifyListeners();
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_kPrimaryKey, _primary.value);
    await p.setInt(_kSecondaryKey, _secondary.value);
    await p.setInt(_kAccentKey, _accent.value);
    await p.setInt(_kFontColorKey, _fontColor.value);
  }
}
