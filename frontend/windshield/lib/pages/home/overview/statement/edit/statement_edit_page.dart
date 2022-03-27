import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

import 'package:windshield/main.dart';
import 'package:windshield/models/statement/budget.dart';
import 'package:windshield/models/statement/category.dart';
import 'package:windshield/styles/theme.dart';
import '../statement_page.dart';
import 'package:windshield/providers/budget_edit_provider.dart';
import 'budget_info.dart';
import 'budget_inc.dart';
import 'budget_exp.dart';

final provBudget = ChangeNotifierProvider.autoDispose<BudgetEditProvider>(
    (ref) => BudgetEditProvider());

final apiCat = FutureProvider.autoDispose<List<StmntCategory>>((ref) async {
  final data = await ref.read(apiProvider).getAllCategories();
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
