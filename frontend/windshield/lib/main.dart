import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'routes/app_router.dart';
import 'styles/theme.dart';
import 'services/api.dart';
import 'providers/statement_provider.dart';
import 'models/statement/statement.dart';
import 'providers/budget_provider.dart';
import 'models/statement/category.dart';

final apiProvider = ChangeNotifierProvider<Api>((ref) => Api());

final provStatement = ChangeNotifierProvider.autoDispose<StatementProvider>(
    (ref) => StatementProvider());

final apiStatement =
    FutureProvider.autoDispose<List<StmntStatement>>((ref) async {
  ref.watch(provStatement.select((value) => value.needFetchAPI));
  final now = DateTime.now();
  final data = await ref.read(apiProvider).getAllNotEndYetStatements(now);
  ref.read(provStatement).setStatementList(data);
  if (data.isNotEmpty) {
    ref.read(provStatement).setStmntActiveList();
    ref.read(provStatement).setStmntDateChipList();
    ref.read(provStatement).setStmntDateChipIdx(0);
    ref.read(provStatement).setStmntDateList();
  }
  return data;
});

final provBudget = ChangeNotifierProvider.autoDispose<BudgetProvider>(
    (ref) => BudgetProvider());

// final providerCategoryApi =
//     FutureProvider.autoDispose<List<Category>>((ref) async {
//   final data = await ref.read(apiProvider).getAllCategories();
//   await ref.read(apiProvider).getBalanceSheet();
//   ref.read(providerCategory).setCategoryList(data);
//   ref.read(providerCategory).setCategoryTypes();
//   ref.read(providerCategory).setCategoryTypeTabs();
//   return data;
// });

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _appRouter.defaultRouteParser(),
      routerDelegate: _appRouter.delegate(),
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
      locale: const Locale('th'),
    );
  }
}
