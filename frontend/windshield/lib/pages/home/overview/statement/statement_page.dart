import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';

import 'package:windshield/main.dart';
import 'package:windshield/providers/statement_provider.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/models/statement/budget.dart';

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
        return Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: const [
              Header(),
              StatementList(),
            ],
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
      height: 190,
    );
  }
}

// Parent = StatementPage
// ตั้งแต่หลังสีฟ้าลงไป
class StatementList extends ConsumerWidget {
  const StatementList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 190,
      child: Column(
        children: [
          const ListTile(),
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
    );
  }
}

// Parent = StatementPage -> StatementList
// เป็นตัว build statement list แต่ละตัว
class ListTile extends ConsumerWidget {
  const ListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stmnt = ref.watch(provStatement.select((e) => e.stmntActiveList));
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemCount: stmnt.length,
        itemBuilder: (context, index) {
          if (stmnt.length - 1 == index) {
            return Padding(
              padding: const EdgeInsets.all(10),
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
            );
          }
          return ActiveStatements(index);
        },
      ),
    );
  }
}

// Parent = StatementPage -> StatementList -> ListTile
// เป็นตัว statement ที่ chosen = true
class ActiveStatements extends ConsumerWidget {
  const ActiveStatements(this.index, {Key? key}) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stmntActiveList =
        ref.watch(provStatement.select((e) => e.stmntActiveList));
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          ref.read(provStatement).setStmntDateChipIdx(index);
          AutoRouter.of(context).push(const StatementInfoRoute());
        },
        child: Container(
          height: 150,
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${stmntActiveList[index].name} | ${DateFormat("d MMM y").format(stmntActiveList[index].start)}',
                  style: MyTheme.textTheme.headline4,
                ),
                const Divider(),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _getIncTotal(
                                        stmntActiveList[index].budgets),
                                    style: MyTheme.whiteTextTheme.headline4,
                                  ),
                                  Text(
                                    _getIncPerc(
                                            stmntActiveList[index].budgets) +
                                        '%',
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
                                  Text(
                                    _getExpTotal(
                                        stmntActiveList[index].budgets),
                                    style: MyTheme.whiteTextTheme.headline4,
                                  ),
                                  Text(
                                    _getExpPerc(
                                            stmntActiveList[index].budgets) +
                                        '%',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _getIncTotal(List<StmntBudget> budget) {
  double sum = 0;
  for (var item in budget) {
    if (item.cat.ftype == '1' ||
        item.cat.ftype == '2' ||
        item.cat.ftype == '3') {
      sum += item.total;
    }
  }
  return sum.toString();
}

String _getExpTotal(List<StmntBudget> budget) {
  double sum = 0;
  for (var item in budget) {
    if (item.cat.ftype == '4' ||
        item.cat.ftype == '5' ||
        item.cat.ftype == '6' ||
        item.cat.ftype == '10' ||
        item.cat.ftype == '11' ||
        item.cat.ftype == '12') {
      sum += item.total;
    }
  }
  return sum.toString();
}

String _getIncPerc(List<StmntBudget> budget) {
  final inc = _getIncTotal(budget);
  final exp = _getExpTotal(budget);
  double sum = double.parse(exp) + double.parse(inc);
  return (double.parse(inc) / sum * 100).toStringAsFixed(2);
}

String _getExpPerc(List<StmntBudget> budget) {
  final inc = _getIncTotal(budget);
  final exp = _getExpTotal(budget);
  double sum = double.parse(exp) + double.parse(inc);
  return (double.parse(exp) / sum * 100).toStringAsFixed(2);
}
