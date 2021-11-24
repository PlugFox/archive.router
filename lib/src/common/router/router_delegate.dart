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
  AppRouterDelegate()
      : pageObserver = PageObserver(),
        modalObserver = ModalObserver();

  final PageObserver pageObserver;
  final ModalObserver modalObserver;

  @override
  IRouteConfiguration get currentConfiguration {
    final configuration = _currentConfiguration;
    if (configuration == null) {
      throw UnsupportedError('Изначальная конфигурация не установлена');
    }
    return configuration;
  }

  IRouteConfiguration? _currentConfiguration;

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
    return super.setRestoredRoutePath(configuration);
  }

  @override
  Future<void> setInitialRoutePath(IRouteConfiguration configuration) {
    l.v6('RouterDelegate.setInitialRoutePath($configuration)');
    return super.setInitialRoutePath(configuration);
  }

  Route<void> _onUnknownRoute(RouteSettings settings) => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => const NotFoundScreen(),
      );
}
