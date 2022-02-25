import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../pages/login_page.dart';
import '../pages/home/home_page.dart';
import '../pages/register/register_page.dart';
import '../pages/pin_page.dart';
import '../pages/register/register_info_page.dart';

import '../pages/home/overview/statement/statement_page.dart';
import '../pages/home/overview/statement/create/statement_create_page.dart';

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
    AutoRoute(page: StatementCreatePage),
  ],
)
class AppRouter extends _$AppRouter {}
