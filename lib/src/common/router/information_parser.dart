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
      final location = _reduceLocation(configuration.location);
      l.v6('RouteInformationParser.restoreRouteInformation($location)');
      return RouteInformation(
        location: location,
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
      if (routeInformation is IRouteConfiguration) return SynchronousFuture<IRouteConfiguration>(routeInformation);
      final location = _reduceLocation(routeInformation.location ?? '/');
      l.v6('RouteInformationParser.parseRouteInformation($location)');
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

String _reduceLocation(String sourceLocation) {
  final segments = <String>[];
  sourceLocation.toLowerCase().split('/').map<String>((e) => e.trim()).where((e) => e.isNotEmpty).forEach(
        (e) => segments
          ..remove(e)
          ..add(e),
      );
  return p.normalize(p.join('/', segments.join('/')));
}
