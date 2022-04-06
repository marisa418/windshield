import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:windshield/components/fab_bottom_appbar.dart';
import 'package:windshield/routes/app_router.dart';
import './overview/overview_page.dart';
import './setting/setting_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  List<Widget> pageList = <Widget>[];

  @override
  void initState() {
    super.initState();
    pageList.add(const Overview());
    pageList.add(Container(color: Colors.red));
    pageList.add(Container(color: Colors.blue));
    pageList.add(const SettingPage());
  }

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        child: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            onPressed: () {
              AutoRouter.of(context).push(const DailyFlowOverviewRoute());
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
