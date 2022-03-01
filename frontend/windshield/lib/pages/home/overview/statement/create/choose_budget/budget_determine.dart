import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:windshield/main.dart';
import 'package:windshield/models/category.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/utility/icon_convertor.dart';
import 'package:windshield/models/budget.dart';
import 'package:windshield/styles/theme.dart';

class BudgetDetermine extends ConsumerWidget {
  const BudgetDetermine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category =
        ref.watch(providerCategory.select((value) => value.isIncomePage));
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: category == 0 ? const Income() : const Expense(),
    );
  }
}

class Income extends ConsumerWidget {
  const Income({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(providerCategory);
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _budgetTab(
              category.incomeWorkingTab, 'รายรับจากการทำงาน', context, ref),
          _budgetTab(
              category.incomeAssetTab, 'รายรับจากสินทรัพย์', context, ref),
          _budgetTab(category.incomeOtherTab, 'รายรับอื่นๆ', context, ref),
        ],
      ),
    );
  }
}

class Expense extends ConsumerWidget {
  const Expense({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(providerCategory);
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _budgetTab(category.expenseInconsistencyTab, 'รายจ่ายไม่คงที่',
              context, ref),
          _budgetTab(
              category.expenseConsistencyTab, 'รายจ่ายคงที่', context, ref),
          _budgetTab(
              category.savingAndInvestTab, 'การออมและการลงทุน', context, ref),
        ],
      ),
    );
  }
}

Widget _budgetTab(
    List<Category> cat, String tabName, BuildContext context, WidgetRef ref) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        tabName,
        style: Theme.of(context).textTheme.headline4!.merge(
              const TextStyle(
                color: Colors.black,
              ),
            ),
      ),
      const SizedBox(height: 20),
      Wrap(
        spacing: 30,
        runSpacing: 15,
        children: _generateWrapChildren(cat, context, ref),
      ),
      const SizedBox(height: 30),
    ],
  );
}

List<Widget> _generateWrapChildren(
    List<Category> cat, BuildContext context, WidgetRef ref) {
  var list = cat.map<List<Widget>>(
    (data) {
      var widgetList = <Widget>[];
      widgetList.add(
        SizedBox(
          width: 70,
          child: Column(
            children: [
              Stack(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        final catProvider = ref.read(providerCategory);
                        final catIndex = catProvider.findCatIndex(data);
                        catProvider.setBudgetPerPeriod(0);
                        if (catProvider.isActive(data, catIndex)) {
                          catProvider.removeBudget(data, catIndex);
                        } else {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            isDismissible: false,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            context: context,
                            builder: (context) => Calculator(
                              cat: data,
                              catIndex: catIndex,
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: data.active != false
                              ? ref
                                  .read(providerCategory)
                                  .getColorByFtype(data.ftype)
                              : const Color.fromARGB(255, 214, 213, 213),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              HelperIcons.getIconData(data.icon),
                              size: 20,
                              color: Colors.white,
                            ),
                            if (data.total != 0)
                              Text(
                                data.total.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                data.name,
                style: Theme.of(context).textTheme.bodyText1,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
      return widgetList;
    },
  ).toList();
  var output = list.expand((element) => element).toList();
  return output;
}

class Calculator extends ConsumerWidget {
  const Calculator({
    required this.cat,
    required this.catIndex,
    Key? key,
  }) : super(key: key);
  final Category cat;
  final int catIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statementDateAmount = ref.read(providerStatement).getDateDiff();
    final budgetPerPeriod =
        ref.watch(providerCategory.select((e) => e.budgetPerPeriod));
    final budgetType = ref.watch(providerCategory.select((e) => e.budgetType));
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex: 7,
                child: TextField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  onChanged: (e) {
                    ref
                        .read(providerCategory)
                        .setBudgetPerPeriod(int.tryParse(e) ?? 0);
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'จำนวนเงิน',
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: DropdownButton<String>(
                  value: budgetType,
                  icon: const Icon(Icons.arrow_downward),
                  onChanged: (String? e) {
                    ref.read(providerCategory).setBudgetType(e!);
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
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => AutoRouter.of(context).pop(),
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
                    ref.read(providerCategory).addBudget(
                          cat,
                          catIndex,
                          budgetPerPeriod,
                          ref.read(providerCategory).budgetType,
                          statementDateAmount,
                        );
                    AutoRouter.of(context).pop();
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
          const SizedBox(height: 30),
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
