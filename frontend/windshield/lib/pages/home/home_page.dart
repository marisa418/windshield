import 'package:auto_route/auto_route.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:windshield/components/fab_bottom_appbar.dart';
import 'package:windshield/main.dart';
import 'package:windshield/providers/home_provider.dart';
import 'package:windshield/routes/app_router.dart';

import 'overview/overview_page.dart';
import 'analysis/analysis_page.dart';
import 'article/article_page.dart';
import 'setting/setting_page.dart';

final provHome =
    ChangeNotifierProvider.autoDispose<HomeProvider>((ref) => HomeProvider());

final apiHome = FutureProvider.autoDispose<void>((ref) async {
  ref.watch(provHome.select((value) => value.needFetchAPI));
  final now = DateTime.now();
  final data = await ref.read(apiProvider).getAllNotEndYetStatements(now);
  ref.read(provHome).setStatementList(data);
  if (data.isNotEmpty) {
    final data2 = await ref
        .read(apiProvider)
        .getRangeDailyFlowSheet(data[0].start, data[0].end);
    ref.read(provHome).setFlowSheetList(data2);
  }
  return;
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  List<Widget> _pageList = <Widget>[];

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().actionStream.listen((receivedNotification) {
      AutoRouter.of(context).push(const DailyFlowOverviewRoute());
    });
    _pageList.add(const Overview());
    _pageList.add(const Analysis());
    _pageList.add(const ArticlePage());
    _pageList.add(const SettingPage());
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    super.dispose();
  }

  void _updateIndex(int index) {
    // if (index == 2) ref.refresh(provArticle);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(provHome.select((e) => e.needFetchAPI));
    final api = ref.watch(apiHome);
    return api.when(
      error: (error, stackTrace) => Text(stackTrace.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (_) {
        return SafeArea(
          child: Scaffold(
            body: IndexedStack(
              index: _selectedIndex,
              children: _pageList,
            ),
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
          ),
        );
      },
    );
  }
}
