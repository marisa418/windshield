import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'routes/app_router.dart';
import 'styles/theme.dart';
import 'services/api.dart';
import 'providers/statement_provider.dart';
import 'models/statement.dart';
import 'providers/category_provider.dart';
import 'models/category.dart';

final apiProvider = ChangeNotifierProvider<Api>((ref) => Api());

final providerStatement =
    ChangeNotifierProvider.autoDispose<StatementProvider>((ref) {
  return StatementProvider();
});

final providerStatementApi =
    FutureProvider.autoDispose<List<Statement>>((ref) async {
  ref.watch(providerStatement.select((value) => value.needUpdated));
  final data = await ref.read(apiProvider).getAllStatements();
  final currentMonth = DateTime.now().month;
  final currentYear = DateTime.now().year;
  // ref.read(providerStatement).setSelectedMonth(int.parse(currentMonth));
  // ref.read(providerStatement).setSelectedMonth(currentMonth);
  Statement temp =
      Statement(id: '', name: '', chosen: false, start: '', end: '', month: 0);
  data.insert(0, temp);
  ref.read(providerStatement).setStatementList(data);
  ref.read(providerStatement).setExistedMonth();
  for (var i = 1; i < data.length; i++) {
    final dataDate = DateFormat('y-MM-dd').parse(data[i].start);
    if (currentYear == dataDate.year) {
      if (currentMonth <= data[i].month) {
        final month = ref
            .read(providerStatement)
            .existedMonth
            .indexWhere((e) => e == data[i].month);
        ref
            .read(providerStatement)
            .setStatementMonthIndex(month == -1 ? 0 : month);
        break;
      }
    }
  }
  ref.read(providerStatement).setStatementsInMonth();
  return data;
});

final providerCategory =
    ChangeNotifierProvider.autoDispose<CategoryProvider>((ref) {
  return CategoryProvider();
});

final providerCategoryApi =
    FutureProvider.autoDispose<List<Category>>((ref) async {
  final data = await ref.read(apiProvider).getAllCategories();
  await ref.read(apiProvider).getBalanceSheet();
  ref.read(providerCategory).setCategoryList(data);
  ref.read(providerCategory).setCategoryTypes();
  ref.read(providerCategory).setCategoryTypeTabs();
  return data;
});

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
