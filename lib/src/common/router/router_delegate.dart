import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:l/l.dart';
import 'package:platform_info/platform_info.dart';
import 'package:router/src/common/router/configuration.dart';
import 'package:router/src/common/router/navigator_observer.dart';
import 'package:router/src/common/router/not_found_screen.dart';
import 'package:router/src/common/router/pages_builder.dart';
import 'package:router/src/common/router/router.dart';
import 'package:router/src/feature/router_debug_view/widget/router_debug_view.dart';
import 'package:router/src/feature/router_debug_view/widget/router_debug_view_controller.dart';
import 'package:router/src/feature/router_debug_view/widget/router_debug_view_switch.dart';

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
    RouterDebugViewController.instance.build();
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: AppRouter(
        routerDelegate: this,
        child: PagesBuilder(
          configuration: configuration,
          builder: (context, pages, child) {
            // Вычисляем размеры и доступность отладочной вьюхи
            final size = MediaQuery.of(context).size;
            final padding = size.width < 400 ? 0.0 : 12.0;
            final width = size.width - padding * 2;
            final height = math.min<double>(400, width / 3);
            final showDebugView = width > 350 && height > 100 && size.height / 2 > height;
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  key: const ValueKey<String>('NavigatorPane'),
                  child: Navigator(
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
                      l.v6('Navigator.onPopPage(${route.settings.name}, ${result?.toString() ?? '<null>'})');
                      RouterDebugViewController.instance.popPage(
                        '${route.settings.name}, ${result?.toString() ?? '<null>'}',
                      );
                      if (!route.didPop(result)) {
                        return false;
                      }
                      setNewRoutePath(configuration.previous ?? const NotFoundRouteConfiguration());
                      return true;
                    },
                  ),
                ),
                if (showDebugView && RouterDebugViewSwitch.of(context))
                  SizedBox(
                    key: const ValueKey<String>('DebugView'),
                    height: height + padding,
                    child: RepaintBoundary(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 0,
                          left: padding,
                          right: padding,
                          bottom: padding,
                        ),
                        child: Center(
                          child: SizedBox(
                            width: width,
                            height: height,
                            child: const RouterDebugView(),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Future<bool> popRoute() {
    l.v6('RouterDelegate.popRoute()');
    RouterDebugViewController.instance.popRoute();
    try {
      final navigator = pageObserver.navigator;
      if (navigator == null) return SynchronousFuture<bool>(false);
      return navigator.maybePop().then<bool>(
        (value) {
          if (!value) {
            if (platform.isIO) {
              return false;
              /*
              return SystemNavigator.pop().then<bool>(
                (value) => true,
                onError: (Object error, StackTrace stackTrace) => false,
              );
              */
            }
            // В вебе, вместо перехода на главный экран, можно закрывать текущую активную вкладку
            return setNewRoutePath(
              const HomeRouteConfiguration(),
            ).then<bool>(
              (value) => true,
              onError: (Object error, StackTrace stackTrace) => false,
            );
          }
          return true;
        },
        onError: (Object error, StackTrace stackTrace) => false,
      );
    } on Object catch (err) {
      l.w('RouterDelegate.popRoute: $err');
      return SynchronousFuture(false);
    }
  }

  @override
  Future<void> setNewRoutePath(IRouteConfiguration configuration) {
    l.v6('RouterDelegate.setNewRoutePath(${configuration.location})');
    RouterDebugViewController.instance.setNewRoutePath(configuration.location);
    if (_currentConfiguration == configuration) {
      // Конфигурация не изменилась
      return SynchronousFuture<void>(null);
    }
    _currentConfiguration = configuration;
    notifyListeners();
    return SynchronousFuture<void>(null);
  }

  @override
  Future<void> setRestoredRoutePath(IRouteConfiguration configuration) {
    l.v6('RouterDelegate.setRestoredRoutePath(${configuration.location})');
    RouterDebugViewController.instance.setRestoredRoutePath(configuration.location);
    return super.setRestoredRoutePath(configuration);
  }

  @override
  Future<void> setInitialRoutePath(IRouteConfiguration configuration) {
    l.v6('RouterDelegate.setInitialRoutePath(${configuration.location})');
    RouterDebugViewController.instance.setInitialRoutePath(configuration.location);
    return super.setInitialRoutePath(configuration);
  }

  Route<void> _onUnknownRoute(RouteSettings settings) => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => const NotFoundScreen(),
      );
}
