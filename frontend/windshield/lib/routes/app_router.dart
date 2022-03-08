import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

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

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: LoginPage, initial: true),
    AutoRoute(page: RegisterPage),
    AutoRoute(page: PinPage),
    AutoRoute(page: RegisterInfoPage),
    AutoRoute(page: HomePage),
    AutoRoute(page: StatementPage),
    AutoRoute(page: StatementInfoPage),
    AutoRoute(page: StatementCreatePage),
    AutoRoute(page: StatementEditPage),
    AutoRoute(page: DailyFlowPage),
    AutoRoute(page: DailyFlowCreatePage),
  ],
)
class AppRouter extends _$AppRouter {}
