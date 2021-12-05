import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:l/l.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _spThemeKey = 'is_light_theme';

/// Контроллер текущей темы
// ignore: prefer_mixin
class ThemeController with ChangeNotifier {
  ThemeController() : _isLight = ui.window.platformBrightness != ui.Brightness.dark {
    SharedPreferences.getInstance().then<void>(
      (sp) {
        final theme = sp.getBool(_spThemeKey);
        if (theme != null && theme != isLight) {
          _isLight = theme;
          notifyListeners();
        }
      },
      onError: l.w,
    );
  }

  /// Текущая тема
  ThemeData get theme => isLight ? ThemeData.light() : ThemeData.dark();

  /// Светлая тема
  bool get isLight => _isLight;

  /// Темная тема
  bool get isDark => !isLight;

  bool _isLight;

  /// Переключить тему
  void switchTheme() {
    _isLight = !_isLight;
    SharedPreferences.getInstance().then<void>(
      (sp) {
        sp.setBool(_spThemeKey, _isLight);
      },
      onError: l.w,
    );
    notifyListeners();
  }
}
