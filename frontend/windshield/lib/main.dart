import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'routes/app_router.dart';
import 'styles/theme.dart';
import 'services/api.dart';

import 'models/daily_flow/category.dart';
import 'providers/daily_flow_provider.dart';
import 'providers/balance_sheet_provider.dart';

final apiProvider = ChangeNotifierProvider<Api>((ref) => Api());

final provDFlow = ChangeNotifierProvider.autoDispose<DailyFlowProvider>(
    (ref) => DailyFlowProvider());

final apiDFlow = FutureProvider.autoDispose<List<DFlowCategory>>((ref) async {
  ref.watch(provDFlow.select((value) => value.needFetchAPI));
  final now = DateTime.now();
  final id = await ref.read(apiProvider).getTodayDFId();
  final data = await ref.read(apiProvider).getAllCategoriesWithBudgetFlows(now);
  ref.read(provDFlow).setDfId(id);
  ref.read(provDFlow).setCatList(data);
  ref.read(provDFlow).setCatType();
  return data;
});

final provBSheet = ChangeNotifierProvider.autoDispose<BalanceSheetProvider>(
    (ref) => BalanceSheetProvider());

void main() {
  Intl.defaultLocale = 'th';
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  MyApp({Key? key}) : super(key: key);
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(apiProvider.select((e) => e.isLoggedIn));
    return MaterialApp.router(
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
