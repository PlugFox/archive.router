import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:l/l.dart';
import 'package:router/src/common/router/pages.dart';
import 'package:router/src/common/router/route_information_util.dart';

/// Конфигурация состояния приложения и всех его маршрутов
@immutable
abstract class IRouteConfiguration implements RouteInformation {
  /// Это корневая конфигурация
  bool get isRoot;

  /// Предыдущая конфигурация
  /// Если null - значит это корневая конфигурация
  IRouteConfiguration? get previous;

  /// Представление текущего стека навигации в виде строки
  /// См также [RouteInformation.location]
  @override
  String get location;

  /// Состояние конфигурации
  /// Где ключ хэштаблицы - [AppPage.location] страницы
  /// А значение - хэштаблица состояния страницы
  /// См также [RouteInformation.state]
  @override
  Map<String, Object?>? get state;

  /// Добавить страницу, роут приложения к конфигурации
  /// выпустив новую конфигурацию на основании текущей
  IRouteConfiguration add(AppPage page);
}

/// Базовая конфигурация
abstract class RouteConfigurationBase implements IRouteConfiguration {
  const RouteConfigurationBase();

  @override
  bool get isRoot => previous != null;

  @override
  IRouteConfiguration? get previous {
    IRouteConfiguration? getPrevious() {
      if (location == '/' || location == 'home' || location.isEmpty) return null;
      try {
        final uri = Uri.parse(location);
        final pathSegments = uri.pathSegments;
        if (pathSegments.length == 1) {
          return const HomeRouteConfiguration();
        }
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

    final prev = getPrevious();
    l.v6('RouteConfiguration.previous => ${prev?.location ?? '<null>'}');
    return prev;
  }

  @override
  IRouteConfiguration add(AppPage page) {
    if (page.location.isEmpty) return this;
    final arguments = page.arguments;
    final newLocation = RouteInformationUtil.normalize('$location/${page.location}');
    if (arguments is Map<String, Object?> || state != null) {
      return DynamicRouteConfiguration(
        newLocation,
        <String, Object?>{
          ...?state,
          if (arguments is Object) page.location: arguments,
        },
      );
    }
    return DynamicRouteConfiguration(newLocation);
  }

  @override
  String toString() => 'RouteConfiguration($location)';

  @override
  int get hashCode => Object.hash(location, state);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IRouteConfiguration &&
          location == other.location &&
          const DeepCollectionEquality.unordered().equals(
            state,
            other.state,
          ));
}

/// Презет конфигурации домашнего, корневого роута
class HomeRouteConfiguration extends RouteConfigurationBase {
  const HomeRouteConfiguration();

  @override
  bool get isRoot => true;

  @override
  IRouteConfiguration? get previous => null;

  @override
  String get location => 'home';

  @override
  Map<String, Object?>? get state => <String, Object?>{};
}

/// Конфигурация описывающая отсутсвующий контент
class NotFoundRouteConfiguration extends RouteConfigurationBase {
  const NotFoundRouteConfiguration();

  @override
  bool get isRoot => false;

  @override
  IRouteConfiguration? get previous => const HomeRouteConfiguration();

  @override
  String get location => 'home/404';

  @override
  Map<String, Object?>? get state => <String, Object?>{};
}

/// Динамическая конфигурация, получаемая путем преобразования заданных презетов
/// или при изменении конфигурации на платформе
class DynamicRouteConfiguration extends RouteConfigurationBase {
  const DynamicRouteConfiguration(this.location, [this.state]);

  @override
  final String location;

  @override
  final Map<String, Object?>? state;
}
