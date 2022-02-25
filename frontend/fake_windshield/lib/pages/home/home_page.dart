import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';
import '../../components/fab_bottom_appbar.dart';
import 'overview/overview_page.dart';

TextStyle get _textStyle {
  return GoogleFonts.kanit(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const Home(),
    );
  }
}

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  int _selectedIndex = 0;
  List<Widget> pageList = <Widget>[];

  @override
  void initState() {
    super.initState();
    pageList.add(const Overview());
    pageList.add(Container(color: Colors.red));
    pageList.add(Container(color: Colors.blue));
    pageList.add(Container(color: Colors.purple));
  }

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String title;
    switch (_selectedIndex) {
      case 0:
        title = 'Overview';
        break;
      case 1:
        title = 'Analysis';
        break;
      case 2:
        title = 'Knowledge';
        break;
      case 3:
        title = 'Settings';
        break;
      default:
        title = 'Overview';
        break;
    }
    final api = ref.watch(apiProvider);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pageList,
      ),
      bottomNavigationBar: FABBottomAppBar(
        onTabSelected: _updateIndex,
        centerItemText: 'บัญชีรายรับ\nรายจ่าย',
        items: [
          FABBottomAppBarItem(iconData: Icons.home, text: 'ภาพรวม'),
          FABBottomAppBarItem(iconData: Icons.graphic_eq, text: 'วิเคราะห์ผล'),
          FABBottomAppBarItem(iconData: Icons.menu_book, text: 'ความรู้'),
          FABBottomAppBarItem(iconData: Icons.settings, text: 'ตั้งค่า'),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 5, bottom: 20),
        // padding: EdgeInsets.all(10),
        child: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            onPressed: () {
              // ref.read(apiProvider).login();
            },
            tooltip: 'Income Expense',
            child: const Icon(Icons.book),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}



// class Home extends ConsumerWidget {
//   const Home({Key? key}) : super(key: key);
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
//       bottomNavigationBar: BottomAppBar(
//         shape: const CircularNotchedRectangle(),
//         child: Container(height: 50.0),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // ref.read(apiProvider).login();
//         },
//         tooltip: 'Income Expense',
//         child: const Icon(Icons.book),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//     );
//   }
// }
