import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:l/l.dart';
import 'package:router/src/common/router/route_information_util.dart';
import 'package:router/src/feature/router_debug_view/widget/router_debug_view_controller.dart';
// ignore_for_file: prefer_mixin

/// The route information provider that propagates the platform route information changes.
///
/// This provider also reports the new route information from the [Router] widget
/// back to engine using message channel method, the
/// [SystemNavigator.routeInformationUpdated].
///
/// Each time [SystemNavigator.routeInformationUpdated] is called, the
/// [SystemNavigator.selectMultiEntryHistory] method is also called. This
/// overrides the initialization behavior of
/// [Navigator.reportsRouteUpdateToEngine].
class AppRouteInformationProvider extends RouteInformationProvider with WidgetsBindingObserver, ChangeNotifier {
  /// Create a platform route information provider.
  ///
  /// Use the [initialRouteInformation] to set the default route information for this
  /// provider.
  AppRouteInformationProvider({
    RouteInformation? initialRouteInformation,
  }) : _value = initialRouteInformation ?? _getDefaultRoute();

  static RouteInformation _getDefaultRoute() {
    final route = RouteInformation(
      location: RouteInformationUtil.normalize(PlatformDispatcher.instance.defaultRouteName),
    );
    l.v6('AppRouteInformationProvider._getDefaultRoute() => ${route.location}');
    return route;
  }

  @override
  void routerReportsNewRouteInformation(
    RouteInformation routeInformation, {
    required RouteInformationReportingType type,
  }) {
    l.v6(
      'RouteInformationProvider.routerReportsNewRouteInformation(${routeInformation.location}',
    );
    RouterDebugViewController.instance.routerReportsNewRouteInformation('${routeInformation.location}');
    final replace = type == RouteInformationReportingType.neglect ||
        (type == RouteInformationReportingType.none && _valueInEngine.location == routeInformation.location);
    //SystemNavigator.selectMultiEntryHistory();
    SystemNavigator.selectSingleEntryHistory();
    SystemNavigator.routeInformationUpdated(
      location: routeInformation.location!,
      state: routeInformation.state,
      replace: replace,
    );
    _value = routeInformation;
    _valueInEngine = routeInformation;
  }

  @override
  RouteInformation get value => _value;
  RouteInformation _value;

  RouteInformation _valueInEngine = RouteInformation(location: WidgetsBinding.instance!.window.defaultRouteName);

  void _platformReportsNewRouteInformation(RouteInformation routeInformation) {
    // Если роут не изменился - игнорируем
    if (_value.location == routeInformation.location && _value.state == routeInformation.state) return;
    l.v6(
      'RouteInformationProvider._platformReportsNewRouteInformation(${_value.location} => ${routeInformation.location})',
    );
    _value = routeInformation;
    _valueInEngine = routeInformation;
    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    if (!hasListeners) WidgetsBinding.instance!.addObserver(this);
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners) WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void dispose() {
    // In practice, this will rarely be called. We assume that the listeners
    // will be added and removed in a coherent fashion such that when the object
    // is no longer being used, there's no listener, and so it will get garbage
    // collected.
    if (hasListeners) WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) async {
    /// Платформа присылает сообщения которые надо бы обрезать
    l.v6('RouteInformationProvider.didPushRouteInformation(${routeInformation.location})');
    RouterDebugViewController.instance.didPushRouteInformation('${routeInformation.location}');

    assert(hasListeners, 'RouteInformationProvider должен обладать подписчиками');

    /// TODO: платформа вызывает didPushRouteInformation() вместо didPopRoute() на стрелочку назад
    /// и присылает не тот роут, на который надо перейти, а тот что обрезать

    // Срабатывает например при нажатии кнопок [вперед] и [назад] в браузере
    final newRouteInformation = RouteInformation(
      location: RouteInformationUtil.normalize(routeInformation.location),
      state: routeInformation.state,
    );
    if (newRouteInformation.location == value.location) {
      return SynchronousFuture<bool>(true);
    }
    _platformReportsNewRouteInformation(routeInformation);
    return true;
  }

  @override
  Future<bool> didPushRoute(String route) async {
    l.v6('RouteInformationProvider.didPushRoute($route)');
    RouterDebugViewController.instance.didPushRoute(route);
    assert(hasListeners, 'RouteInformationProvider должен обладать подписчиками');
    _platformReportsNewRouteInformation(RouteInformation(location: route));
    return true;
  }

  @override
  Future<bool> didPopRoute() {
    l.v6('RouteInformationProvider.didPopRoute()');
    RouterDebugViewController.instance.didPopRoute();
    return super.didPopRoute();
  }
}
