import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:auto_route/auto_route.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:windshield/styles/theme.dart';
import 'package:windshield/routes/app_router.dart';
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
                                    '+${incWorking[0] + incAsset[0] + incOther[0]} บ.',
                                style: MyTheme.textTheme.headline2!.merge(
                                  TextStyle(color: MyTheme.positiveMajor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(7.0),
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
                              CircularPercentIndicator(
                                radius: 25,
                                progressColor: Colors.white,
                                percent: double.parse(getPerc(
                                        incWorking, incAsset, incOther)) /
                                    100,
                                animation: true,
                                animationDuration: 1,
                                lineWidth: 5,
                                center: Text(
                                  '${getPerc(incWorking, incAsset, incOther)}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  // overflow: TextOverflow.visible,
                                ),
                                backgroundColor: const Color(0x80ffffff),
                              ),
                              Wrap(
                                direction: Axis.vertical,
                                crossAxisAlignment: WrapCrossAlignment.end,
                                children: [
                                  Text(
                                    'เป้ารายรับที่เหลือ',
                                    style: MyTheme.whiteTextTheme.bodyText2,
                                  ),
                                  Text(
                                    '${leftAmount(incWorking, incAsset, incOther)} บ.',
                                    style: MyTheme.whiteTextTheme.headline4,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const IncWorking(),
                        const IncAsset(),
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
                                    '+${expIncon[0] + expCon[0] + savInv[0]} บ.',
                                style: MyTheme.textTheme.headline2!.merge(
                                  TextStyle(color: MyTheme.negativeMajor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(7.0),
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
                              CircularPercentIndicator(
                                radius: 25,
                                progressColor: Colors.white,
                                percent: double.parse(
                                        getPerc(expIncon, expCon, savInv)) /
                                    100,
                                animation: true,
                                animationDuration: 1,
                                lineWidth: 5,
                                center: Text(
                                  '${getPerc(expIncon, expCon, savInv)}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  // overflow: TextOverflow.visible,
                                ),
                                backgroundColor: const Color(0x80ffffff),
                              ),
                              Wrap(
                                direction: Axis.vertical,
                                crossAxisAlignment: WrapCrossAlignment.end,
                                children: [
                                  Text(
                                    'เป้ารายจ่ายที่เหลือ',
                                    style: MyTheme.whiteTextTheme.bodyText2,
                                  ),
                                  Text(
                                    '${leftAmount(expIncon, expCon, savInv)} บ.',
                                    style: MyTheme.whiteTextTheme.headline4,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const ExpIncon(),
                        const ExpCon(),
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

String leftAmount(
  List<double> incWorking,
  List<double> incAsset,
  List<double> incOther,
) {
  final amount = (incWorking[1] + incAsset[1] + incOther[1]) -
      (incWorking[0] + incAsset[0] + incOther[0]);
  return amount <= -1 ? 'เกิน ${amount * -1}' : 'อีก $amount';
}

String getPerc(
  List<double> incWorking,
  List<double> incAsset,
  List<double> incOther,
) {
  final perc = (incWorking[0] + incAsset[0] + incOther[0]) /
      (incWorking[1] + incAsset[1] + incOther[1]) *
      100;
  return perc >= 100 ? '100' : perc.toStringAsFixed(2);
}

Text total(
  List<double> incWorking,
  List<double> incAsset,
  List<double> incOther,
  List<double> expIncon,
  List<double> expCon,
  List<double> savInv,
) {
  final amount = (incWorking[0] +
          incWorking[1] +
          incAsset[0] +
          incAsset[1] +
          incOther[0] +
          incOther[1]) -
      (expIncon[0] +
          expIncon[1] +
          expCon[0] +
          expCon[1] +
          savInv[0] +
          savInv[1]);
  if (amount > 0) {
    return Text(
      '+${amount.toStringAsFixed(2)} บ.',
      style: MyTheme.textTheme.headline3!.merge(
        TextStyle(
          color: MyTheme.positiveMajor,
        ),
      ),
    );
  } else if (amount < 0) {
    return Text(
      '-${amount.toStringAsFixed(2)} บ.',
      style: MyTheme.textTheme.headline3!.merge(
        TextStyle(
          color: MyTheme.negativeMajor,
        ),
      ),
    );
  } else {
    return Text(
      '${amount.toStringAsFixed(0)} บ.',
      style: MyTheme.textTheme.headline3!.merge(
        TextStyle(
          color: MyTheme.positiveMajor,
        ),
      ),
    );
  }
}

class IncWorking extends ConsumerWidget {
  const IncWorking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(provStatement.select((e) => e.needFetchAPI));
    final incWorking = ref.watch(provStatement.select((e) => e.incWorking));
    return RichText(
      text: TextSpan(
        text: 'รายรับจากการทำงาน\n',
        style: MyTheme.textTheme.bodyText1!.merge(
          const TextStyle(color: Colors.black),
        ),
        children: [
          TextSpan(
            text: '+${incWorking[0]}',
            style: MyTheme.textTheme.headline4!.merge(
              TextStyle(color: MyTheme.incomeWorking[0]),
            ),
          ),
          TextSpan(
            text: '/${incWorking[1]}',
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
    );
  }
}

class IncAsset extends ConsumerWidget {
  const IncAsset({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(provStatement.select((e) => e.needFetchAPI));
    final incAsset = ref.watch(provStatement.select((e) => e.incAsset));
    return RichText(
      text: TextSpan(
        text: 'รายรับจากสินทรัพย์\n',
        style: MyTheme.textTheme.bodyText1!.merge(
          const TextStyle(color: Colors.black),
        ),
        children: [
          TextSpan(
            text: '+${incAsset[0]}',
            style: MyTheme.textTheme.headline4!.merge(
              TextStyle(color: MyTheme.incomeAsset[0]),
            ),
          ),
          TextSpan(
            text: '/${incAsset[1]}',
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
    );
  }
}

class IncOther extends ConsumerWidget {
  const IncOther({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(provStatement.select((e) => e.needFetchAPI));
    final incOther = ref.watch(provStatement.select((e) => e.incOther));
    return RichText(
      text: TextSpan(
        text: 'รายรับจากแหล่งอื่นๆ\n',
        style: MyTheme.textTheme.bodyText1!.merge(
          const TextStyle(color: Colors.black),
        ),
        children: [
          TextSpan(
            text: '+${incOther[0]}',
            style: MyTheme.textTheme.headline4!.merge(
              TextStyle(color: MyTheme.incomeOther[0]),
            ),
          ),
          TextSpan(
            text: '/${incOther[1]}',
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
    );
  }
}

class ExpIncon extends ConsumerWidget {
  const ExpIncon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(provStatement.select((e) => e.needFetchAPI));
    final expIncon = ref.watch(provStatement.select((e) => e.expIncon));
    return RichText(
      text: TextSpan(
        text: 'รายจ่ายไม่คงที่\n',
        style: MyTheme.textTheme.bodyText1!.merge(
          const TextStyle(color: Colors.black),
        ),
        children: [
          TextSpan(
            text: '+${expIncon[0]}',
            style: MyTheme.textTheme.headline4!.merge(
              TextStyle(color: MyTheme.expenseInconsist[0]),
            ),
          ),
          TextSpan(
            text: '/${expIncon[1]}',
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
    );
  }
}

class ExpCon extends ConsumerWidget {
  const ExpCon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(provStatement.select((e) => e.needFetchAPI));
    final expCon = ref.watch(provStatement.select((e) => e.expCon));
    return RichText(
      text: TextSpan(
        text: 'รายจ่ายคงที่\n',
        style: MyTheme.textTheme.bodyText1!.merge(
          const TextStyle(color: Colors.black),
        ),
        children: [
          TextSpan(
            text: '+${expCon[0]}',
            style: MyTheme.textTheme.headline4!.merge(
              TextStyle(color: MyTheme.expenseConsist[0]),
            ),
          ),
          TextSpan(
            text: '/${expCon[1]}',
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
    );
  }
}

class SavInv extends ConsumerWidget {
  const SavInv({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(provStatement.select((e) => e.needFetchAPI));
    final savInv = ref.watch(provStatement.select((e) => e.savInv));
    return RichText(
      text: TextSpan(
        text: 'การออมและการลงทุน\n',
        style: MyTheme.textTheme.bodyText1!.merge(
          const TextStyle(color: Colors.black),
        ),
        children: [
          TextSpan(
            text: '+${savInv[0]}',
            style: MyTheme.textTheme.headline4!.merge(
              TextStyle(color: MyTheme.savingAndInvest[0]),
            ),
          ),
          TextSpan(
            text: '/${savInv[1]}',
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
    );
  }
}
