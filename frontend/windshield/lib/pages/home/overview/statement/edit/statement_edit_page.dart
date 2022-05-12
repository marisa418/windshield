import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:windshield/main.dart';
import 'package:windshield/models/statement/budget.dart';
import 'package:windshield/models/statement/category.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/number_formatter.dart';
import 'package:windshield/utility/progress.dart';
import '../statement_page.dart';
import 'package:windshield/providers/budget_edit_provider.dart';
import 'budget_info.dart';
import 'budget_inc.dart';
import 'budget_exp.dart';
import 'budget_inc_flows.dart';
import 'budget_exp_flows.dart';

final provBudget = ChangeNotifierProvider.autoDispose<BudgetEditProvider>(
    (ref) => BudgetEditProvider());

final apiCat = FutureProvider.autoDispose<List<StmntCategory>>((ref) async {
  final data = await ref.read(apiProvider).getAllCategories(true);
  if (data.isNotEmpty) {
    ref.read(provBudget).setCatList(data);
    ref.read(provBudget).setCategoryTypeTabs();
    ref.read(provBudget).setInitBudgets(ref.read(provStatement).stmntBudgets);
  }
  return data;
});

class StatementEditPage extends ConsumerWidget {
  const StatementEditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(provBudget.select((e) => e.catList));
    final api = ref.watch(apiCat);
    return api.when(
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (_) {
          return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Column(
                children: const [
                  Header(),
                  BudgetList(),
                  Footer(),
                ],
              ),
            ),
          );
        });
  }
}

