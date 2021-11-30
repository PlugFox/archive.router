import 'package:flutter/widgets.dart';
import 'package:l/l.dart';
import 'package:router/src/feature/router_debug_view/widget/router_debug_view_controller.dart';

class AppBackButtonDispatcher extends RootBackButtonDispatcher {
  AppBackButtonDispatcher();

  @override
  Future<bool> didPopRoute() => backButton();

  Future<bool> backButton() {
    // Это срабатывает только на мобильнике.
    // Нажатие кнопки "назад" в браузере воспринимается как
    // переход на другую страницу
    l.v6('RootBackButtonDispatcher.didPopRoute()');
    RouterDebugViewController.instance.backButtonDispatcher();
    return super.didPopRoute();
  }
}
