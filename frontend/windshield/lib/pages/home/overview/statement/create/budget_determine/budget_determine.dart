import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:windshield/main.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/number_formatter.dart';
import '../statement_create_page.dart';
import '../../statement_page.dart';
import 'budget_info.dart';
import 'budget_inc.dart';
import 'budget_exp.dart';

final isLoading = StateProvider<bool>((_) => false);

class BudgetDetermine extends ConsumerWidget {
  const BudgetDetermine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: const [
        Header(),
        BudgetList(),
        Footer(),
      ],
    );
  }
}

class Header extends ConsumerWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final end = ref.watch(provStatement.select((e) => e.end));
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
              if (ref.watch(provBudget.select((e) => e.incExpIdx)) == 0) ...[
                const IncomeWorkingTab(),
                const IncomeAssetTab(),
                const IncomeOtherTab(),
              ] else ...[
                const ExpenseInconsistTab(),
                const ExpenseConsistTab(),
                const SavingInvestTab(),
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
            onTap: () =>
                AutoRouter.of(context).popUntilRouteWithName('StatementRoute'),
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
              final budList = ref.read(provBudget).budList;
              final stmntId = ref.read(provStatement).stmntId;
              await ref.read(apiProvider).updateStatementName(
                    stmntId,
                    ref.read(provStatement).stmntName,
                  );
              if (await ref.read(apiProvider).createBudgets(budList, stmntId)) {
                ref.read(provStatement).setNeedFetchAPI();
                // AutoRouter.of(context).pop();
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
