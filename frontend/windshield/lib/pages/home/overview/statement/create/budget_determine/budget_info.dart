import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/number_formatter.dart';
import 'package:windshield/utility/progress.dart';
import '../../statement_page.dart';
import '../statement_create_page.dart';

class BudgetInfo extends ConsumerWidget {
  const BudgetInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          TextFormField(
            initialValue: ref.watch(provStatement).stmntName,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.edit),
            ),
            style: MyTheme.textTheme.headline4,
            onChanged: (e) {
              ref.read(provStatement).setStmntName(e);
            },
          ),
          const IncomeExpenseButton(),
          const IncomeExpenseSummary(),
        ],
      ),
    );
  }
}

class IncomeExpenseButton extends ConsumerWidget {
  const IncomeExpenseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(provBudget);
    return Container(
      margin: const EdgeInsets.all(10),
      // height: 60,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                ref.read(provBudget).setIncExpIdx(0);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: MyTheme.incomeBackground,
                  ),
                ),
                padding: const EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'งบรายรับ',
                      style: MyTheme.whiteTextTheme.bodyText2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${HelperNumber.format(budget.incTotal)} บ.',
                          style: MyTheme.whiteTextTheme.headline4,
                        ),
                        Text(
                          '${HelperNumber.format((HelperProgress.getPercent(budget.incTotal, (budget.incTotal + budget.expTotal)) * 100))}%',
                          style: MyTheme.whiteTextTheme.bodyText1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                ref.read(provBudget).setIncExpIdx(1);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: MyTheme.expenseBackground,
                  ),
                ),
                padding: const EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'งบรายจ่าย',
                      style: MyTheme.whiteTextTheme.bodyText2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${HelperNumber.format(budget.expTotal)} บ.',
                          style: MyTheme.whiteTextTheme.headline4,
                        ),
                        Text(
                          '${HelperNumber.format((HelperProgress.getPercent(budget.expTotal, (budget.incTotal + budget.expTotal)) * 100))}%',
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
    );
  }
}

class IncomeExpenseSummary extends ConsumerWidget {
  const IncomeExpenseSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(provBudget);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'รายรับจากการทำงาน',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      '${HelperNumber.format(budget.incWorkingTotal)} บ.',
                      style: Theme.of(context).textTheme.headline4!.merge(
                            TextStyle(
                              color: MyTheme.incomeWorking[0],
                            ),
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'รายจ่ายไม่คงที่',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      '${HelperNumber.format(budget.expInconsistTotal)} บ.',
                      style: Theme.of(context).textTheme.headline4!.merge(
                            TextStyle(
                              color: MyTheme.expenseInconsist[0],
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'รายรับจากสินทรัพย์',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      '${HelperNumber.format(budget.incAssetTotal)} บ.',
                      style: Theme.of(context).textTheme.headline4!.merge(
                            TextStyle(
                              color: MyTheme.incomeAsset[0],
                            ),
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'รายจ่ายคงที่',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      '${HelperNumber.format(budget.expConsistTotal)} บ.',
                      style: Theme.of(context).textTheme.headline4!.merge(
                            TextStyle(
                              color: MyTheme.expenseConsist[0],
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'รายรับอื่นๆ',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      '${HelperNumber.format(budget.incOtherTotal)} บ.',
                      style: Theme.of(context).textTheme.headline4!.merge(
                            TextStyle(
                              color: MyTheme.incomeOther[0],
                            ),
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'การออมและการลงทุน',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      '${HelperNumber.format(budget.savingInvestTotal)} บ.',
                      style: Theme.of(context).textTheme.headline4!.merge(
                            TextStyle(
                              color: MyTheme.savingAndInvest[0],
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
