import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:flutter_simple_calculator/src/calc_controller.dart';

import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/icon_convertor.dart';
import 'package:windshield/models/statement/category.dart';
import 'package:windshield/pages/home/overview/statement/statement_page.dart';
import 'package:windshield/utility/number_formatter.dart';
import 'statement_edit_page.dart';

class IncomeWorkingTab extends ConsumerWidget {
  const IncomeWorkingTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(provBudget);
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
                GestureDetector(
                  onTap: () {
                    final bud = budget.incWorkingTab[i];
                    if (bud.active) {
                      ref.read(provBudget).removeBudget(bud);
                    } else {
                      ref.read(provBudget).setBudgetPerPeriod(0);
                      ref.read(provBudget).setBudgetType('MLY');
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (_) {
                          return CalculatorEdit(bud: bud);
                        },
                      );
                    }
                  },
                  child: Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      color: budget.incWorkingTab[i].active
                          ? MyTheme.incomeWorking[0]
                          : Colors.grey.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          HelperIcons.getIconData(budget.incWorkingTab[i].icon),
                          color: Colors.white,
                        ),
                        if (budget.incWorkingTab[i].total > 0)
                          AutoSizeText(
                            HelperNumber.format(budget.incWorkingTab[i].total),
                            style: MyTheme.whiteTextTheme.bodyText2,
                            minFontSize: 0,
                            maxLines: 1,
                          ),
                      ],
                    ),
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

class IncomeAssetTab extends ConsumerWidget {
  const IncomeAssetTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(provBudget);
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
                GestureDetector(
                  onTap: () {
                    final bud = budget.incAssetTab[i];
                    if (bud.active) {
                      ref.read(provBudget).removeBudget(bud);
                    } else {
                      ref.read(provBudget).setBudgetPerPeriod(0);
                      ref.read(provBudget).setBudgetType('MLY');
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (_) {
                          return CalculatorEdit(bud: bud);
                        },
                      );
                    }
                  },
                  child: Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      color: budget.incAssetTab[i].active
                          ? MyTheme.incomeAsset[0]
                          : Colors.grey.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          HelperIcons.getIconData(budget.incAssetTab[i].icon),
                          color: Colors.white,
                        ),
                        if (budget.incAssetTab[i].total > 0)
                          AutoSizeText(
                            HelperNumber.format(budget.incAssetTab[i].total),
                            style: MyTheme.whiteTextTheme.bodyText2,
                            maxLines: 1,
                            minFontSize: 0,
                          ),
                      ],
                    ),
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

class IncomeOtherTab extends ConsumerWidget {
  const IncomeOtherTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(provBudget);
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
          itemCount: budget.incOtherTab.length,
          itemBuilder: (context, i) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    final bud = budget.incOtherTab[i];
                    if (bud.active) {
                      ref.read(provBudget).removeBudget(bud);
                    } else {
                      ref.read(provBudget).setBudgetPerPeriod(0);
                      ref.read(provBudget).setBudgetType('MLY');
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (_) {
                          return CalculatorEdit(bud: bud);
                        },
                      );
                    }
                  },
                  child: Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      color: budget.incOtherTab[i].active
                          ? MyTheme.incomeOther[0]
                          : Colors.grey.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          HelperIcons.getIconData(budget.incOtherTab[i].icon),
                          color: Colors.white,
                        ),
                        if (budget.incOtherTab[i].total > 0)
                          AutoSizeText(
                            HelperNumber.format(budget.incOtherTab[i].total),
                            style: MyTheme.whiteTextTheme.bodyText2,
                            maxLines: 1,
                            minFontSize: 0,
                          ),
                      ],
                    ),
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

class CalculatorEdit extends ConsumerStatefulWidget {
  const CalculatorEdit({
    required this.bud,
    Key? key,
  }) : super(key: key);
  final StmntCategory bud;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CalculatorEditState();
}

class _CalculatorEditState extends ConsumerState<CalculatorEdit> {
  final _controller = CalcController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final budgetPerPeriod = ref.watch(provBudget.select((e) => e.budPerPeriod));
    final budgetType = ref.watch(provBudget.select((e) => e.budType));
    return Padding(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 30,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 355,
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 40),
                    Expanded(
                      child: SimpleCalculator(
                        hideSurroundingBorder: true,
                        controller: _controller,
                        theme: CalculatorThemeData(
                          displayStyle:
                              const TextStyle(fontSize: 0, color: Colors.white),
                          expressionStyle: const TextStyle(fontSize: 0),
                          commandColor: MyTheme.primaryMajor,
                          commandStyle: MyTheme.whiteTextTheme.headline4,
                          operatorColor: MyTheme.primaryMinor,
                          operatorStyle:
                              MyTheme.whiteTextTheme.headline2!.merge(
                            TextStyle(color: MyTheme.primaryMajor),
                          ),
                        ),
                        onChanged: (_, __, ___) {
                          ref
                              .read(provBudget)
                              .setBudgetPerPeriod(_controller.value ?? 0);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 55,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 7,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.2),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText(
                                budgetPerPeriod == 0
                                    ? widget.bud.name
                                    : HelperNumber.format(budgetPerPeriod),
                                maxLines: 1,
                                textAlign: TextAlign.right,
                                style: budgetPerPeriod == 0
                                    ? MyTheme.textTheme.headline3!.merge(
                                        const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      )
                                    : MyTheme.textTheme.headline3,
                              ),
                              AutoSizeText(
                                // (_controller.expression?.isEmpty ?? true)
                                //     ? '-'
                                //     : '${_controller.expression}',
                                _controller.expression ?? '',
                                maxLines: 1,
                                textAlign: TextAlign.end,
                                style: MyTheme.textTheme.bodyText2!.merge(
                                  const TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: DropdownButton<String>(
                          style: MyTheme.textTheme.bodyText1!.merge(
                            const TextStyle(color: Colors.black),
                          ),
                          value: budgetType,
                          icon: const Icon(Icons.arrow_downward),
                          onChanged: (String? e) {
                            ref.read(provBudget).setBudgetType(e!);
                          },
                          items: <String>['ต่อวัน', 'ต่อสัปดาห์', 'ต่อเดือน']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: _returnType(value),
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      'ยกเลิก',
                      style: MyTheme.whiteTextTheme.headline3,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (budgetPerPeriod != 0) {
                    ref.read(provBudget).addBudget(
                          widget.bud,
                          ref.read(provStatement).getDateDiff(),
                          ref.read(provStatement).stmntId,
                        );
                    Navigator.of(context).pop();
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                          title: Text(
                            'โปรดกรอกจำนวนเงิน',
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    );
                  }
                },
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.green,
                  ),
                  child: Center(
                    child: Text(
                      'ยืนยัน',
                      style: MyTheme.whiteTextTheme.headline3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  String _returnType(String value) {
    if (value == 'ต่อวัน') return 'DLY';
    if (value == 'ต่อสัปดาห์') return 'WLY';
    return 'MLY';
  }
}
