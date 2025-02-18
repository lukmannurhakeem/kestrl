import 'package:flutter/material.dart';

import 'locator_service.dart';

class NavigationService {
  static NavigationService get instance => locator<NavigationService>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final RouteObserver<PageRoute<dynamic>> routeObserver =
      RouteObserver<PageRoute<dynamic>>();

  BuildContext getCurrentContext() => navigatorKey.currentContext!;

  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  void pushNamedAndRemoveUntil(String routeName, {Object? arguments}) {
    navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName, (Route route) => false,
        arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  void pop<T>({T? result}) {
    navigatorKey.currentState!.pop(result);
  }
}
