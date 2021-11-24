import 'package:flutter/material.dart';
import 'package:router/src/common/router/information_parser.dart';
import 'package:router/src/common/router/information_provider.dart';
import 'package:router/src/common/router/router_delegate.dart';

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
  final PlatformRouteInformationProvider _routeInformationProvider = AppRouteInformationProvider();
  final RouterDelegate<IRouteConfiguration> _routerDelegate = AppRouterDelegate();

  @override
  Widget build(final BuildContext context) => MaterialApp.router(
        onGenerateTitle: (final context) => 'Демонстрация роутинга',
        restorationScopeId: 'router',
        routerDelegate: _routerDelegate,
        routeInformationParser: _routeInformationParser,
        routeInformationProvider: _routeInformationProvider,
      );
}
