import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'routes/app_router.dart';
import 'core/services/api.dart';
import 'core/statement/statement.dart';
import 'core/statement/statementCreate.dart';

import 'models/statement.dart';
import 'models/category.dart';

final apiProvider = ChangeNotifierProvider<Api>((ref) => Api());

final statementProvider =
    ChangeNotifierProvider<StatementProvider>((ref) => StatementProvider());

final statementApiProvider =
    FutureProvider.autoDispose<List<Statement>>((ref) async {
  ref.onDispose(() => print('DISPOSED'));
  print('STATEMENT API PROVIDER CALLED');
  final data = await ref.read(apiProvider).getAllStatements();
  final empty = Statement(
      id: '',
      name: '',
      chosen: false,
      start: '',
      end: '',
      ownerId: '',
      month: 0);
  data.insert(0, empty);
  if (data.length != 1) {
    ref.read(statementProvider).setSelectedMonth(data[1].month);
  } else {
    ref.read(statementProvider).setSelectedMonth(0);
  }

  ref.read(statementProvider).setStatementList(data);
  return data;
});

final statementCreateProvider =
    ChangeNotifierProvider.autoDispose<StatementCreateProvider>(
        (ref) => StatementCreateProvider());

final categoryApiProvider =
    FutureProvider.autoDispose<List<Category>>((ref) async {
  final data = await ref.read(apiProvider).getAllCategories();
  ref.read(statementCreateProvider).setCategories(data);
  return data;
});

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class Palette {
  static const MaterialColor kToDark = MaterialColor(
    0xff5236ff,
    <int, Color>{
      50: Color(0xffefe8ff),
      100: Color(0xffd3c6fe),
      200: Color(0xffb59fff),
      300: Color(0xff9376ff),
      400: Color(0xff5136ff),
      500: Color(0xff5236ff),
      600: Color(0xff4032f8),
      700: Color(0xff1c2af0),
      800: Color(0xff0024ea),
      900: Color(0xff0016e4),
    },
  );
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
      theme: ThemeData(
        primarySwatch: Palette.kToDark,
        brightness: Brightness.light,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 82, 84, 255),
        ),
        textTheme: TextTheme(
          headline1:
              GoogleFonts.kanit(fontSize: 36, fontWeight: FontWeight.w500),
          headline2:
              GoogleFonts.kanit(fontSize: 28, fontWeight: FontWeight.w500),
          bodyText1:
              GoogleFonts.kanit(fontSize: 14, fontWeight: FontWeight.w500),
          bodyText2:
              GoogleFonts.kanit(fontSize: 12, fontWeight: FontWeight.w500),
          // bodyText3: GoogleFonts.kanit(fontSize: 9, fontWeight: FontWeight.w500),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('th'),
        Locale('en'),
      ],
      locale: const Locale('th'),
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Windshield',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const User(),
//     );
//   }
// }

// class User extends ConsumerWidget {
//   const User({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final api = ref.watch(apiProvider);
//     return Scaffold(
//       body: Center(
//         child: Text(
//           'Hello: ${api.username}',
//           style: Theme.of(context).textTheme.headline4,
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           ref.read(apiProvider).login();
//         },
//       ),
//     );
//   }
// }
