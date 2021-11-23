import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:router/src/common/router/not_found_screen.dart';
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
  }) : super(
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
    final segments = location.split('-');
    final name = segments.firstOrNull?.trim().toLowerCase();
    assert(
      name != null && name.isNotEmpty && name.codeUnits.every((e) => e > 96 && e < 123),
      'Имя должно состоять только из символов латинского алфавита в нижнем регистре: a..z',
    );
    switch (name) {
      case '/':
        return HomePage();
      case 'settings':
      case 'setting':
      case 'tuning':
      case 'tune':
        return SettingsPage();
      case 'not_found':
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
          location: '/',
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
