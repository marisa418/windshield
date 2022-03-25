import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

import 'package:windshield/main.dart';
import 'package:windshield/styles/theme.dart';
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
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.arrow_left,
                    color: MyTheme.primaryMajor,
                  ),
                  Text(
                    'ย้อนกลับ',
                    style: MyTheme.whiteTextTheme.headline3!.merge(
                      TextStyle(color: MyTheme.primaryMajor),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => ref.read(provStatement).setStmntCreatePageIdx(0),
          ),
          GestureDetector(
            child: Container(
              width: 140,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'ถัดไป',
                    style: MyTheme.whiteTextTheme.headline3!.merge(
                      TextStyle(color: MyTheme.primaryMajor),
                    ),
                  ),
                  Icon(
                    Icons.arrow_right,
                    color: MyTheme.primaryMajor,
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
