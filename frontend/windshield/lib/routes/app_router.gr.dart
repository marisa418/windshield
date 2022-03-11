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
    StatementInfoRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const StatementInfoPage());
    },
    StatementCreateRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const StatementCreatePage());
    },
    StatementEditRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const StatementEditPage());
    },
    DailyFlowRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const DailyFlowPage());
    },
    DailyFlowCreateRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const DailyFlowCreatePage());
    },
    BalanceSheetRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const BalanceSheetPage());
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
        RouteConfig(StatementInfoRoute.name, path: '/statement-info-page'),
        RouteConfig(StatementCreateRoute.name, path: '/statement-create-page'),
        RouteConfig(StatementEditRoute.name, path: '/statement-edit-page'),
        RouteConfig(DailyFlowRoute.name, path: '/daily-flow-page'),
        RouteConfig(DailyFlowCreateRoute.name, path: '/daily-flow-create-page'),
        RouteConfig(BalanceSheetRoute.name, path: '/balance-sheet-page')
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
/// [StatementInfoPage]
class StatementInfoRoute extends PageRouteInfo<void> {
  const StatementInfoRoute()
      : super(StatementInfoRoute.name, path: '/statement-info-page');

  static const String name = 'StatementInfoRoute';
}

/// generated route for
/// [StatementCreatePage]
class StatementCreateRoute extends PageRouteInfo<void> {
  const StatementCreateRoute()
      : super(StatementCreateRoute.name, path: '/statement-create-page');

  static const String name = 'StatementCreateRoute';
}

/// generated route for
/// [StatementEditPage]
class StatementEditRoute extends PageRouteInfo<void> {
  const StatementEditRoute()
      : super(StatementEditRoute.name, path: '/statement-edit-page');

  static const String name = 'StatementEditRoute';
}

/// generated route for
/// [DailyFlowPage]
class DailyFlowRoute extends PageRouteInfo<void> {
  const DailyFlowRoute() : super(DailyFlowRoute.name, path: '/daily-flow-page');

  static const String name = 'DailyFlowRoute';
}

/// generated route for
/// [DailyFlowCreatePage]
class DailyFlowCreateRoute extends PageRouteInfo<void> {
  const DailyFlowCreateRoute()
      : super(DailyFlowCreateRoute.name, path: '/daily-flow-create-page');

  static const String name = 'DailyFlowCreateRoute';
}

/// generated route for
/// [BalanceSheetPage]
class BalanceSheetRoute extends PageRouteInfo<void> {
  const BalanceSheetRoute()
      : super(BalanceSheetRoute.name, path: '/balance-sheet-page');

  static const String name = 'BalanceSheetRoute';
}
