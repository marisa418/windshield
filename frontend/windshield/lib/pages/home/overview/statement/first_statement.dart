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
    return Container(
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
          GestureDetector(
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
            child: Row(
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
                                text: '+XX,XXX บ.',
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
                                percent: 1,
                                animation: true,
                                animationDuration: 1,
                                lineWidth: 5,
                                center: const Text(
                                  '100.0%',
                                  style: TextStyle(
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
                                    '0 บ.',
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
                        Text('รายจ่ายเดือนนี้',
                            style: MyTheme.textTheme.headline4),
                        Text(
                          '-xx,xxx บ.',
                          style: MyTheme.textTheme.headline2!.merge(
                            TextStyle(color: MyTheme.negativeMajor),
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
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
    ref.watch(provStatement.select((e) => e.needFetchAPI));
    return RichText(
      text: TextSpan(
        text: 'รายรับจากการทำงาน\n',
        style: MyTheme.textTheme.bodyText1!.merge(
          const TextStyle(color: Colors.black),
        ),
        children: [
          TextSpan(
            text: '+15,000',
            style: MyTheme.textTheme.headline4!.merge(
              TextStyle(color: MyTheme.incomeWorking[0]),
            ),
          ),
          TextSpan(
            text: '/15,000',
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
    ref.watch(provStatement.select((e) => e.needFetchAPI));
    return RichText(
      text: TextSpan(
        text: 'รายรับจากสินทรัพย์\n',
        style: MyTheme.textTheme.bodyText1!.merge(
          const TextStyle(color: Colors.black),
        ),
        children: [
          TextSpan(
            text: '+XX,XXX',
            style: MyTheme.textTheme.headline4!.merge(
              TextStyle(color: MyTheme.incomeAsset[0]),
            ),
          ),
          TextSpan(
            text: '/XX,XXX',
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
    ref.watch(provStatement.select((e) => e.needFetchAPI));
    return RichText(
      text: TextSpan(
        text: 'รายรับจากแหล่งอื่นๆ\n',
        style: MyTheme.textTheme.bodyText1!.merge(
          const TextStyle(color: Colors.black),
        ),
        children: [
          TextSpan(
            text: '+XX,XXX',
            style: MyTheme.textTheme.headline4!.merge(
              TextStyle(color: MyTheme.incomeOther[0]),
            ),
          ),
          TextSpan(
            text: '/XX,XXX',
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
