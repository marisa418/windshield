import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'package:windshield/main.dart';
import 'package:windshield/models/financial_goal/financial_goal.dart';
import 'package:windshield/providers/financial_goal_provider.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/icon_convertor.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:windshield/utility/number_formatter.dart';
import 'package:windshield/utility/progress.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'create/financial_goal_create.dart';

final provFGoal = ChangeNotifierProvider.autoDispose<FinancialGoalProvider>(
    (ref) => FinancialGoalProvider());

final apiFGoal = FutureProvider.autoDispose<List<FGoal>>((ref) async {
  ref.watch(provFGoal.select((value) => value.needFetchAPI));
  final data = await ref.read(apiProvider).getAllGoals();
  ref.read(provFGoal).setFgList(data);
  ref.read(provFGoal).setFgType();
  return data;
});

class FinancialGoalPage extends ConsumerWidget {
  const FinancialGoalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(apiFGoal);
    return api.when(
      error: (error, stackTrace) => Text(stackTrace.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (data) {
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: <Widget>[
                const Head(),
                Expanded(
                  child: Column(
                    children: const [
                      HeadOfBody(),
                      Expanded(child: MainOfBody()),
                    ],
                  ),
                ),
                const Footer(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Head extends ConsumerWidget {
  const Head({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: MyTheme.majorBackground,
        ),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "เป้าหมายทางการเงิน",
            style: MyTheme.whiteTextTheme.headline2,
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: const Icon(Icons.date_range, color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 00, 0),
                child: Text(
                  DateFormat.yMMMEd().format(DateTime.now()),
                  style: MyTheme.whiteTextTheme.headline4,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class Footer extends ConsumerWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Container(
              width: 140,
              height: 50,
              decoration: const BoxDecoration(
                color: MyTheme.kToDark,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(Icons.arrow_left, color: Colors.white),
                  Text(
                    'ย้อนกลับ',
                    style: MyTheme.whiteTextTheme.headline3,
                  ),
                ],
              ),
            ),
            onTap: () => AutoRouter.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class HeadOfBody extends ConsumerWidget {
  const HeadOfBody({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(provFGoal.select((value) => value.pageindex));
    return Container(
      // alignment: Alignment.topLeft,
      height: 60,
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => ref.read(provFGoal).setPageindex(0),
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: pageIndex == 0
                        ? BorderSide(
                            color: MyTheme.primaryMajor,
                            width: 3.0,
                          )
                        : const BorderSide(color: Colors.white),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "เริ่มแล้ว",
                      style: MyTheme.textTheme.bodyText1,
                    ),
                    Text(
                      ref.watch(provFGoal).startedFg.length.toString(),
                      style: MyTheme.textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => ref.read(provFGoal).setPageindex(1),
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: pageIndex == 1
                        ? BorderSide(
                            color: MyTheme.primaryMajor,
                            width: 3.0,
                          )
                        : const BorderSide(color: Colors.white),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "ยังไม่เริ่ม",
                      style: MyTheme.textTheme.bodyText1,
                    ),
                    Text(
                      ref.watch(provFGoal).notStartFg.length.toString(),
                      style: MyTheme.textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => ref.read(provFGoal).setPageindex(2),
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: pageIndex == 2
                        ? BorderSide(
                            color: MyTheme.primaryMajor,
                            width: 3.0,
                          )
                        : const BorderSide(color: Colors.white),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      "สำเร็จแล้ว",
                      style: MyTheme.textTheme.bodyText1,
                    ),
                    Text(
                      ref.watch(provFGoal).finishedFg.length.toString(),
                      style: MyTheme.textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonOfBody extends ConsumerWidget {
  const ButtonOfBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0x1A5236FF),
          borderRadius: new BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        width: 372,
        height: 70,
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed: () {
            ref.read(provFGoal).setName('ชื่อเป้าหมาย');
            ref.read(provFGoal).setGoal(0);
            ref.read(provFGoal).setStart(DateTime.now());
            ref.read(provFGoal).setIcon('flag_sharp');
            ref.read(provFGoal).setGoalDate(null);
            ref.read(provFGoal).setProgPerPeriod(0);
            ref.read(provFGoal).setIsAdd(true);
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              isScrollControlled: true,
              useRootNavigator: false,
              builder: (_) => const MainOfForm(),
            );
          },
          child: Text(
            "+ เพิ่มเป้าหมายใหม่",
            style: MyTheme.whiteTextTheme.headline2!.merge(
              TextStyle(color: Color(0xFF5236FF)),
            ),
          ),
        ),
      ),
    );
  }
}

class MainOfBody extends ConsumerWidget {
  const MainOfBody({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageindex = ref.watch(provFGoal.select((value) => value.pageindex));
    if (pageindex == 0) {
      return const ListPageStart();
    } else if (pageindex == 1) {
      return const ListPageNotStart();
    } else {
      return const ListPageFinish();
    }
  }
}

class MainOfBodyFinish extends ConsumerWidget {
  const MainOfBodyFinish({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: ref.watch(provFGoal).finishedFg.length,
      itemBuilder: (context, i) {
        final fg = ref.watch(provFGoal).finishedFg[i];
        final percentPeriod = HelperProgress.getPercent(
          fg.totalProg,
          fg.goal,
        );
        return GestureDetector(
          onTap: () {
            ref.read(provFGoal).setId(fg.id);
            ref.read(provFGoal).setName(fg.name);
            ref.read(provFGoal).setGoal(fg.goal);
            ref.read(provFGoal).setStart(fg.start);
            ref.read(provFGoal).setGoalDate(fg.goalDate);
            ref.read(provFGoal).setProgPerPeriod(fg.progPerPeriod);
            ref.read(provFGoal).setPeriodTerm(fg.periodTerm);
            ref.read(provFGoal).setIsAdd(false);
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              isScrollControlled: true,
              useRootNavigator: false,
              builder: (_) => const MainOfForm(),
            );
          },
          child: Card(
            elevation: 10,
            shadowColor: Colors.black.withOpacity(.5),
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Slidable(
              endActionPane: ActionPane(
                extentRatio: 0.25,
                motion: const BehindMotion(),
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          useRootNavigator: false,
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('ท่านยืนยันที่จะลบหรือไม่?'),
                            actions: [
                              TextButton(
                                child: const Text('ยกเลิก'),
                                onPressed: () => AutoRouter.of(context).pop(),
                              ),
                              TextButton(
                                child: const Text('ยืนยัน'),
                                onPressed: () async {
                                  final res = await ref
                                      .read(apiProvider)
                                      .deleteGoal(fg.id);
                                  if (res) {
                                    ref.read(provFGoal).setNeedFetchAPI();
                                    // ref.refresh(provFGoal);
                                    AutoRouter.of(context).pop();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('ไม่สามารถลบแผนได้'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: MyTheme.expenseBackground,
                          ),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            Text('ลบ', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
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
                            child: Icon(
                              HelperIcons.getIconData(
                                fg.icon,
                              ),
                              color: Colors.white,
                              size: 30,
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
                                  HelperNumber.format(fg.goal),
                                  style: MyTheme.textTheme.headline3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(10)),
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
                              "ถึงเป้าหมายแล้ว",
                              style: MyTheme.whiteTextTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                      backgroundColor: Color.fromARGB(255, 55, 55, 55),
                      progressColor: MyTheme.primaryMajor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ListPage extends ConsumerWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ListLenth = ref.watch(provFGoal).startedFg;
    final page = ref.watch(provFGoal).pageindex;
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemCount: ListLenth.length + 1,
      itemBuilder: (context, index) {
        if (ListLenth.length == index) {
          return ButtonOfBody();
        }

        return PageStart(index);
      },
    );
  }
}

class ListPageStart extends ConsumerWidget {
  const ListPageStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ListLenth = ref.watch(provFGoal).startedFg;
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemCount: ListLenth.length + 1,
      itemBuilder: (context, index) {
        if (ListLenth.length == index) {
          return ButtonOfBody();
        }
        return PageStart(index);
      },
    );
  }
}

class ListPageNotStart extends ConsumerWidget {
  const ListPageNotStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ListLenth = ref.watch(provFGoal).notStartFg;
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemCount: ListLenth.length + 1,
      itemBuilder: (context, index) {
        if (ListLenth.length == index) {
          return const ButtonOfBody();
        }
        return PageNotStart(index);
      },
    );
  }
}

class ListPageFinish extends ConsumerWidget {
  const ListPageFinish({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ListLenth = ref.watch(provFGoal).finishedFg;
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemCount: ListLenth.length + 1,
      itemBuilder: (context, index) {
        if (ListLenth.length == index) {
          return const ButtonOfBody();
        }
        return PageFinish(index);
      },
    );
  }
}

class PageStart extends ConsumerWidget {
  const PageStart(this.index, {Key? key}) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fg = ref.watch(provFGoal).startedFg[index];
    final percentPeriod = HelperProgress.getPercent(
      fg.totalProg,
      fg.goal,
    );
    return GestureDetector(
      onTap: () {
        ref.read(provFGoal).setId(fg.id);
        ref.read(provFGoal).setName(fg.name);
        ref.read(provFGoal).setGoal(fg.goal);
        ref.read(provFGoal).setStart(fg.start);
        ref.read(provFGoal).setIcon(fg.icon);
        ref.read(provFGoal).setGoalDate(fg.goalDate);
        ref.read(provFGoal).setProgPerPeriod(fg.progPerPeriod);
        ref.read(provFGoal).setPeriodTerm(fg.periodTerm);
        ref.read(provFGoal).setIsAdd(false);
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          isScrollControlled: true,
          useRootNavigator: false,
          builder: (_) => const MainOfForm(),
        );
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.black.withOpacity(.5),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Slidable(
          endActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const BehindMotion(),
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      useRootNavigator: false,
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('ท่านยืนยันที่จะลบหรือไม่?'),
                        actions: [
                          TextButton(
                            child: const Text('ยกเลิก'),
                            onPressed: () => AutoRouter.of(context).pop(),
                          ),
                          TextButton(
                            child: const Text('ยืนยัน'),
                            onPressed: () async {
                              final res =
                                  await ref.read(apiProvider).deleteGoal(fg.id);
                              if (res) {
                                ref.read(provFGoal).setNeedFetchAPI();
                                // ref.refresh(provFGoal);
                                AutoRouter.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('ไม่สามารถลบแผนได้'),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: MyTheme.expenseBackground,
                      ),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        Text('ลบ', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
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
                    BorderRadius.vertical(bottom: Radius.circular(10)),
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
                  backgroundColor: Color.fromARGB(255, 55, 55, 55),
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

class PageNotStart extends ConsumerWidget {
  const PageNotStart(this.index, {Key? key}) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fg = ref.watch(provFGoal).notStartFg[index];
    final percentPeriod = HelperProgress.getPercent(
      fg.totalProg,
      fg.goal,
    );
    return GestureDetector(
      onTap: () {
        ref.read(provFGoal).setId(fg.id);
        ref.read(provFGoal).setName(fg.name);
        ref.read(provFGoal).setGoal(fg.goal);
        ref.read(provFGoal).setIcon(fg.icon);
        ref.read(provFGoal).setStart(fg.start);
        ref.read(provFGoal).setGoalDate(fg.goalDate);
        ref.read(provFGoal).setProgPerPeriod(fg.progPerPeriod);
        ref.read(provFGoal).setPeriodTerm(fg.periodTerm);
        ref.read(provFGoal).setIsAdd(false);
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          isScrollControlled: true,
          useRootNavigator: false,
          builder: (_) => const MainOfForm(),
        );
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.black.withOpacity(.5),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Slidable(
          endActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const BehindMotion(),
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      useRootNavigator: false,
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('ท่านยืนยันที่จะลบหรือไม่?'),
                        actions: [
                          TextButton(
                            child: const Text('ยกเลิก'),
                            onPressed: () => AutoRouter.of(context).pop(),
                          ),
                          TextButton(
                            child: const Text('ยืนยัน'),
                            onPressed: () async {
                              final res =
                                  await ref.read(apiProvider).deleteGoal(fg.id);
                              if (res) {
                                ref.read(provFGoal).setNeedFetchAPI();
                                // ref.refresh(provFGoal);
                                AutoRouter.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('ไม่สามารถลบแผนได้'),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: MyTheme.expenseBackground,
                      ),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        Text('ลบ', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
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
                          color: Color(0xFFD1D0D0),
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
                            Text(
                              "ยังไม่เริ่ม",
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
                              style: MyTheme.textTheme.headline4,
                            ),
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
                    BorderRadius.vertical(bottom: Radius.circular(10)),
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
                  backgroundColor: Color.fromARGB(255, 55, 55, 55),
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

class PageFinish extends ConsumerWidget {
  const PageFinish(this.index, {Key? key}) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fg = ref.watch(provFGoal).finishedFg[index];
    final percentPeriod = HelperProgress.getPercent(
      fg.totalProg,
      fg.goal,
    );
    return GestureDetector(
      onTap: () {
        ref.read(provFGoal).setId(fg.id);
        ref.read(provFGoal).setName(fg.name);
        ref.read(provFGoal).setGoal(fg.goal);
        ref.read(provFGoal).setIcon(fg.icon);
        ref.read(provFGoal).setStart(fg.start);
        ref.read(provFGoal).setGoalDate(fg.goalDate);
        ref.read(provFGoal).setProgPerPeriod(fg.progPerPeriod);
        ref.read(provFGoal).setPeriodTerm(fg.periodTerm);
        ref.read(provFGoal).setIsAdd(false);
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          isScrollControlled: true,
          useRootNavigator: false,
          builder: (_) => const MainOfForm(),
        );
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.black.withOpacity(.5),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Slidable(
          endActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const BehindMotion(),
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      useRootNavigator: false,
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('ท่านยืนยันที่จะลบหรือไม่?'),
                        actions: [
                          TextButton(
                            child: const Text('ยกเลิก'),
                            onPressed: () => AutoRouter.of(context).pop(),
                          ),
                          TextButton(
                            child: const Text('ยืนยัน'),
                            onPressed: () async {
                              final res =
                                  await ref.read(apiProvider).deleteGoal(fg.id);
                              if (res) {
                                ref.read(provFGoal).setNeedFetchAPI();
                                // ref.refresh(provFGoal);
                                AutoRouter.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('ไม่สามารถลบแผนได้'),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: MyTheme.expenseBackground,
                      ),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        Text('ลบ', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
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
                        child: Icon(
                          IconsFinance.getIconData(
                            fg.icon,
                          ),
                          color: Colors.white,
                          size: 30,
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
                              HelperNumber.format(fg.goal),
                              style: MyTheme.textTheme.headline4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(10)),
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
                          "ถึงเป้าหมายแล้ว",
                          style: MyTheme.whiteTextTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                  backgroundColor: Color.fromARGB(255, 55, 55, 55),
                  progressColor: MyTheme.primaryMajor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class TermsService extends StatefulWidget {
//   @override
//   TermsofService createState() => TermsofService();
// }

// class TermsofService extends State<TermsService> {
//   String data = '';
//   fetchFileData() async {
//     String responseText;
//     responseText = await rootBundle.loadString('assets/text1.txt');
//     setState(() {
//       data = responseText;
//     });
//   }

//   @override
//   void initState() {
//     fetchFileData();
//     super.initState();
//   }

//   Widget build(BuildContext context) {
//     return Container(
//       child: Text(data),
//     );
//   }
// }
