import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:l/l.dart';
import 'package:router/src/common/router/configuration.dart';
import 'package:router/src/common/router/route_information_util.dart';
import 'package:router/src/feature/router_debug_view/widget/router_debug_view_controller.dart';

// /// Последняя известная платформе конфигурация приложения
// /// используется для проверки необходимости уведомления платформы об изменениях
// IRouteConfiguration? _currentConfiguration;

class AppRouteInformationParser = RouteInformationParser<IRouteConfiguration>
    with _RestoreRouteInformationMixin, _ParseRouteInformationMixin;

mixin _RestoreRouteInformationMixin on RouteInformationParser<IRouteConfiguration> {
  @override
  RouteInformation? restoreRouteInformation(IRouteConfiguration configuration) {
    try {
      //if (configuration == _currentConfiguration) {
      //  // Конфигурация не изменилась, не сообщаем платформе об изменениях
      //  return null;
      //}
      final location = RouteInformationUtil.normalize(configuration.location);
      final state = configuration.state;
      l.v6('RouteInformationParser.restoreRouteInformation($location)');
      RouterDebugViewController.instance.restoreRouteInformation(location);
      final route = RouteInformation(
        location: location,
        state: state,
      );
      //_currentConfiguration = configuration;
      return route;
    } on Object catch (error) {
      l.e('Ошибка навигации restoreRouteInformation: $error');
      return const RouteInformation(location: 'home');
    }
  }
}

mixin _ParseRouteInformationMixin on RouteInformationParser<IRouteConfiguration> {
  @override
  Future<IRouteConfiguration> parseRouteInformation(RouteInformation routeInformation) {
    try {
      if (routeInformation is IRouteConfiguration) return SynchronousFuture<IRouteConfiguration>(routeInformation);
      final location = RouteInformationUtil.normalize(routeInformation.location);
      l.v6('RouteInformationParser.parseRouteInformation($location)');
      RouterDebugViewController.instance.parseRouteInformation(location);
      var state = routeInformation.state;
      if (state is! Map<String, Map<String, Object?>?>?) {
        state = null;
      }
      final configuration = DynamicRouteConfiguration(location, state);
      return SynchronousFuture<IRouteConfiguration>(configuration);
    } on Object catch (error) {
      l.e('Ошибка навигации parseRouteInformation: $error');
      return SynchronousFuture<IRouteConfiguration>(const NotFoundRouteConfiguration());
    }
  }
}
