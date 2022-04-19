import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windshield/pages/home/overview/statement/edit/budget_inc.dart';
import 'package:windshield/pages/home/overview/statement/statement_page.dart';

import 'package:windshield/styles/theme.dart';
import 'statement_edit_page.dart';
import 'budget_inc_flows.dart';

class ExpenseInconsistFlowsTab extends ConsumerWidget {
  const ExpenseInconsistFlowsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(provBudget);
    final flow = ref.watch(provStatement);

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
          itemCount: budget.expInconsistTab.length,
          itemBuilder: (context, i) {
            return Column(
              children: [
                SizedBox(
                  height: 65,
                  width: 65,
                  child: GestureDetector(
                    onTap: () {
                      final bud = budget.expInconsistTab[i];
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
                    child: CircularProgress(
                        budget: budget.expInconsistTab[i],
                        flow: flow.flowSheetList),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: AutoSizeText(
                      budget.expInconsistTab[i].name,
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

class ExpenseConsistFlowsTab extends ConsumerWidget {
  const ExpenseConsistFlowsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(provBudget);
    final flow = ref.watch(provStatement);

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
          itemCount: budget.expConsistTab.length,
          itemBuilder: (context, i) {
            return Column(
              children: [
                SizedBox(
                  height: 65,
                  width: 65,
                  child: GestureDetector(
                    onTap: () {
                      final bud = budget.expConsistTab[i];
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
                    child: CircularProgress(
                        budget: budget.expConsistTab[i],
                        flow: flow.flowSheetList),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: AutoSizeText(
                      budget.expConsistTab[i].name,
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

class SavingInvestFlowsTab extends ConsumerWidget {
  const SavingInvestFlowsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(provBudget);
    final flow = ref.watch(provStatement);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'การออมและการลงทุน',
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
          itemCount: budget.savingInvestTab.length,
          itemBuilder: (context, i) {
            return Column(
              children: [
                SizedBox(
                  height: 65,
                  width: 65,
                  child: GestureDetector(
                    onTap: () {
                      final bud = budget.savingInvestTab[i];
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
                    child: CircularProgress(
                        budget: budget.savingInvestTab[i],
                        flow: flow.flowSheetList),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: AutoSizeText(
                      budget.savingInvestTab[i].name,
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
