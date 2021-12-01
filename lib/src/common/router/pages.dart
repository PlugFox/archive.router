import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:router/src/common/router/not_found_screen.dart';
import 'package:router/src/feature/about/widget/about_screen.dart';
import 'package:router/src/feature/accent/widget/accent_screen.dart';
import 'package:router/src/feature/color/widget/color_screen.dart';
import 'package:router/src/feature/home/widget/home_screen.dart';
import 'package:router/src/feature/settings/widget/settings_screen.dart';

/// Базовый класс роута для приложения, с ним работает корневой роутер
@immutable
abstract class AppPage<T extends Object?> extends Page<T> {
  AppPage({
    required this.location,
    Object? arguments,
    String? restorationId,
    this.maintainState = true,
    this.fullscreenDialog = false,
    LocalKey? key,
  })  : assert(
          location.toLowerCase().trim() == location,
          'Предполагается, что адрес страницы всегда в нижнем регистре',
        ),
        super(
          name: location,
          arguments: arguments,
          restorationId: restorationId ?? location,
          key: key ?? ValueKey<String>(location),
        );

  /// Создать роут из сегмента пути
  static AppPage fromPath({
    required final String location,
    final Object? arguments,
  }) {
    // Предполагаем, что каждый сегмент состоит из имени,
    // описывающий тип роута, а затем, через "-", идут
    // дополнительные, позиционные, параметры, например id
    final segments = location.toLowerCase().split('-');
    final name = segments.firstOrNull?.trim();
    final args = segments.length > 1 ? segments.sublist(1) : <String>[];
    assert(
      name != null && name.isNotEmpty && name.codeUnits.every((e) => e > 96 && e < 123),
      'Имя должно состоять только из символов латинского алфавита в нижнем регистре: a..z',
    );
    // Тут объявляем все роуты приложения
    switch (name) {
      case '':
      case '/':
      case 'home':
        return HomePage();
      case 'settings':
        return SettingsPage();
      case 'about':
        return AboutPage();
      case 'color':
        return ColorPage.fromArgs(args);
      case 'accent':
        return AccentPage.fromArgs(args);
      case '404':
      default:
        return NotFoundPage();
    }
  }

  /// Сегмент пути с которым создался роут
  /// Например для экрана настроек это "settings"
  final String location;

  /// {@macro flutter.widgets.ModalRoute.maintainState}
  final bool maintainState;

  /// {@macro flutter.widgets.PageRoute.fullscreenDialog}
  final bool fullscreenDialog;

  @override
  Route<T> createRoute(BuildContext context) => MaterialPageRoute<T>(
        builder: build,
        settings: this,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
      );

  Widget build(BuildContext context);
}

/// Домашний роут
class HomePage extends AppPage<void> {
  HomePage()
      : super(
          location: 'home',
        );

  @override
  Widget build(BuildContext context) => const HomeScreen();
}

/// Роут не найден
class NotFoundPage extends AppPage<void> {
  NotFoundPage()
      : super(
          location: '404',
        );

  @override
  Widget build(BuildContext context) => const NotFoundScreen();
}

/// Настройки
class SettingsPage extends AppPage<void> {
  SettingsPage()
      : super(
          location: 'settings',
        );

  @override
  Widget build(BuildContext context) => const SettingsScreen();
}

/// Страница описания
class AboutPage extends AppPage<void> {
  AboutPage()
      : super(
          location: 'about',
        );

  @override
  Widget build(BuildContext context) => const AboutScreen();
}

/// Выбранный цвет
class ColorPage extends AppPage<void> {
  ColorPage._(
    this.colorName,
    this.color,
  ) : super(
          location: 'color-$colorName',
        );

  factory ColorPage.red() => ColorPage._('red', Colors.red);

  factory ColorPage.green() => ColorPage._('green', Colors.green);

  factory ColorPage.blue() => ColorPage._('blue', Colors.blue);

  static AppPage<void> fromArgs(final List<String> args) {
    try {
      final title = args[0];
      switch (title) {
        case 'red':
          return ColorPage.red();
        case 'green':
          return ColorPage.green();
        case 'blue':
          return ColorPage.blue();
        default:
          return NotFoundPage();
      }
    } on Object {
      return NotFoundPage();
    }
  }

  final String colorName;
  final MaterialColor color;

  @override
  Widget build(BuildContext context) => ColorScreen(colorName: colorName, color: color);
}

/// Выбранный оттенок
class AccentPage extends AppPage<void> {
  AccentPage._(
    this.colorName,
    this.accent,
    this.color,
  ) : super(
          location: 'accent-$colorName-$accent',
        );

  factory AccentPage({
    required final String colorName,
    required final int accent,
    required final MaterialColor color,
  }) =>
      AccentPage._(colorName, accent, color[accent]!);

  factory AccentPage.red(int accent) => AccentPage._('red', accent, Colors.red[accent]!);

  factory AccentPage.green(int accent) => AccentPage._('green', accent, Colors.green[accent]!);

  factory AccentPage.blue(int accent) => AccentPage._('blue', accent, Colors.blue[accent]!);

  static AppPage<void> fromArgs(final List<String> args) {
    try {
      final title = args[0];
      final accent = int.parse(args[1]);
      switch (title) {
        case 'red':
          return AccentPage.red(accent);
        case 'green':
          return AccentPage.green(accent);
        case 'blue':
          return AccentPage.blue(accent);
        default:
          return NotFoundPage();
      }
    } on Object {
      return NotFoundPage();
    }
  }

  final String colorName;
  final int accent;
  final Color color;

  @override
  Widget build(BuildContext context) => AccentScreen(
        colorName: colorName,
        accent: accent,
        color: color,
      );
}
