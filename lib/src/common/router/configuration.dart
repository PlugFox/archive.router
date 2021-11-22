import 'package:flutter/widgets.dart';

/// Конфигурация состояния приложения и всех его маршрутов
@immutable
abstract class IRouteConfiguration implements RouteInformation {
  /// Это корневая конфигурация
  bool get isRoot;

  /// Предидущая конфигурация
  /// Если null - значит это корневая конфигурация
  IRouteConfiguration? get previous;

  /// Представление текущего стека навигации в виде строки
  /// См также [RouteInformation.location]
  @override
  String get location;

  /// Состояние конфигурации
  /// Где ключ хэштаблицы - название страницы
  /// А значение - хэштаблица состояния страницы
  /// См также [RouteInformation.state]
  @override
  Map<String, Map<String, Object?>?>? get state;
}

abstract class AppConfigurationBase implements IRouteConfiguration {
  const AppConfigurationBase();
}

class HomeRouteConfiguration extends AppConfigurationBase {
  const HomeRouteConfiguration();

  @override
  bool get isRoot => true;

  @override
  IRouteConfiguration? get previous => null;

  @override
  String get location => '/';

  @override
  Map<String, Map<String, Object?>?>? get state => <String, Map<String, Object?>?>{};
}

class NotFoundRouteConfiguration extends AppConfigurationBase {
  const NotFoundRouteConfiguration();

  @override
  bool get isRoot => false;

  @override
  IRouteConfiguration? get previous => const HomeRouteConfiguration();

  @override
  String get location => '/404';

  @override
  Map<String, Map<String, Object?>?>? get state => <String, Map<String, Object?>?>{};
}

class DynamicRouteConfiguration extends AppConfigurationBase {
  const DynamicRouteConfiguration(this.location, [this.state]);

  @override
  bool get isRoot => previous != null;

  @override
  IRouteConfiguration? get previous {
    if (location == '/') return null;
    try {
      final uri = Uri.parse(location);
      final pathSegments = uri.pathSegments;
      final newLocation = pathSegments.sublist(0, pathSegments.length - 1).join('/');
      final newState = state;
      if (newState != null) {
        newState.remove(pathSegments.last);
      }
      return DynamicRouteConfiguration(
        newLocation,
        newState,
      );
    } on Object {
      return null;
    }
  }

  @override
  final String location;

  @override
  final Map<String, Map<String, Object?>?>? state;
}
