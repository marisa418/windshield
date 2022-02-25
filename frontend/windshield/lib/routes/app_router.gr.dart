// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'app_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    LoginRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const LoginPage());
    },
    RegisterRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const RegisterPage());
    },
    PinRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const PinPage());
    },
    RegisterInfoRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const RegisterInfoPage());
    },
    HomeRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const HomePage());
    },
    StatementRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const StatementPage());
    },
    StatementCreateRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const StatementCreatePage());
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(LoginRoute.name, path: '/'),
        RouteConfig(RegisterRoute.name, path: '/register-page'),
        RouteConfig(PinRoute.name, path: '/pin-page'),
        RouteConfig(RegisterInfoRoute.name, path: '/register-info-page'),
        RouteConfig(HomeRoute.name, path: '/home-page'),
        RouteConfig(StatementRoute.name, path: '/statement-page'),
        RouteConfig(StatementCreateRoute.name, path: '/statement-create-page')
      ];
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute() : super(LoginRoute.name, path: '/');

  static const String name = 'LoginRoute';
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute() : super(RegisterRoute.name, path: '/register-page');

  static const String name = 'RegisterRoute';
}

/// generated route for
/// [PinPage]
class PinRoute extends PageRouteInfo<void> {
  const PinRoute() : super(PinRoute.name, path: '/pin-page');

  static const String name = 'PinRoute';
}

/// generated route for
/// [RegisterInfoPage]
class RegisterInfoRoute extends PageRouteInfo<void> {
  const RegisterInfoRoute()
      : super(RegisterInfoRoute.name, path: '/register-info-page');

  static const String name = 'RegisterInfoRoute';
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute() : super(HomeRoute.name, path: '/home-page');

  static const String name = 'HomeRoute';
}

/// generated route for
/// [StatementPage]
class StatementRoute extends PageRouteInfo<void> {
  const StatementRoute() : super(StatementRoute.name, path: '/statement-page');

  static const String name = 'StatementRoute';
}

/// generated route for
/// [StatementCreatePage]
class StatementCreateRoute extends PageRouteInfo<void> {
  const StatementCreateRoute()
      : super(StatementCreateRoute.name, path: '/statement-create-page');

  static const String name = 'StatementCreateRoute';
}
