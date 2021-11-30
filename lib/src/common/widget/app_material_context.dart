import 'package:flutter/material.dart';
import 'package:router/src/common/router/back_button_dispatcher.dart';
import 'package:router/src/common/router/information_parser.dart';
import 'package:router/src/common/router/information_provider.dart';
import 'package:router/src/common/router/router_delegate.dart';
import 'package:router/src/feature/settings/widget/inherited_theme_notifier.dart';
import 'package:router/src/feature/settings/widget/theme_controller.dart';

@immutable
class AppMaterialContext extends StatefulWidget {
  const AppMaterialContext({
    final Key? key,
  }) : super(key: key);

  @override
  State<AppMaterialContext> createState() => _AppMaterialContextState();
}

class _AppMaterialContextState extends State<AppMaterialContext> {
  final RouteInformationParser<IRouteConfiguration> _routeInformationParser = const AppRouteInformationParser();
  final RouteInformationProvider _routeInformationProvider = AppRouteInformationProvider();
  final RouterDelegate<IRouteConfiguration> _routerDelegate = AppRouterDelegate();
  final BackButtonDispatcher _backButtonDispatcher = AppBackButtonDispatcher();
  final ThemeController _themeController = ThemeController();

  @override
  Widget build(final BuildContext context) => InheritedThemeNotifier(
        themeController: _themeController,
        child: Builder(
          builder: (context) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: InheritedThemeNotifier.maybeOf(context)?.theme ?? ThemeData.light(),
            onGenerateTitle: (final context) => 'Routing',
            restorationScopeId: 'router',
            routerDelegate: _routerDelegate,
            routeInformationParser: _routeInformationParser,
            routeInformationProvider: _routeInformationProvider,
            backButtonDispatcher: _backButtonDispatcher,
          ),
        ),
      );
}
