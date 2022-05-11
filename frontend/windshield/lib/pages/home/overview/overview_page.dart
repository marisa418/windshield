import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:windshield/main.dart';
import 'package:windshield/providers/financial_goal_provider.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/pages/home/analysis/stat/stat_model.dart';
import 'package:windshield/providers/home_provider.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/icon_convertor.dart';
import 'package:windshield/utility/number_formatter.dart';
import 'package:windshield/utility/progress.dart';

import 'overview_comp/inc_exp.dart';

final provHome =
    ChangeNotifierProvider.autoDispose<HomeProvider>((ref) => HomeProvider());

final provFGoal = ChangeNotifierProvider.autoDispose<FinancialGoalProvider>(
    (ref) => FinancialGoalProvider());

final apiHomeStat = FutureProvider.autoDispose<Stat>((ref) async {
  ref.watch(provHome.select((value) => value.needFetchAPI));
  ref.watch(provFGoal.select((value) => value.needFetchAPI));
  //inc exp
  final now = DateTime.now();
  final data = await ref.read(apiProvider).getAllNotEndYetStatements(now);
  ref.read(provHome).setStatementList(data);
  if (data.isNotEmpty) {
    final data2 = await ref
        .read(apiProvider)
        .getRangeDailyFlowSheet(data[0].start, data[0].end);
    ref.read(provHome).setFlowSheetList(data2);
  }
  //fgoal
  final goals = await ref.read(apiProvider).getAllGoals();
  ref.read(provFGoal).setFgList(goals);
  ref.read(provFGoal).setFgType();
  //stat
  final stat = await ref.read(apiProvider).analStat();
  return stat;
});

final apiPoint = FutureProvider.autoDispose<int>((ref) async {
  const _storage = FlutterSecureStorage();
  final newPoint = ref.read(apiProvider).user?.points ?? 0;
  final oldPoint = int.parse(await _storage.read(key: 'points') ?? '0');
  if (newPoint > oldPoint) {
    await _storage.write(key: 'points', value: newPoint.toString());
    return newPoint - oldPoint;
  }
  return 0;
});

// final apiFGoal = FutureProvider.autoDispose<List<FGoal>>((ref) async {
//   ref.watch(provFGoal.select((value) => value.needFetchAPI));
//   final data = await ref.read(apiProvider).getAllGoals();
//   ref.read(provFGoal).setFgList(data);
//   ref.read(provFGoal).setFgType();
//   return data;
// });

