import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';

import 'package:windshield/styles/theme.dart';
import 'package:windshield/main.dart';
import 'package:windshield/models/statement/budget.dart';
import 'package:windshield/routes/app_router.dart';

class StatementInfoPage extends ConsumerWidget {
  const StatementInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('แผนงบการเงินของคุณ', style: MyTheme.whiteTextTheme.headline3),
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
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (_, index) => const SizedBox(width: 10),
        scrollDirection: Axis.horizontal,
        itemCount: chips.length + 1,
        itemBuilder: (_, index) {
          if (index == 0) {
            return Container(
              width: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: const BorderRadius.all(Radius.circular(35)),
              ),
              child: Center(
                  child: Text('+', style: MyTheme.whiteTextTheme.headline2)),
            );
          }
          return GestureDetector(
            onTap: () {
              ref.read(provStatement).setStmntDateChipIdx(index - 1);
              ref.read(provStatement).setStmntDateList();
            },
            child: Container(
              width: 70,
              decoration: BoxDecoration(
                color: idx == index - 1
                    ? Colors.white
                    : Colors.white.withOpacity(0.3),
                borderRadius: const BorderRadius.all(Radius.circular(35)),
              ),
              child: Center(
                child: Text(
                  DateFormat('MMM')
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
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('แผนงบการเงินที่ใช้อยู่',
                      style: MyTheme.textTheme.headline3),
                  const Statement(index: 0),
                  const SizedBox(height: 20),
                ],
              ),
              if (stmntListLength != 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('แผนงบการเงินอื่นๆ',
                        style: MyTheme.textTheme.headline3),
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
              Container(
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
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
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
                stmntList[index].name,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${_getIncTotal(stmntList[index].budgets)} บ.',
                                  style: MyTheme.whiteTextTheme.headline4,
                                ),
                                Text(
                                  _getIncPerc(stmntList[index].budgets) + '%',
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
                                  '${_getExpTotal(stmntList[index].budgets)} บ.',
                                  style: MyTheme.whiteTextTheme.headline4,
                                ),
                                Text(
                                  _getExpPerc(stmntList[index].budgets) + '%',
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
