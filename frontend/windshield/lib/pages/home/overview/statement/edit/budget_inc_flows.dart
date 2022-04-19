import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:windshield/models/balance_sheet/flow_sheet.dart';
import 'package:windshield/models/statement/category.dart';
import 'package:windshield/pages/home/overview/statement/edit/budget_inc.dart';
import 'package:windshield/pages/home/overview/statement/statement_page.dart';

import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/ftype_coler.dart';
import 'package:windshield/utility/icon_convertor.dart';
import 'package:windshield/utility/number_formatter.dart';
import 'package:windshield/utility/progress.dart';
import 'statement_edit_page.dart';

class IncomeWorkingFlowsTab extends ConsumerWidget {
  const IncomeWorkingFlowsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(provBudget);
    final flow = ref.watch(provStatement);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'รายรับจากการทำงาน',
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
          itemCount: budget.incWorkingTab.length,
          itemBuilder: (context, i) {
            return Column(
              children: [
                SizedBox(
                  height: 65,
                  width: 65,
                  child: GestureDetector(
                    onTap: () {
                      final bud = budget.incWorkingTab[i];
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
                        budget: budget.incWorkingTab[i],
                        flow: flow.flowSheetList),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: AutoSizeText(
                      budget.incWorkingTab[i].name,
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

class IncomeAssetFlowsTab extends ConsumerWidget {
  const IncomeAssetFlowsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(provBudget);
    final flow = ref.watch(provStatement);

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
          itemCount: budget.incAssetTab.length,
          itemBuilder: (context, i) {
            return Column(
              children: [
                SizedBox(
                  height: 65,
                  width: 65,
                  child: GestureDetector(
                    onTap: () {
                      final bud = budget.incAssetTab[i];
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
                        budget: budget.incAssetTab[i],
                        flow: flow.flowSheetList),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: AutoSizeText(
                      budget.incAssetTab[i].name,
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

class IncomeOtherFlowsTab extends ConsumerWidget {
  const IncomeOtherFlowsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(provBudget);
    final flow = ref.watch(provStatement);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'รายรับอื่นๆ',
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
          itemCount: budget.incOtherTab.length,
          itemBuilder: (context, i) {
            return Column(
              children: [
                SizedBox(
                  height: 65,
                  width: 65,
                  child: GestureDetector(
                    onTap: () {
                      final bud = budget.incOtherTab[i];
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
                        budget: budget.incOtherTab[i],
                        flow: flow.flowSheetList),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: AutoSizeText(
                      budget.incOtherTab[i].name,
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

class CircularProgress extends StatelessWidget {
  const CircularProgress({
    required this.budget,
    required this.flow,
    Key? key,
  }) : super(key: key);
  final StmntCategory budget;
  final List<FlowSheet> flow;
  @override
  Widget build(BuildContext context) {
    final flowTotal = calcFlowsTotal(flow, budget.id);
    final perc = HelperProgress.getPercent(flowTotal, budget.total);
    return CircularPercentIndicator(
      backgroundColor: budget.active
          ? HelperColor.getFtColor(budget.ftype, 1)
          : const Color(0xFFB8C7CB),
      progressColor: budget.active
          ? HelperColor.getFtColor(budget.ftype, 0)
          : const Color(0xFFB8C7CB),
      percent: 1 - perc,
      lineWidth: 32.5,
      radius: 32.5,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            HelperIcons.getIconData(
              budget.icon,
            ),
            color: Colors.white,
          ),
          if (flowTotal != 0)
            Text(
              HelperNumber.format(budget.total - flowTotal),
              style: MyTheme.whiteTextTheme.bodyText2,
            ),
        ],
      ),
    );
  }
}

double calcFlowsTotal(List<FlowSheet> flowSheets, String id) {
  double sum = 0;
  for (var flowSheet in flowSheets) {
    for (var flow in flowSheet.flows) {
      if (flow.cat.id == id) {
        sum += flow.value;
      }
    }
  }
  return sum;
}
