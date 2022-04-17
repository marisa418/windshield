import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:windshield/main.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/providers/statement_provider.dart';
import 'package:windshield/models/statement/budget.dart';
import 'package:windshield/models/statement/statement.dart';
import 'package:windshield/utility/number_formatter.dart';
import 'first_statement.dart';

final provStatement = ChangeNotifierProvider.autoDispose<StatementProvider>(
    (ref) => StatementProvider());

final apiStatement =
    FutureProvider.autoDispose<List<StmntStatement>>((ref) async {
  ref.watch(provStatement.select((value) => value.needFetchAPI));
  final now = DateTime.now();
  final data = await ref.read(apiProvider).getAllNotEndYetStatements(now);
  ref.read(provStatement).setStatementList(data);
  if (data.isNotEmpty) {
    final data2 = await ref
        .read(apiProvider)
        .getRangeDailyFlowSheet(data[0].start, data[0].end);
    ref.read(provStatement).setFlowSheetList(data2);
    ref.read(provStatement).setStmntActiveList();
    ref.read(provStatement).setStmntDateChipList();
    ref.read(provStatement).setStmntDateList();
  }
  return data;
});

// ทั้งหน้า
class StatementPage extends ConsumerWidget {
  const StatementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(apiStatement);
    return api.when(
      error: (error, stackTrace) => Text(stackTrace.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (data) {
        return SafeArea(
          child: Scaffold(
            body: Column(
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
      },
    );
  }
}

// Parent = StatementPage
// ส่วนบน (สีฟ้าๆ)
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
      height: 160,
      child: Padding(
        // padding: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
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
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 27,
                    progressColor: Colors.white,
                    percent: 0.5,
                    animation: true,
                    animationDuration: 1,
                    lineWidth: 7,
                    center: const Text(
                      'XX.X%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                    backgroundColor: const Color(0x80ffffff),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'สภาพคล่องสุทธิปัจจุบัน',
                          style: MyTheme.whiteTextTheme.headline4!.merge(
                            TextStyle(
                              color: Colors.white.withOpacity(.7),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'XX,XXX บ.',
                              style: MyTheme.whiteTextTheme.headline2,
                            ),
                            Wrap(
                              direction: Axis.vertical,
                              // alignment: WrapAlignment.end,
                              crossAxisAlignment: WrapCrossAlignment.end,
                              children: [
                                Text(
                                  'สิ้นสุดงบ',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(.7),
                                  ),
                                ),
                                Text(
                                  'XX XXX 2022',
                                  style: MyTheme.whiteTextTheme.bodyText1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Parent = StatementPage
// ตั้งแต่หลังสีฟ้าลงไป
class StatementList extends ConsumerWidget {
  const StatementList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stmnt = ref.watch(provStatement.select((e) => e.stmntActiveList));
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemCount: stmnt.length + 1,
        itemBuilder: (context, index) {
          if (stmnt.length == index) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  DateTime nextDayOfLastPlan =
                      DateUtils.dateOnly(DateTime.now());
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
                  height: 75,
                  decoration: BoxDecoration(
                    color: MyTheme.primaryMinor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      '+ กำหนดแผนงบการเงินเดือนถัดไป',
                      style: TextStyle(
                        color: MyTheme.primaryMajor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          if (index == 0) {
            return const FirstStatement();
          }
          return ActiveStatements(index);
        },
      ),
    );
  }
}

// Parent = StatementPage -> StatementList
// เป็นตัว statement ที่ chosen = true
class ActiveStatements extends ConsumerWidget {
  const ActiveStatements(this.index, {Key? key}) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stmntActiveList =
        ref.watch(provStatement.select((e) => e.stmntActiveList));
    final sum = _getTotal(stmntActiveList[index].budgets);
    final perc = _getPerc(sum);
    return GestureDetector(
      onTap: () {
        final provStmnt = ref.read(provStatement);
        provStmnt.setStmntId(stmntActiveList[index].id);
        provStmnt.setStmntName(stmntActiveList[index].name);
        provStmnt.setStmntBudgets(stmntActiveList[index].budgets);
        provStmnt.setDate(
          stmntActiveList[index].start,
          stmntActiveList[index].end,
        );
        AutoRouter.of(context).push(const StatementEditRoute());
      },
      child: Container(
        // height: 160,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(8.0),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    Text(
                      '${stmntActiveList[index].name} ',
                      style: MyTheme.textTheme.headline4,
                    ),
                    Text(
                      DateFormat("d MMM y")
                          .format(stmntActiveList[index].start),
                      style: MyTheme.textTheme.bodyText1!.merge(
                        const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    ref.read(provStatement).setStmntDateChipIdx(index);
                    ref.read(provStatement).setStmntDateList();
                    AutoRouter.of(context).push(const StatementInfoRoute());
                  },
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(Icons.edit, color: MyTheme.primaryMajor),
                      Text(
                        'เปลี่ยนแผน',
                        style: MyTheme.textTheme.bodyText1!.merge(
                          TextStyle(color: MyTheme.primaryMajor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(thickness: 1),
            Row(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${HelperNumber.format(sum[0])} บ.',
                                style: MyTheme.whiteTextTheme.headline4,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${HelperNumber.format(sum[1])} บ.',
                                style: MyTheme.whiteTextTheme.headline4,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('สภาพคล่องสุทธิ', style: MyTheme.textTheme.bodyText1),
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
