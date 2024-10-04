// Route Paths
import 'package:flutter/material.dart';
import '../ui/home.dart';
import '../ui/spalsh.dart';


class AppRoutePath {

  final String? location;


  AppRoutePath.home() : location = '/home';


  AppRoutePath.splash() : location = '/';

  AppRoutePath.fullScreenImage() : location = '/fullScreenImage';


  bool get isHomePage => location == '/home';


  bool get isSplashPage => location == '/';

  bool get isFullScreenImagePage => location == '/fullScreenImage';
}

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? '/');

    if (uri.pathSegments.isEmpty) {
      return AppRoutePath.splash();
    }

    if (uri.pathSegments.length == 1) {
      switch (uri.pathSegments[0]) {
        case 'home':
          return AppRoutePath.home();
        case 'fullScreenImage':
          return AppRoutePath.fullScreenImage();
      }
    }

    return AppRoutePath.splash();
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
    if (configuration.isHomePage) {
      return RouteInformation(uri: Uri.parse('/home'));
    } else if (configuration.isFullScreenImagePage) {
      return RouteInformation(uri: Uri.parse('/fullScreenImage'));
    }
    return RouteInformation(uri: Uri.parse('/'));
  }
}


class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AppRoutePath _currentPath = AppRoutePath.splash();

  @override
  AppRoutePath get currentConfiguration => _currentPath;


  void _handleSplashComplete() {
    _currentPath = AppRoutePath.home();
    notifyListeners();
  }


  void _handleFullScreenImage() {
    _currentPath = AppRoutePath.fullScreenImage();
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (_currentPath.isSplashPage)
          MaterialPage(
            key: const ValueKey('SplashPage'),
            child: SplashScreen(onComplete: _handleSplashComplete),
          ),
        if (_currentPath.isHomePage)
          MaterialPage(
            key: const ValueKey('HomePage'),
            child: Home(onFullScreenImage: _handleFullScreenImage),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        _currentPath = AppRoutePath.splash();
        notifyListeners(); // Notifies listeners when popping the route
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    _currentPath = configuration;
  }
}
