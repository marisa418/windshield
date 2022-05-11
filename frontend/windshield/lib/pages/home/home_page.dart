import 'package:auto_route/auto_route.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:windshield/components/fab_bottom_appbar.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/styles/theme.dart';

import 'overview/overview_page.dart';
import 'analysis/analysis_page.dart';
import 'article/article_page.dart';
import 'setting/setting_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pageList = <Widget>[
    const Overview(key: PageStorageKey(0)),
    const Analysis(key: PageStorageKey(1)),
    const ArticlePage(key: PageStorageKey(2)),
    const SettingPage(key: PageStorageKey(3)),
  ];
  final _bucket = PageStorageBucket();
  @override
  void initState() {
    super.initState();
    try {
      AwesomeNotifications().actionStream.listen(
        (receivedNotification) {
          AutoRouter.of(context).push(const DailyFlowOverviewRoute());
        },
      );
    } catch (e) {
      print('CAN ONLY LISTEN TO STREAM ONLY ONCE');
    }
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    super.dispose();
  }

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(provHome.select((e) => e.needFetchAPI));

    return WillPopScope(
      onWillPop: () async => await showDialog(
        useRootNavigator: false,
        context: context,
        builder: (_) => AlertDialog(
          title: Text('ออกจากแอป?', style: MyTheme.textTheme.headline3),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // passing false
              child: Text(
                'ไม่',
                style: MyTheme.textTheme.headline4!.merge(
                  const TextStyle(color: Colors.grey),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // passing true
              child: Text('ใช่', style: MyTheme.textTheme.headline4),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          // body: IndexedStack(
          //   index: _selectedIndex,
          //   children: _pageList,
          // ),
          body: PageStorage(
            bucket: _bucket,
            child: _pageList[_selectedIndex],
          ),
          drawer: const Drawer(
            child: FilterDialog(),
          ),
          onDrawerChanged: (isOpen) => isOpen ? null : ref.refresh(apiArticle),
          bottomNavigationBar: FABBottomAppBar(
            onTabSelected: _updateIndex,
            centerItemText: 'บัญชีรายรับ-รายจ่าย',
            items: [
              FABBottomAppBarItem(iconData: Icons.home, text: 'ภาพรวม'),
              FABBottomAppBarItem(
                  iconData: Icons.graphic_eq, text: 'วิเคราะห์ผล'),
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
        ),
      ),
    );
  }
}
