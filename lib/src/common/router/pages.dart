import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:router/src/common/router/not_found_screen.dart';

@immutable
abstract class AppPage<T extends Object?> extends Page<T> {
  AppPage({
    required this.path,
    Map<String, Object?>? arguments,
    String? restorationId,
    this.maintainState = true,
    this.fullscreenDialog = false,
    LocalKey? key,
  }) : super(
          name: path,
          arguments: arguments,
          restorationId: restorationId ?? path,
          key: key ?? ValueKey<String>(path),
        );

  static AppPage fromPath({
    required final String path,
    final Map<String, Object?>? arguments,
  }) {
    // Предполагаем, что каждый сегмент состоит из имени, а затем через "-" идут
    final segments = path.split('-');
    final name = segments.firstOrNull;
    assert(
      name != null && name.isNotEmpty && name.codeUnits.every((e) => e > 96 && e < 123),
      'Имя должно состоять только из символов латинского алфавита в нижнем регистре: a..z',
    );
    switch (name) {
      case null:
      case '':
      case '/':
      case '*':
      case 'home':
        return HomePage();
      case 'not_found':
      case 'notfound':
      case '404':
      default:
        return NotFoundPage();
    }
  }

  /// Сегмент пути с которым создался роут
  final String path;

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
          path: '/',
        );

  @override
  Widget build(BuildContext context) => const NotFoundScreen();
}

/// Роут не найден
class NotFoundPage extends AppPage<void> {
  NotFoundPage()
      : super(
          path: '404',
        );

  @override
  Widget build(BuildContext context) => const NotFoundScreen();
}
