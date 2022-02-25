import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../pages/home/home_page.dart';
import '../pages/login_page.dart';
import '../pages/register/register_page.dart';
import '../pages/pin_page.dart';
import '../pages/register/register_info_page.dart';

import '../pages/home/overview/statement/statement_page.dart';
import '../pages/home/overview/statement/statement_create_page.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: MyHomePage),
    AutoRoute(page: LoginPage, initial: true),
    AutoRoute(page: RegisterPage),
    AutoRoute(page: PinPage),
    AutoRoute(page: RegisterInfoPage),
    // AutoRoute(
    //   page: StatementPage,
    //   path: '/statement',
    //   children: [
    //     AutoRoute(page: StatementCreatePage, path: 'create'),
    //   ],
    // ),
    AutoRoute(page: StatementPage, path: '/statement'),
    AutoRoute(page: StatementCreatePage, path: '/statement/create'),
  ],
)
class AppRouter extends _$AppRouter {}
