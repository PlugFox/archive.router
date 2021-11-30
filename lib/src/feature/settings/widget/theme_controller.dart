import 'dart:ui' as ui;

import 'package:flutter/material.dart';

// ignore: prefer_mixin
class ThemeController with ChangeNotifier {
  ThemeController() : _isDark = ui.window.platformBrightness == ui.Brightness.dark;
  ThemeData get theme => _isDark ? ThemeData.dark() : ThemeData.light();
  bool get isDark => _isDark;
  bool get isLight => !isDark;
  bool _isDark;
  void switchTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
