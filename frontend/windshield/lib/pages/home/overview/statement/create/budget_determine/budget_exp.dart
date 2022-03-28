import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/icon_convertor.dart';
import '../statement_create_page.dart';
import 'budget_inc.dart';

class ExpenseInconsistTab extends ConsumerWidget {
  const ExpenseInconsistTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(provBudget.select((e) => e.expInconsistTotal));
    final expInconsist = ref.watch(provBudget.select((e) => e.expInconsistTab));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'รายจ่ายไม่คงที่',
          style: MyTheme.textTheme.headline4,
        ),
        const SizedBox(height: 30),
        GridView.builder(
          physics: const ScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
          ),
          shrinkWrap: true,
          itemCount: expInconsist.length,
          itemBuilder: (context, i) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    final bud = expInconsist[i];
                    if (bud.active) {
                      ref.read(provBudget).removeBudget(bud);
                    } else {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (_) {
                          return Calculator(bud: bud);
                        },
                      );
                    }
                  },
                  child: Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      color: expInconsist[i].active
                          ? MyTheme.expenseInconsist[0]
                          : Colors.grey.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          HelperIcons.getIconData(expInconsist[i].icon),
                          color: Colors.white,
                        ),
                        if (expInconsist[i].total > 0)
                          Text(
                            expInconsist[i].total.toString(),
                            style: MyTheme.whiteTextTheme.bodyText2,
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: AutoSizeText(
                      expInconsist[i].name,
                      style: MyTheme.textTheme.bodyText2,
                      minFontSize: 8,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 35),
      ],
    );
  }
}

class ExpenseConsistTab extends ConsumerWidget {
  const ExpenseConsistTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(provBudget.select((e) => e.expConsistTotal));
    final expConsist = ref.watch(provBudget.select((e) => e.expConsistTab));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'รายจ่ายคงที่',
          style: MyTheme.textTheme.headline4,
        ),
        const SizedBox(height: 30),
        GridView.builder(
          physics: const ScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
          ),
          shrinkWrap: true,
          itemCount: expConsist.length,
          itemBuilder: (context, i) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    final bud = expConsist[i];
                    if (bud.active) {
                      ref.read(provBudget).removeBudget(bud);
                    } else {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (_) {
                          return Calculator(bud: bud);
                        },
                      );
                    }
                  },
                  child: Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      color: expConsist[i].active
                          ? MyTheme.expenseConsist[0]
                          : Colors.grey.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          HelperIcons.getIconData(expConsist[i].icon),
                          color: Colors.white,
                        ),
                        if (expConsist[i].total > 0)
                          Text(
                            expConsist[i].total.toString(),
                            style: MyTheme.whiteTextTheme.bodyText2,
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: AutoSizeText(
                      expConsist[i].name,
                      style: MyTheme.textTheme.bodyText2,
                      minFontSize: 8,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 35),
      ],
    );
  }
}

class SavingInvestTab extends ConsumerWidget {
  const SavingInvestTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(provBudget.select((e) => e.savingInvestTotal));
    final savingInvest = ref.watch(provBudget.select((e) => e.savingInvestTab));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'รายรับจากสินทรัพย์',
          style: MyTheme.textTheme.headline4,
        ),
        const SizedBox(height: 30),
        GridView.builder(
          physics: const ScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
          ),
          shrinkWrap: true,
          itemCount: savingInvest.length,
          itemBuilder: (context, i) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    final bud = savingInvest[i];
                    if (bud.active) {
                      ref.read(provBudget).removeBudget(bud);
                    } else {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (_) {
                          return Calculator(bud: bud);
                        },
                      );
                    }
                  },
                  child: Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      color: savingInvest[i].active
                          ? MyTheme.savingAndInvest[0]
                          : Colors.grey.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          HelperIcons.getIconData(savingInvest[i].icon),
                          color: Colors.white,
                        ),
                        if (savingInvest[i].total > 0)
                          Text(
                            savingInvest[i].total.toString(),
                            style: MyTheme.whiteTextTheme.bodyText2,
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: AutoSizeText(
                      savingInvest[i].name,
                      style: MyTheme.textTheme.bodyText2,
                      minFontSize: 8,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 35),
      ],
    );
  }
}
