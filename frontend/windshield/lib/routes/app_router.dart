import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:windshield/pages/home/overview/daily_flow/overview/daily_flow_overview_page.dart';

import '../pages/login_page.dart';
import '../pages/home/home_page.dart';
import '../pages/register/register_page.dart';
import '../pages/pin_page.dart';
import '../pages/register/register_info_page.dart';

import '../pages/home/overview/statement/statement_page.dart';
import '../pages/home/overview/statement/info/statement_info_page.dart';
import '../pages/home/overview/statement/create/statement_create_page.dart';
import '../pages/home/overview/statement/edit/statement_edit_page.dart';

import '../pages/home/overview/daily_flow/daily_flow_page.dart';
import '../pages/home/overview/daily_flow/create/daily_flow_create_page.dart';

import '../pages/home/overview/balance_sheet/balance_sheet_page.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: '/login',
      page: AppStackPage,
      children: [
        AutoRoute(page: LoginPage, initial: true),
        AutoRoute(page: RegisterPage),
        AutoRoute(page: PinPage),
        AutoRoute(page: RegisterInfoPage),
      ],
    ),
    AutoRoute(
      path: '/',
      page: EmptyRouterPage,
      children: [
        AutoRoute(page: HomePage, initial: true),
        AutoRoute(page: StatementPage),
        AutoRoute(page: StatementInfoPage),
        AutoRoute(page: StatementCreatePage),
        AutoRoute(page: StatementEditPage),
        AutoRoute(page: DailyFlowOverviewPage),
        AutoRoute(page: DailyFlowPage),
        AutoRoute(page: DailyFlowCreatePage),
        AutoRoute(page: BalanceSheetPage),
      ],
    ),
  ],
)
class AppRouter extends _$AppRouter {}

class AppStackPage extends StatelessWidget {
  const AppStackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