class Overview extends ConsumerWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(apiHomeStat);
    final point = ref.watch(apiPoint);
    return home.when(
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (stat) => point.when(
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (pointDiff) {
          WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
            if (pointDiff != 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('คุณได้รับแต้มเพิ่ม $pointDiff แต้ม'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          });
          final Color color = getColor(stat.financialHealth);
          final String string = getString(stat.financialHealth);
          return RefreshIndicator(
            onRefresh: () async {
              ref.refresh(provHome);
              ref.refresh(provFGoal);
              ref.refresh(apiHomeStat);
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: MyTheme.majorBackground,
                      ),
                    ),
                    height: 210,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.shieldAlt,
                                color: Colors.white,
                              ),
                              Text(
                                DateFormat('E d MMM y').format(DateTime.now()),
                                style: MyTheme.whiteTextTheme.headline4,
                              ),
                              const FaIcon(
                                FontAwesomeIcons.user,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 225,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(100),
                                  topRight: Radius.circular(100),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    string,
                                    style: MyTheme.textTheme.headline1!.merge(
                                      TextStyle(color: color),
                                    ),
                                  ),
                                  if (string == '?')
                                    Text(
                                      'ไม่มีข้อมูล',
                                      style: MyTheme.textTheme.headline3!.merge(
                                        TextStyle(color: color),
                                      ),
                                    )
                                  else
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                '${stat.financialHealth!.floor()}',
                                            style: MyTheme.textTheme.headline3!
                                                .merge(
                                              TextStyle(color: color),
                                            ),
                                          ),
                                          TextSpan(
                                            text: '/100',
                                            style: MyTheme.textTheme.headline3!
                                                .merge(
                                              const TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Text(
                                    'สุขภาพทางการเงิน',
                                    style: MyTheme.textTheme.headline4,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const IncExp(),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    AutoRouter.of(context)
                                        .push(const StatementRoute());
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    child: FaIcon(
                                      FontAwesomeIcons.chartPie,
                                      size: 30,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: MyTheme.kToDark[50],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'แผนงบการเงิน',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    AutoRouter.of(context)
                                        .push(const BalanceSheetRoute());
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    child: FaIcon(
                                      FontAwesomeIcons.balanceScale,
                                      size: 30,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: MyTheme.kToDark[50],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'งบดุลการเงิน',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    AutoRouter.of(context)
                                        .push(const FinancialGoalRoute());
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    child: FaIcon(
                                      FontAwesomeIcons.solidFlag,
                                      size: 30,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: MyTheme.kToDark[50],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'เป้าหมาย\nทางการเงิน',
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    AutoRouter.of(context)
                                        .push(const CategoryRoute());
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    child: FaIcon(
                                      FontAwesomeIcons.percentage,
                                      size: 30,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: MyTheme.kToDark[50],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'จัดการ\nหมวดหมู่',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "เป้าหมายของคุณ",
                            style: MyTheme.textTheme.headline4,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                              width: 150,
                              height: 30,
                              decoration: const BoxDecoration(
                                color: Color(0x1A5236FF),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(32),
                                ),
                              ),
                              child: FlatButton(
                                child: Text(
                                  "ดูทั้งหมด",
                                  style:
                                      MyTheme.whiteTextTheme.headline4!.merge(
                                    const TextStyle(color: Color(0xFF5236FF)),
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                onPressed: () {
                                  AutoRouter.of(context)
                                      .push(const FinancialGoalRoute());
                                },
                              ),
                            )),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: FinancialGoalList(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String getString(double? value) {
    if (value != null) {
      if (value >= 0 && value < 25) return 'แย่';
      if (value >= 25 && value < 50) return 'พอใช้';
      if (value >= 50 && value < 75) return 'ปานกลาง';
      return 'ดี';
    }
    return '?';
  }

  Color getColor(double? value) {
    if (value != null) {
      if (value >= 0 && value < 25) return MyTheme.negativeMajor;
      if (value >= 25 && value < 50) return MyTheme.expenseConsist[0];
      if (value >= 50 && value < 75) return MyTheme.assetPersonal[0];
      return MyTheme.positiveMajor;
    }
    return Colors.black;
  }
}

class FinancialGoalList extends ConsumerWidget {
  const FinancialGoalList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listLength = ref.watch(provFGoal).startedFg;
    return Container(
      padding: const EdgeInsets.only(top: 10),
      height: listLength.isEmpty
          ? 90
          : listLength.length == 1
              ? 150
              : listLength.length == 2
                  ? 300
                  : 450,
      child: () {
        if (listLength.length < 3 && listLength.isNotEmpty) {
          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            itemCount: listLength.length,
            itemBuilder: (context, index) {
              return ListPageStartAtHome(index);
            },
          );
        }
        if ((listLength.isEmpty)) {
          return Container(
            width: 400,
            height: 70,
            decoration: const BoxDecoration(
              color: Color(0x1A5236FF),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                "+ เพิ่มเป้าหมายใหม่",
                style: MyTheme.whiteTextTheme.headline2!.merge(
                  const TextStyle(color: Color(0xFF5236FF)),
                ),
              ),
              onPressed: () {
                AutoRouter.of(context).push(const FinancialGoalRoute());
              },
            ),
          );
        }
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          itemCount: 3,
          itemBuilder: (context, index) {
            return ListPageStartAtHome(index);
          },
        );
      }(),
    );
  }
}

class ListPageStartAtHome extends ConsumerWidget {
  const ListPageStartAtHome(this.index, {Key? key}) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fg = ref.watch(provFGoal).startedFg[index];
    final percentPeriod = HelperProgress.getPercent(
      fg.totalProg,
      fg.goal,
    );
    return GestureDetector(
      child: Card(
        elevation: 10,
        shadowColor: Colors.black.withOpacity(.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Slidable(
          child: Column(
            children: [
              Container(
                height: 100,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 25,
                      child: Container(
                        height: 75,
                        width: 75,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: MyTheme.primaryMajor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconsFinance.getIconData(
                                fg.icon,
                              ),
                              color: Colors.white,
                              size: 30,
                            ),
                            AutoSizeText(
                              HelperNumber.format(fg.progPerPeriod),
                              maxLines: 1,
                              minFontSize: 0,
                              style: MyTheme.whiteTextTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 53,
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              fg.name,
                              maxLines: 1,
                              style: MyTheme.textTheme.headline3,
                            ),
                            Text(
                                HelperNumber.format(fg.totalProg) +
                                    "/" +
                                    HelperNumber.format(fg.goal),
                                style: MyTheme.textTheme.headline4),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 22,
                      fit: FlexFit.tight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AutoSizeText(
                            fg.goalDate == null
                                ? ""
                                : fg.goalDate!.difference(DateTime.now()).inDays + 1 >
                                        365
                                    ? "ภายใน " +
                                        ((fg.goalDate!.difference(DateTime.now()).inDays + 1) / 365)
                                            .toStringAsFixed(0) +
                                        " ปี"
                                    : fg.goalDate!.difference(DateTime.now()).inDays + 1 > 30 &&
                                            fg.goalDate!.difference(DateTime.now()).inDays + 1 <
                                                365
                                        ? "ภายใน " +
                                            ((fg.goalDate!.difference(DateTime.now()).inDays + 1) / 30)
                                                .toStringAsFixed(0) +
                                            " เดือน"
                                        : fg.goalDate!.difference(DateTime.now()).inDays + 1 > 6 &&
                                                fg.goalDate!
                                                            .difference(
                                                                DateTime.now())
                                                            .inDays +
                                                        1 <
                                                    30 &&
                                                fg.goalDate!
                                                            .difference(
                                                                DateTime.now())
                                                            .inDays +
                                                        1 <
                                                    365
                                            ? "ภายใน " +
                                                ((fg.goalDate!.difference(DateTime.now()).inDays + 1) / 7)
                                                    .toStringAsFixed(0) +
                                                " สัปดาห์"
                                            : "ภายใน ${fg.goalDate!.difference(DateTime.now()).inDays + 1} วัน",
                            style: const TextStyle(color: Colors.red),
                            maxLines: 1,
                            minFontSize: 0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(10)),
                child: LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  animation: true,
                  lineHeight: 25.0,
                  animationDuration: 2500,
                  percent: percentPeriod,
                  center: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${HelperNumber.format(percentPeriod * 100)} %",
                          style: MyTheme.whiteTextTheme.bodyText1,
                        ),
                        Text(
                          "เริ่มต้น " + DateFormat.yMMMMd().format(fg.start),
                          style: MyTheme.whiteTextTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                  backgroundColor: const Color.fromARGB(255, 55, 55, 55),
                  progressColor: MyTheme.primaryMajor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
