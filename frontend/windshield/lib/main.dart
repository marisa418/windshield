import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'routes/app_router.dart';
import 'styles/theme.dart';
import 'services/api.dart';

import 'providers/balance_sheet_provider.dart';

final apiProvider = ChangeNotifierProvider<Api>((ref) => Api());

final provBSheet = ChangeNotifierProvider.autoDispose<BalanceSheetProvider>(
    (ref) => BalanceSheetProvider());

void main() {
  Intl.defaultLocale = 'th';
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'daiy_flow_channel',
        channelName: 'Daily Flow',
        defaultColor: MyTheme.primaryMajor,
        // locked: true,
        channelShowBadge: true,
        importance: NotificationImportance.High,
        channelDescription: 'Notify users to input their daily flow.',
      ),
    ],
    debug: true,
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  MyApp({Key? key}) : super(key: key);
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(apiProvider.select((e) => e.isLoggedIn));
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: AutoRouterDelegate.declarative(
        _appRouter,
        routes: (_) => [
          if (isLoggedIn) const EmptyRouterRoute() else const AppStackRoute(),
        ],
      ),
      routeInformationParser: _appRouter.defaultRouteParser(),
      title: 'Windshield',
      theme: MyTheme.myTheme(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('th', ''),
        Locale('en', ''),
      ],
      locale: const Locale('th', ''),
    );
  }
}
