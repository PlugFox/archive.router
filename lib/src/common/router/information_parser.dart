import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:l/l.dart';
import 'package:path/path.dart' as p;
import 'package:router/src/common/router/configuration.dart';

class AppRouteInformationParser = RouteInformationParser<IRouteConfiguration>
    with _RestoreRouteInformationMixin, _ParseRouteInformationMixin;

mixin _RestoreRouteInformationMixin on RouteInformationParser<IRouteConfiguration> {
  @override
  RouteInformation? restoreRouteInformation(IRouteConfiguration configuration) {
    try {
      l.v6('RouteInformationParser.restoreRouteInformation(${configuration.location})');
      return RouteInformation(
        location: p.normalize(p.join('/', configuration.location)),
        state: configuration.state,
      );
    } on Object catch (error) {
      l.e('Ошибка навигации restoreRouteInformation: $error');
      return const RouteInformation(location: '/');
    }
  }
}

mixin _ParseRouteInformationMixin on RouteInformationParser<IRouteConfiguration> {
  @override
  Future<IRouteConfiguration> parseRouteInformation(RouteInformation routeInformation) {
    try {
      l.v6('RouteInformationParser.parseRouteInformation(${routeInformation.location})');
      if (routeInformation is IRouteConfiguration) return SynchronousFuture<IRouteConfiguration>(routeInformation);
      final location = p.normalize(p.join('/', routeInformation.location));
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
