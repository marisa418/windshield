import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'routes/app_router.dart';
import 'styles/theme.dart';
import 'services/api.dart';
import 'providers/statement_provider.dart';
import 'models/statement.dart';

final apiProvider = ChangeNotifierProvider<Api>((ref) => Api());

final providerStatement =
    ChangeNotifierProvider<StatementProvider>((ref) => StatementProvider());

final providerStatementApi =
    FutureProvider.autoDispose<List<Statement>>((ref) async {
  final data = await ref.read(apiProvider).getAllStatements();
  final currentMonth = DateFormat.M().format(DateTime.now());
  ref.read(providerStatement).setSelectedMonth(int.parse(currentMonth));
  Statement temp = Statement(
      id: '',
      name: '',
      chosen: false,
      start: '',
      end: '',
      ownerId: '',
      month: 0);
  data.insert(0, temp);
  ref.read(providerStatement).setStatementList(data);
  ref.read(providerStatement).setExistedMonth(data);
  ref.read(providerStatement).setExistedStatements();
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
