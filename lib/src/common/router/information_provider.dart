import 'package:flutter/widgets.dart';

class AppRouteInformationProvider extends PlatformRouteInformationProvider {
  AppRouteInformationProvider({
    final RouteInformation initialRouteInformation = const RouteInformation(location: '/'),
  }) : super(
          initialRouteInformation: initialRouteInformation,
        );
}
