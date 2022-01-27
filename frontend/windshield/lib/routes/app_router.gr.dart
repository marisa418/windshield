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
    MyHomeRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const MyHomePage());
    },
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
    StatementRoute.name: (routeData) {
      final args = routeData.argsAs<StatementRouteArgs>(
          orElse: () => const StatementRouteArgs());
      return MaterialPageX<dynamic>(
          routeData: routeData, child: StatementPage(key: args.key));
    },
    StatementCreateRoute.name: (routeData) {
      final args = routeData.argsAs<StatementCreateRouteArgs>(
          orElse: () => const StatementCreateRouteArgs());
      return MaterialPageX<dynamic>(
          routeData: routeData, child: StatementCreatePage(key: args.key));
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(MyHomeRoute.name, path: '/my-home-page'),
        RouteConfig(LoginRoute.name, path: '/'),
        RouteConfig(RegisterRoute.name, path: '/register-page'),
        RouteConfig(PinRoute.name, path: '/pin-page'),
        RouteConfig(RegisterInfoRoute.name, path: '/register-info-page'),
        RouteConfig(StatementRoute.name, path: '/statement'),
        RouteConfig(StatementCreateRoute.name, path: '/statement/create')
      ];
}

/// generated route for
/// [MyHomePage]
class MyHomeRoute extends PageRouteInfo<void> {
  const MyHomeRoute() : super(MyHomeRoute.name, path: '/my-home-page');

  static const String name = 'MyHomeRoute';
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
/// [StatementPage]
class StatementRoute extends PageRouteInfo<StatementRouteArgs> {
  StatementRoute({Key? key})
      : super(StatementRoute.name,
            path: '/statement', args: StatementRouteArgs(key: key));

  static const String name = 'StatementRoute';
}

class StatementRouteArgs {
  const StatementRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'StatementRouteArgs{key: $key}';
  }
}

/// generated route for
/// [StatementCreatePage]
class StatementCreateRoute extends PageRouteInfo<StatementCreateRouteArgs> {
  StatementCreateRoute({Key? key})
      : super(StatementCreateRoute.name,
            path: '/statement/create',
            args: StatementCreateRouteArgs(key: key));

  static const String name = 'StatementCreateRoute';
}

class StatementCreateRouteArgs {
  const StatementCreateRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'StatementCreateRouteArgs{key: $key}';
  }
}
