import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:l/l.dart';
import 'package:router/src/common/router/configuration.dart';
import 'package:router/src/common/router/navigator_observer.dart';
import 'package:router/src/common/router/not_found_screen.dart';
import 'package:router/src/common/router/pages_builder.dart';
import 'package:router/src/common/router/router.dart';

export 'package:router/src/common/router/configuration.dart';
export 'package:router/src/common/router/navigator_observer.dart';
export 'package:router/src/common/router/not_found_screen.dart';
export 'package:router/src/common/router/pages_builder.dart';
export 'package:router/src/common/router/router.dart';

// ignore_for_file: prefer_mixin, avoid_types_on_closure_parameters

class AppRouterDelegate extends RouterDelegate<IRouteConfiguration> with ChangeNotifier {
  AppRouterDelegate({
    final IRouteConfiguration initialConfiguration = const HomeRouteConfiguration(),
  })  : _currentConfiguration = initialConfiguration,
        pageObserver = PageObserver(),
        modalObserver = ModalObserver() {
    if (!initialConfiguration.isRoot) {
      setInitialRoutePath(initialConfiguration);
    }
  }

  final PageObserver pageObserver;
  final ModalObserver modalObserver;

  @override
  IRouteConfiguration get currentConfiguration => _currentConfiguration;
  IRouteConfiguration _currentConfiguration;

  @override
  Widget build(BuildContext context) {
    final configuration = currentConfiguration;
    return AppRouter(
      routerDelegate: this,
      child: PagesBuilder(
        configuration: configuration,
        builder: (context, pages, child) => Navigator(
          transitionDelegate: const DefaultTransitionDelegate<Object?>(),
          onUnknownRoute: _onUnknownRoute,
          reportsRouteUpdateToEngine: true,
          observers: <NavigatorObserver>[
            pageObserver,
            modalObserver,
            //if (analytics != null) FirebaseAnalyticsObserver(analytics: analytics),
          ],
          pages: pages,
          onPopPage: (Route<Object?> route, Object? result) {
            l.v6('RouterDelegate.onPopPage(${route.settings.name}, ${result?.toString() ?? '<null>'})');
            if (!route.didPop(result)) {
              return false;
            }
            setNewRoutePath(configuration.previous ?? const NotFoundRouteConfiguration());
            return true;
          },
        ),
      ),
    );
  }

  @override
  Future<bool> popRoute() {
    l.v6('RouterDelegate.popRoute()');
    final navigator = pageObserver.navigator;
    if (currentConfiguration.isRoot || navigator == null) return SynchronousFuture<bool>(false);
    return navigator.maybePop();
  }

  @override
  Future<void> setNewRoutePath(IRouteConfiguration configuration) {
    l.v6('RouterDelegate.setNewRoutePath($configuration)');
    _currentConfiguration = configuration;
    notifyListeners();
    return SynchronousFuture<void>(null);
  }

  @override
  Future<void> setRestoredRoutePath(IRouteConfiguration configuration) {
    l.v6('RouterDelegate.setRestoredRoutePath($configuration)');
    if (currentConfiguration.isRoot && !configuration.isRoot) {
      // Если сейчас пользователь находиться в корне и новая, востанавливаемая конфигурация - не корень
      return setNewRoutePath(configuration);
    }
    return SynchronousFuture<void>(null);
  }

  @override
  Future<void> setInitialRoutePath(IRouteConfiguration configuration) {
    l.v6('RouterDelegate.setInitialRoutePath($configuration)');
    return setNewRoutePath(configuration);
  }

  Route<void> _onUnknownRoute(RouteSettings settings) => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => const NotFoundScreen(),
      );
}