class Header extends ConsumerWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final end = ref.watch(provStatement.select((e) => e.end));
    final special = ref.watch(provStatement.select((e) => e.editSpecial));
    if (!special) {
      final inc = ref.watch(provBudget.select((e) => e.incTotal));
      final exp = ref.watch(provBudget.select((e) => e.expTotal));
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
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('แผนงบการเงินของคุณ',
                  style: MyTheme.whiteTextTheme.headline2),
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'เป้าสภาพคล่อง',
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
                                (inc - exp) > 0
                                    ? '+${HelperNumber.format(inc - exp)} บ.'
                                    : '${HelperNumber.format(inc - exp)} บ.',
                                style: MyTheme.whiteTextTheme.headline2,
                              ),
                              Wrap(
                                direction: Axis.vertical,
                                crossAxisAlignment: WrapCrossAlignment.end,
                                children: [
                                  Text(
                                    'สิ้นสุดงบ',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(.7),
                                    ),
                                  ),
                                  Text(
                                    DateFormat('d MMM y').format(end),
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
    final incWorking = ref.watch(provStatement.select((e) => e.incWorking));
    final incAsset = ref.watch(provStatement.select((e) => e.incAsset));
    final incOther = ref.watch(provStatement.select((e) => e.incOther));
    final expIncon = ref.watch(provStatement.select((e) => e.expIncon));
    final expCon = ref.watch(provStatement.select((e) => e.expCon));
    final savInv = ref.watch(provStatement.select((e) => e.savInv));
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
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('แผนงบการเงินของคุณ', style: MyTheme.whiteTextTheme.headline2),
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
                    percent: HelperProgress.getPercent(
                      (incWorking[0] + incAsset[0] + incOther[0]) -
                          (expIncon[0] + expCon[0] + savInv[0]),
                      incWorking[0] + incAsset[0] + incOther[0],
                    ),
                    animation: true,
                    animationDuration: 1,
                    lineWidth: 7,
                    center: Text(
                      '${HelperNumber.format(HelperProgress.getPercent(
                            (incWorking[0] + incAsset[0] + incOther[0]) -
                                (expIncon[0] + expCon[0] + savInv[0]),
                            incWorking[0] + incAsset[0] + incOther[0],
                          ) * 100)}%',
                      style: const TextStyle(
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
                              '${HelperNumber.format((incWorking[0] + incAsset[0] + incOther[0]) - (expIncon[0] + expCon[0] + savInv[0]))} บ.',
                              style: MyTheme.whiteTextTheme.headline2,
                            ),
                            Wrap(
                              direction: Axis.vertical,
                              crossAxisAlignment: WrapCrossAlignment.end,
                              children: [
                                Text(
                                  'สิ้นสุดงบ',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(.7),
                                  ),
                                ),
                                Text(
                                  DateFormat('d MMM y').format(end),
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

class BudgetList extends ConsumerWidget {
  const BudgetList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const BudgetInfo(),
              const SizedBox(height: 35),
              if (ref.watch(provStatement.select((e) => e.editSpecial))) ...[
                if (ref.watch(provBudget.select((e) => e.incExpIdx)) == 0) ...[
                  const IncomeWorkingFlowsTab(),
                  const IncomeAssetFlowsTab(),
                  const IncomeOtherFlowsTab(),
                ] else ...[
                  const ExpenseInconsistFlowsTab(),
                  const ExpenseConsistFlowsTab(),
                  const SavingInvestFlowsTab(),
                ]
              ] else ...[
                if (ref.watch(provBudget.select((e) => e.incExpIdx)) == 0) ...[
                  const IncomeWorkingTab(),
                  const IncomeAssetTab(),
                  const IncomeOtherTab(),
                ] else ...[
                  const ExpenseInconsistTab(),
                  const ExpenseConsistTab(),
                  const SavingInvestTab(),
                ]
              ]
            ],
          ),
        ),
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
              decoration: BoxDecoration(
                color: MyTheme.primaryMajor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    Icons.arrow_left,
                    color: Colors.white,
                  ),
                  Text(
                    'ย้อนกลับ',
                    style: MyTheme.whiteTextTheme.headline3,
                  ),
                ],
              ),
            ),
            onTap: () => AutoRouter.of(context).pop(),
          ),
          GestureDetector(
            child: Container(
              width: 140,
              height: 50,
              decoration: BoxDecoration(
                color: MyTheme.primaryMajor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'ถัดไป',
                    style: MyTheme.whiteTextTheme.headline3,
                  ),
                  const Icon(
                    Icons.arrow_right,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            onTap: () async {
              showDialog(
                useRootNavigator: false,
                barrierDismissible: false,
                context: context,
                builder: (_) {
                  return const AlertDialog(
                    title: Center(child: CircularProgressIndicator()),
                  );
                },
              );
              final stmntId = ref.read(provStatement).stmntId;
              final stmntName = ref.read(provStatement).stmntName;
              final budList = ref.read(provBudget).budList;
              final initBudList = ref.read(provStatement).stmntBudgets;
              List<StmntBudget> createList = [];
              List<StmntBudget> updateList = [];
              List<String> deleteList = [];
              for (var item in budList) {
                final i = initBudList.indexWhere((e) => e.catId == item.catId);
                if (i != -1) {
                  final budId = initBudList[i].id;
                  item.id = budId;
                  updateList.add(item);
                } else {
                  createList.add(item);
                }
              }
              for (var item in initBudList) {
                if (budList.indexWhere((e) => e.catId == item.catId) == -1) {
                  deleteList.add(item.id);
                }
              }
              bool pass = true;
              if (createList.isNotEmpty) {
                pass = await ref
                    .read(apiProvider)
                    .createBudgets(createList, stmntId);
              }
              if (deleteList.isNotEmpty && pass) {
                pass = await ref.read(apiProvider).deleteBudgets(deleteList);
              }
              if (pass) {
                pass = await ref
                    .read(apiProvider)
                    .updateBudgets(updateList, stmntId);
              }
              if (pass) {
                pass = await ref
                    .read(apiProvider)
                    .updateStatementName(stmntId, stmntName);
              }
              if (pass) {
                ref.read(provStatement).setNeedFetchAPI();
                AutoRouter.of(context).popUntilRouteWithName('StatementRoute');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('เกิดข้อผิดพลาด')),
                );
                AutoRouter.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
