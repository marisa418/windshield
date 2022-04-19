import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:windshield/main.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/models/statement/budget.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/utility/number_formatter.dart';
import '../statement_page.dart';

class StatementInfoPage extends ConsumerWidget {
  const StatementInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Header(),
            const StatementList(),
            Container(
              color: Colors.transparent,
              height: 75,
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  label: Text(
                    'ย้อนกลับ  ',
                    style: MyTheme.whiteTextTheme.headline3,
                  ),
                  icon: const Icon(
                    Icons.arrow_left,
                    color: Colors.white,
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: MyTheme.primaryMajor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),
                  onPressed: () => AutoRouter.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends ConsumerWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: MyTheme.majorBackground,
        ),
      ),
      height: 190,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('แผนงบการเงินของคุณ', style: MyTheme.whiteTextTheme.headline3),
            Wrap(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white),
                Text(
                  DateFormat(' E d MMM y').format(DateTime.now()),
                  style: MyTheme.whiteTextTheme.headline4,
                ),
              ],
            ),
            const SizedBox(height: 10),
            const DateChipList(),
          ],
        ),
      ),
    );
  }
}

class DateChipList extends ConsumerWidget {
  const DateChipList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chips = ref.watch(provStatement).stmntDateChipList;
    final idx = ref.watch(provStatement).stmntDateChipIdx;
    final stmnt = ref.watch(provStatement).stmntActiveList;
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (_, index) => const SizedBox(width: 10),
        scrollDirection: Axis.horizontal,
        itemCount: chips.length + 1,
        itemBuilder: (_, index) {
          if (index == 0) {
            return GestureDetector(
              onTap: () {
                DateTime nextDayOfLastPlan = DateUtils.dateOnly(DateTime.now());
                if (stmnt.isNotEmpty) {
                  nextDayOfLastPlan =
                      stmnt.last.end.add(const Duration(days: 1));
                }
                ref.read(provStatement).setAvailableDate(
                      nextDayOfLastPlan,
                      nextDayOfLastPlan.add(const Duration(days: 34)),
                    );
                ref.read(provStatement).setDate(
                      nextDayOfLastPlan,
                      nextDayOfLastPlan,
                    );
                ref.read(provStatement).setStmntCreatePageIdx(0);
                AutoRouter.of(context).push(const StatementCreateRoute());
              },
              child: Container(
                width: 65,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: const BorderRadius.all(Radius.circular(35)),
                ),
                child: Center(
                  child: Text('+', style: MyTheme.whiteTextTheme.headline2),
                ),
              ),
            );
          }
          return GestureDetector(
            onTap: () {
              ref.read(provStatement).setStmntDateChipIdx(index - 1);
              ref.read(provStatement).setStmntDateList();
            },
            child: Container(
              width: 65,
              decoration: BoxDecoration(
                color: idx == index - 1
                    ? Colors.white
                    : Colors.white.withOpacity(0.3),
                borderRadius: const BorderRadius.all(Radius.circular(35)),
              ),
              child: Center(
                child: Text(
                  DateFormat('d MMM')
                      .format(DateTime.parse(chips[index - 1].split('|')[0])),
                  style: idx == index - 1
                      ? MyTheme.textTheme.headline4
                      : MyTheme.whiteTextTheme.headline4,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class StatementList extends ConsumerWidget {
  const StatementList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stmntListLength =
        ref.watch(provStatement.select((e) => e.stmntDateList.length));
    final date = ref.watch(provStatement.select((e) => e.stmntDateList[0].end));
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'แผนงบการเงินที่ใช้อยู่',
                        style: MyTheme.textTheme.headline4,
                      ),
                      Text(
                        'สิ้นสุดงบ ${DateFormat.yMMMd().format(date)}',
                        style: MyTheme.textTheme.headline4!.merge(
                          TextStyle(color: MyTheme.primaryMajor),
                        ),
                      ),
                    ],
                  ),
                  const Statement(index: 0),
                  const SizedBox(height: 20),
                ],
              ),
              if (stmntListLength != 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'แผนงบการเงินอื่นๆ',
                      style: MyTheme.textTheme.headline4,
                    ),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: stmntListLength - 1,
                      itemBuilder: (_, index) {
                        return Statement(index: index + 1);
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              GestureDetector(
                onTap: () async {
                  final stmntList = ref.read(provStatement).stmntDateList;
                  ref.read(provStatement).setAvailableDate(
                        stmntList[0].start,
                        stmntList[0].end,
                      );
                  ref.read(provStatement).setDate(
                        stmntList[0].start,
                        stmntList[0].end,
                      );
                  final id = await ref.read(apiProvider).createStatement(
                        'แผนการเงิน',
                        ref.read(provStatement).start,
                        ref.read(provStatement).end,
                      );
                  ref.read(provStatement).setStmntCreatePageIdx(1);
                  ref.read(provStatement).setStmntId(id);
                  ref.read(provStatement).setStmntName('แผนงบการเงิน');
                  AutoRouter.of(context).push(const StatementCreateRoute());
                  ref.read(provStatement).setNeedFetchAPI();
                },
                child: Container(
                  height: 70,
                  // width: double.infinity,
                  decoration: BoxDecoration(
                    color: MyTheme.primaryMinor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '+ เพิ่มแผนใหม่ของเดือนนี้',
                      style: MyTheme.textTheme.headline3!.merge(
                        TextStyle(
                          color: MyTheme.primaryMajor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Statement extends ConsumerWidget {
  const Statement({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stmntList = ref.watch(provStatement.select((e) => e.stmntDateList));
    final sum = _getTotal(stmntList[index].budgets);
    final perc = _getPerc(sum);
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: GestureDetector(
        onTap: () {
          final provStmnt = ref.read(provStatement);
          provStmnt.setStmntId(stmntList[index].id);
          provStmnt.setStmntName(stmntList[index].name);
          provStmnt.setStmntBudgets(stmntList[index].budgets);
          provStmnt.setDate(
            stmntList[index].start,
            stmntList[index].end,
          );
          provStmnt.setEditSpecial(false);
          if (provStmnt.stmntId == provStmnt.stmntActiveList[0].id) {
            provStmnt.setEditSpecial(true);
          }
          AutoRouter.of(context).push(const StatementEditRoute());
        },
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: MyTheme.dropShadow,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Slidable(
            enabled: index == 0 ? false : true,
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
                                    .deleteStatement(stmntList[index].id);
                                if (res) {
                                  ref.read(provStatement).setNeedFetchAPI();
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stmntList[index].name,
                        style: MyTheme.textTheme.headline4,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (stmntList[index].chosen) return;
                          final id = stmntList[index].id;
                          await ref.read(apiProvider).updateStatementActive(id);
                          ref.read(provStatement).setNeedFetchAPI();
                        },
                        child: stmntList[index].chosen
                            ? Icon(Icons.check_circle,
                                color: MyTheme.primaryMajor)
                            : Icon(Icons.radio_button_off_outlined,
                                color: MyTheme.primaryMajor),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1),
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: MyTheme.incomeBackground,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'งบรายรับ',
                                    style: MyTheme.whiteTextTheme.bodyText1,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: AutoSizeText(
                                          '${HelperNumber.format(sum[0])} บ.',
                                          maxLines: 1,
                                          minFontSize: 0,
                                          style:
                                              MyTheme.whiteTextTheme.headline4,
                                        ),
                                      ),
                                      Text(
                                        '${perc[0].toStringAsFixed(2)}%',
                                        style: MyTheme.whiteTextTheme.bodyText1,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: MyTheme.expenseBackground,
                              ),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'งบรายจ่าย',
                                    style: MyTheme.whiteTextTheme.bodyText1,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: AutoSizeText(
                                          '${HelperNumber.format(sum[1])} บ.',
                                          maxLines: 1,
                                          minFontSize: 0,
                                          style:
                                              MyTheme.whiteTextTheme.headline4,
                                        ),
                                      ),
                                      Text(
                                        '${perc[1].toStringAsFixed(2)}%',
                                        style: MyTheme.whiteTextTheme.bodyText1,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('สภาพคล่องสุทธิ',
                          style: MyTheme.textTheme.bodyText1),
                      if (sum[0] - sum[1] > 0)
                        Text(
                          '+${HelperNumber.format(sum[0] - sum[1])} บ.',
                          style: MyTheme.textTheme.headline3!.merge(
                            TextStyle(color: MyTheme.positiveMajor),
                          ),
                        )
                      else
                        Text(
                          '${HelperNumber.format(sum[0] - sum[1])} บ.',
                          style: sum[0] - sum[1] != 0
                              ? MyTheme.textTheme.headline3!.merge(
                                  TextStyle(color: MyTheme.negativeMajor),
                                )
                              : MyTheme.textTheme.headline3,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<double> _getTotal(List<StmntBudget> budgets) {
  double incSum = 0;
  double expSum = 0;
  for (var item in budgets) {
    if (item.cat.ftype == '1' ||
        item.cat.ftype == '2' ||
        item.cat.ftype == '3') {
      incSum += item.total;
    } else {
      expSum += item.total;
    }
  }
  return [incSum, expSum];
}

List<double> _getPerc(List<double> incexp) {
  double sum = incexp[0] + incexp[1];
  final inc = incexp[0] / sum * 100;
  final exp = incexp[1] / sum * 100;
  return [inc, exp];
}
