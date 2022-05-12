import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/number_formatter.dart';
import 'package:windshield/utility/progress.dart';
import 'package:windshield/utility/statement_plan_calc.dart';
import 'statement_edit_page.dart';
import '../statement_page.dart';

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
          if (ref.watch(provStatement.select((e) => e.editSpecial))) ...[
            const EditWithFlows(),
          ] else ...[
            const IncomeExpenseButton(),
            const IncomeExpenseSummary(),
          ]
        ],
      ),
    );
  }
}

class EditWithFlows extends ConsumerWidget {
  const EditWithFlows({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incWorking = ref.watch(provStatement.select((e) => e.incWorking));
    final incAsset = ref.watch(provStatement.select((e) => e.incAsset));
    final incOther = ref.watch(provStatement.select((e) => e.incOther));
    final expIncon = ref.watch(provStatement.select((e) => e.expIncon));
    final expCon = ref.watch(provStatement.select((e) => e.expCon));
    final savInv = ref.watch(provStatement.select((e) => e.savInv));
    final incWorkingBud =
        ref.watch(provBudget.select((e) => e.incWorkingTotal));
    final incAssetBud = ref.watch(provBudget.select((e) => e.incAssetTotal));
    final incOtherBud = ref.watch(provBudget.select((e) => e.incOtherTotal));
    final expInconBud =
        ref.watch(provBudget.select((e) => e.expInconsistTotal));
    final expConBud = ref.watch(provBudget.select((e) => e.expConsistTotal));
    final savInvBud = ref.watch(provBudget.select((e) => e.savingInvestTotal));
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'รายรับเดือนนี้\n',
                        style: MyTheme.textTheme.headline4!.merge(
                          const TextStyle(color: Colors.black),
                        ),
                        children: [
                          TextSpan(
                            text:
                                '+${HelperNumber.format(incWorking[0] + incAsset[0] + incOther[0])} บ.',
                            style: MyTheme.textTheme.headline2!.merge(
                              TextStyle(color: MyTheme.positiveMajor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => ref.read(provBudget).setIncExpIdx(0),
                      child: Container(
                        padding: const EdgeInsets.all(7.0),
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: MyTheme.incomeBackground,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              flex: 4,
                              child: CircularPercentIndicator(
                                radius: 25,
                                progressColor: Colors.white,
                                percent: HelperProgress.getPercent(
                                  getFlowsProg(incWorking[0], incWorkingBud) +
                                      getFlowsProg(incAsset[0], incAssetBud) +
                                      getFlowsProg(incOther[0], incOtherBud),
                                  incWorkingBud + incAssetBud + incOtherBud,
                                ),
                                animation: true,
                                animationDuration: 1,
                                lineWidth: 5,
                                center: Text(
                                  '${HelperNumber.format(
                                    HelperProgress.getPercent(
                                            getFlowsProg(incWorking[0],
                                                    incWorkingBud) +
                                                getFlowsProg(
                                                    incAsset[0], incAssetBud) +
                                                getFlowsProg(
                                                    incOther[0], incOtherBud),
                                            incWorkingBud +
                                                incAssetBud +
                                                incOtherBud) *
                                        100,
                                  )}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                                backgroundColor: const Color(0x80ffffff),
                              ),
                            ),
                            Flexible(
                              flex: 6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: AutoSizeText(
                                      'เป้ารายรับที่เหลือ',
                                      maxLines: 1,
                                      minFontSize: 0,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(.7),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: AutoSizeText(
                                      leftAmountBudget(
                                        incWorking[0],
                                        incWorkingBud,
                                        incAsset[0],
                                        incAssetBud,
                                        incOther[0],
                                        incOtherBud,
                                      ),
                                      maxLines: 1,
                                      minFontSize: 0,
                                      style: MyTheme.whiteTextTheme.headline4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const IncWorking(),
                    const SizedBox(height: 10),
                    const IncAsset(),
                    const SizedBox(height: 10),
                    const IncOther(),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'รายจ่ายเดือนนี้\n',
                        style: MyTheme.textTheme.headline4!.merge(
                          const TextStyle(color: Colors.black),
                        ),
                        children: [
                          TextSpan(
                            text:
                                '-${HelperNumber.format(expIncon[0] + expCon[0] + savInv[0])} บ.',
                            style: MyTheme.textTheme.headline2!.merge(
                              TextStyle(color: MyTheme.negativeMajor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => ref.read(provBudget).setIncExpIdx(1),
                      child: Container(
                        padding: const EdgeInsets.all(7.0),
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: MyTheme.expenseBackground,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              flex: 4,
                              child: CircularPercentIndicator(
                                radius: 25,
                                progressColor: Colors.white,
                                percent: HelperProgress.getPercent(
                                  getFlowsProg(expIncon[0], expInconBud) +
                                      getFlowsProg(expCon[0], expConBud) +
                                      getFlowsProg(savInv[0], savInvBud),
                                  expInconBud + expConBud + savInvBud,
                                ),
                                animation: true,
                                animationDuration: 1,
                                lineWidth: 5,
                                center: Text(
                                  '${HelperNumber.format(HelperProgress.getPercent(
                                        getFlowsProg(expIncon[0], expInconBud) +
                                            getFlowsProg(expCon[0], expConBud) +
                                            getFlowsProg(savInv[0], savInvBud),
                                        expInconBud + expConBud + savInvBud,
                                      ) * 100)}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                                backgroundColor: const Color(0x80ffffff),
                              ),
                            ),
                            Flexible(
                              flex: 6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: AutoSizeText(
                                      'เป้ารายจ่ายที่เหลือ',
                                      maxLines: 1,
                                      minFontSize: 0,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(.7),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: AutoSizeText(
                                      leftAmountBudget(
                                        expIncon[0],
                                        expInconBud,
                                        expCon[0],
                                        expConBud,
                                        savInv[0],
                                        savInvBud,
                                      ),
                                      maxLines: 1,
                                      minFontSize: 0,
                                      style: MyTheme.whiteTextTheme.headline4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const ExpIncon(),
                    const SizedBox(height: 10),
                    const ExpCon(),
                    const SizedBox(height: 10),
                    const SavInv(),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          // padding: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('สภาพคล่องสุทธิ', style: MyTheme.textTheme.headline4),
              totalWithBudget(
                incWorking[0],
                incWorkingBud,
                incAsset[0],
                incAssetBud,
                incOther[0],
                incOtherBud,
                expIncon[0],
                expInconBud,
                expCon[0],
                expConBud,
                savInv[0],
                savInvBud,
              ),
            ],
          ),
        ),
      ],
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
                          '${HelperNumber.format(HelperProgress.getPercent(budget.incTotal, (budget.incTotal + budget.expTotal)) * 100)}%',
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
                          '${HelperNumber.format(HelperProgress.getPercent(budget.expTotal, (budget.incTotal + budget.expTotal)) * 100)}%',
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

class IncWorking extends ConsumerWidget {
  const IncWorking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incWorking = ref.watch(provStatement.select((e) => e.incWorking));
    final incWorkingBud =
        ref.watch(provBudget.select((e) => e.incWorkingTotal));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'รายรับจากการทำงาน\n',
            style: MyTheme.textTheme.bodyText1!.merge(
              const TextStyle(color: Colors.black),
            ),
            children: [
              TextSpan(
                text: '+${HelperNumber.format(incWorking[0])}',
                style: MyTheme.textTheme.headline4!.merge(
                  TextStyle(color: MyTheme.incomeWorking[0]),
                ),
              ),
              TextSpan(
                text: '/${HelperNumber.format(incWorkingBud)}',
                style: MyTheme.textTheme.headline4!.merge(
                  TextStyle(color: MyTheme.incomeWorking[1]),
                ),
              ),
              TextSpan(
                text: ' บ.',
                style: MyTheme.textTheme.headline4!.merge(
                  TextStyle(color: MyTheme.incomeWorking[0]),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        LinearPercentIndicator(
          lineHeight: 8,
          percent: HelperProgress.getPercent(incWorking[0], incWorkingBud),
          progressColor: MyTheme.incomeWorking[0],
          backgroundColor: MyTheme.incomeWorking[1],
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          barRadius: const Radius.circular(5),
        ),
      ],
    );
  }
}

class IncAsset extends ConsumerWidget {
  const IncAsset({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incAsset = ref.watch(provStatement.select((e) => e.incAsset));
    final incAssetBud = ref.watch(provBudget.select((e) => e.incAssetTotal));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'รายรับจากสินทรัพย์\n',
            style: MyTheme.textTheme.bodyText1!.merge(
              const TextStyle(color: Colors.black),
            ),
            children: [
              TextSpan(
                text: '+${HelperNumber.format(incAsset[0])}',
                style: MyTheme.textTheme.headline4!.merge(
                  TextStyle(color: MyTheme.incomeAsset[0]),
                ),
              ),
              TextSpan(
                text: '/${HelperNumber.format(incAssetBud)}',
                style: MyTheme.textTheme.headline4!.merge(
                  TextStyle(color: MyTheme.incomeAsset[1]),
                ),
              ),
              TextSpan(
                text: ' บ.',
                style: MyTheme.textTheme.headline4!.merge(
                  TextStyle(color: MyTheme.incomeAsset[0]),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        LinearPercentIndicator(
          lineHeight: 8,
          percent: HelperProgress.getPercent(incAsset[0], incAssetBud),
          progressColor: MyTheme.incomeAsset[0],
          backgroundColor: MyTheme.incomeAsset[1],
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          barRadius: const Radius.circular(5),
        ),
      ],
    );
  }
}

class IncOther extends ConsumerWidget {
  const IncOther({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incOther = ref.watch(provStatement.select((e) => e.incOther));
    final incOtherBud = ref.watch(provBudget.select((e) => e.incOtherTotal));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'รายรับจากแหล่งอื่นๆ\n',
            style: MyTheme.textTheme.bodyText1!.merge(
              const TextStyle(color: Colors.black),
            ),
            children: [
              TextSpan(
                text: '+${HelperNumber.format(incOther[0])}',
                style: MyTheme.textTheme.headline4!.merge(
                  TextStyle(color: MyTheme.incomeOther[0]),
                ),
              ),
              TextSpan(
                text: '/${HelperNumber.format(incOtherBud)}',
                style: MyTheme.textTheme.headline4!.merge(
                  TextStyle(color: MyTheme.incomeOther[1]),
                ),
              ),
              TextSpan(
                text: ' บ.',
                style: MyTheme.textTheme.headline4!.merge(
                  TextStyle(color: MyTheme.incomeOther[0]),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        LinearPercentIndicator(
          lineHeight: 8,
          percent: HelperProgress.getPercent(incOther[0], incOtherBud),
          progressColor: MyTheme.incomeOther[0],
          backgroundColor: MyTheme.incomeOther[1],
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          barRadius: const Radius.circular(5),
        ),
      ],
    );
  }
}

class ExpIncon extends ConsumerWidget {
  const ExpIncon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expIncon = ref.watch(provStatement.select((e) => e.expIncon));
    final expInconBud =
        ref.watch(provBudget.select((e) => e.expInconsistTotal));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'รายจ่ายไม่คงที่\n',
            style: MyTheme.textTheme.bodyText1!.merge(
              const TextStyle(color: Colors.black),
            ),
            children: [
              TextSpan(
                text: '-${HelperNumber.format(expIncon[0])}',
                style: MyTheme.textTheme.headline4!.merge(
                  TextStyle(color: MyTheme.expenseInconsist[0]),
                ),
              ),
              TextSpan(
                text: '/${HelperNumber.format(expInconBud)}',
                style: MyTheme.textTheme.headline4!.merge(
                  TextStyle(color: MyTheme.expenseInconsist[1]),
                ),
              ),
              TextSpan(
                text: ' บ.',
                style: MyTheme.textTheme.headline4!.merge(
                  TextStyle(color: MyTheme.expenseInconsist[0]),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        LinearPercentIndicator(
          lineHeight: 8,
          percent: HelperProgress.getPercent(expIncon[0], expInconBud),
          progressColor: MyTheme.expenseInconsist[0],
          backgroundColor: MyTheme.expenseInconsist[1],
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          barRadius: const Radius.circular(5),
        ),
      ],
    );
  }
}

class ExpCon extends ConsumerWidget {
  const ExpCon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expCon = ref.watch(provStatement.select((e) => e.expCon));
    final expConBud = ref.watch(provBudget.select((e) => e.expConsistTotal));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'รายจ่ายคงที่\n',
            style: MyTheme.textTheme.bodyText1!.merge(
              const TextStyle(color: Colors.black),
            ),
            children: [
              TextSpan(
                text: '-${HelperNumber.format(expCon[0])}',
                style: MyTheme.textTheme.headline4!.merge(
                  TextStyle(color: MyTheme.expenseConsist[0]),
                ),
              ),
              TextSpan(
                text: '/${HelperNumber.format(expConBud)}',
                style: MyTheme.textTheme.headline4!.merge(
                  TextStyle(color: MyTheme.expenseConsist[1]),
                ),
              ),
              TextSpan(
                text: ' บ.',
                style: MyTheme.textTheme.headline4!.merge(
                  TextStyle(color: MyTheme.expenseConsist[0]),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        LinearPercentIndicator(
          lineHeight: 8,
          percent: HelperProgress.getPercent(expCon[0], expConBud),
          progressColor: MyTheme.expenseConsist[0],
          backgroundColor: MyTheme.expenseConsist[1],
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          barRadius: const Radius.circular(5),
        ),
      ],
    );
  }
}

class SavInv extends ConsumerWidget {
  const SavInv({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savInv = ref.watch(provStatement.select((e) => e.savInv));
    final savInvBud = ref.watch(provBudget.select((e) => e.savingInvestTotal));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'การออมและการลงทุน\n',
            style: MyTheme.textTheme.bodyText1!.merge(
              const TextStyle(color: Colors.black),
            ),
            children: [
              TextSpan(
                text: '-${HelperNumber.format(savInv[0])}',
                style: MyTheme.textTheme.headline4!.merge(
                  TextStyle(color: MyTheme.savingAndInvest[0]),
                ),
              ),
              TextSpan(
                text: '/${HelperNumber.format(savInvBud)}',
                style: MyTheme.textTheme.headline4!.merge(
                  TextStyle(color: MyTheme.savingAndInvest[1]),
                ),
              ),
              TextSpan(
                text: ' บ.',
                style: MyTheme.textTheme.headline4!.merge(
                  TextStyle(color: MyTheme.savingAndInvest[0]),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        LinearPercentIndicator(
          lineHeight: 8,
          percent: HelperProgress.getPercent(savInv[0], savInvBud),
          progressColor: MyTheme.savingAndInvest[0],
          backgroundColor: MyTheme.savingAndInvest[1],
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          barRadius: const Radius.circular(5),
        ),
      ],
    );
  }
}
