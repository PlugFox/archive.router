import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:l/l.dart';

class AppRouteInformationProvider extends PlatformRouteInformationProvider {
  AppRouteInformationProvider({
    final RouteInformation? initialRouteInformation,
  }) : super(
          initialRouteInformation: initialRouteInformation ??
              RouteInformation(
                location: PlatformDispatcher.instance.defaultRouteName,
              ),
        );

  @override
  // ignore: unnecessary_overrides
  RouteInformation get value => super.value;

  @override
  void routerReportsNewRouteInformation(
    RouteInformation routeInformation, {
    required RouteInformationReportingType type,
  }) {
    l.v6(
      'PlatformRouteInformationProvider.routerReportsNewRouteInformation(${routeInformation.location}, '
      'type: ${type.name})',
    );
    super.routerReportsNewRouteInformation(
      routeInformation,
      type: type,
    );
  }

  @override
  Future<bool> didPopRoute() {
    l.v6('PlatformRouteInformationProvider.didPopRoute()');
    return super.didPopRoute();
  }

  @override
  Future<bool> didPushRoute(String route) {
    l.v6('PlatformRouteInformationProvider.didPushRoute($route)');
    return super.didPushRoute(route);
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    l.v6('PlatformRouteInformationProvider.didPushRouteInformation(${routeInformation.location})');
    return super.didPushRouteInformation(routeInformation);
  }
}
