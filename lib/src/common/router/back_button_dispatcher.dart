import 'package:flutter/widgets.dart';
import 'package:l/l.dart';

class AppBackButtonDispatcher extends RootBackButtonDispatcher {
  AppBackButtonDispatcher();

  @override
  Future<bool> didPopRoute() {
    // Это срабатывает только на мобильнике.
    // Нажатие кнопки "назад" в браузере воспринимается как
    // переход на другую страницу
    l.v6('RootBackButtonDispatcher.didPopRoute()');
    return super.didPopRoute();
  }
}
