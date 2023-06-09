import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:auto_route/auto_route.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:windshield/styles/theme.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/utility/number_formatter.dart';
import 'package:windshield/utility/progress.dart';
import 'package:windshield/utility/statement_plan_calc.dart';
import 'statement_page.dart';

class FirstStatement extends ConsumerWidget {
  const FirstStatement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stmnt = ref.watch(provStatement.select((e) => e.stmntActiveList[0]));
    final incWorking = ref.watch(provStatement.select((e) => e.incWorking));
    final incAsset = ref.watch(provStatement.select((e) => e.incAsset));
    final incOther = ref.watch(provStatement.select((e) => e.incOther));
    final expIncon = ref.watch(provStatement.select((e) => e.expIncon));
    final expCon = ref.watch(provStatement.select((e) => e.expCon));
    final savInv = ref.watch(provStatement.select((e) => e.savInv));
    return GestureDetector(
      onTap: () {
        final provStmnt = ref.read(provStatement);
        provStmnt.setStmntId(stmnt.id);
        provStmnt.setStmntName(stmnt.name);
        provStmnt.setStmntBudgets(stmnt.budgets);
        provStmnt.setDate(
          stmnt.start,
          stmnt.end,
        );
        provStmnt.setEditSpecial(true);
        AutoRouter.of(context).push(const StatementEditRoute());
      },
      child: Container(
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
                      '${stmnt.name} ',
                      style: MyTheme.textTheme.headline4,
                    ),
                    Text(
                      DateFormat("d MMM y").format(stmnt.start),
                      style: MyTheme.textTheme.bodyText1!.merge(
                        const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    ref.read(provStatement).setStmntDateChipIdx(0);
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
                        Container(
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
                                    getFlowsProg(incWorking[0], incWorking[1]) +
                                        getFlowsProg(incAsset[0], incAsset[1]) +
                                        getFlowsProg(incOther[0], incOther[1]),
                                    incWorking[1] + incAsset[1] + incOther[1],
                                  ),
                                  animation: true,
                                  animationDuration: 1,
                                  lineWidth: 5,
                                  center: Text(
                                    '${HelperNumber.format(HelperProgress.getPercent(
                                          getFlowsProg(incWorking[0],
                                                  incWorking[1]) +
                                              getFlowsProg(
                                                  incAsset[0], incAsset[1]) +
                                              getFlowsProg(
                                                  incOther[0], incOther[1]),
                                          incWorking[1] +
                                              incAsset[1] +
                                              incOther[1],
                                        ) * 100)}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                    // overflow: TextOverflow.visible,
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
                                        leftAmount(
                                            incWorking, incAsset, incOther),
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
                        Container(
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
                                    getFlowsProg(expIncon[0], expIncon[1]) +
                                        getFlowsProg(expCon[0], expCon[1]) +
                                        getFlowsProg(savInv[0], savInv[1]),
                                    expIncon[1] + expCon[1] + savInv[1],
                                  ),
                                  animation: true,
                                  animationDuration: 1,
                                  lineWidth: 5,
                                  center: Text(
                                    '${HelperNumber.format(HelperProgress.getPercent(
                                          getFlowsProg(
                                                  expIncon[0], expIncon[1]) +
                                              getFlowsProg(
                                                  expCon[0], expCon[1]) +
                                              getFlowsProg(
                                                  savInv[0], savInv[1]),
                                          expIncon[1] + expCon[1] + savInv[1],
                                        ) * 100)}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                    // overflow: TextOverflow.visible,
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
                                        leftAmount(expIncon, expCon, savInv),
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
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('สภาพคล่องสุทธิ', style: MyTheme.textTheme.headline4),
                  total(
                    incWorking,
                    incAsset,
                    incOther,
                    expIncon,
                    expCon,
                    savInv,
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

class IncWorking extends ConsumerWidget {
  const IncWorking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incWorking = ref.watch(provStatement.select((e) => e.incWorking));
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
                text: '/${HelperNumber.format(incWorking[1])}',
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
          percent: HelperProgress.getPercent(incWorking[0], incWorking[1]),
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
                text: '/${HelperNumber.format(incAsset[1])}',
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
          percent: HelperProgress.getPercent(incAsset[0], incAsset[1]),
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
                text: '/${HelperNumber.format(incOther[1])}',
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
          percent: HelperProgress.getPercent(incOther[0], incOther[1]),
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
                text: '/${HelperNumber.format(expIncon[1])}',
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
          percent: HelperProgress.getPercent(expIncon[0], expIncon[1]),
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
                text: '/${HelperNumber.format(expCon[1])}',
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
          percent: HelperProgress.getPercent(expCon[0], expCon[1]),
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
                text: '/${HelperNumber.format(savInv[1])}',
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
          percent: HelperProgress.getPercent(savInv[0], savInv[1]),
          progressColor: MyTheme.savingAndInvest[0],
          backgroundColor: MyTheme.savingAndInvest[1],
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          barRadius: const Radius.circular(5),
        ),
      ],
    );
  }
}
