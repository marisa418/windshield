import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:windshield/main.dart';
import 'package:windshield/models/category.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/utility/icon_convertor.dart';

class BudgetDetermine extends ConsumerWidget {
  const BudgetDetermine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category =
        ref.watch(providerCategory.select((value) => value.isIncomePage));
    return Container(
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
          _budgetTab(category.incomeWorkingTab, 'รายรับจากการทำงาน', context),
          _budgetTab(category.incomeAssetTab, 'รายรับจากสินทรัพย์', context),
          _budgetTab(category.incomeOtherTab, 'รายรับอื่นๆ', context),
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
          _budgetTab(
              category.expenseInconsistencyTab, 'รายจ่ายไม่คงที่', context),
          _budgetTab(category.expenseConsistencyTab, 'รายจ่ายคงที่', context),
          _budgetTab(category.savingAndInvestTab, 'การออมและการลงทุน', context),
        ],
      ),
    );
  }
}

Widget _budgetTab(List<Category> obj, String tabName, BuildContext context) {
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
        children: _generateWrapChildren(
          obj,
          context,
        ),
      ),
      const SizedBox(height: 30),
    ],
  );
}

List<Widget> _generateWrapChildren(List<Category> obj, BuildContext context) {
  var list = obj.map<List<Widget>>(
    (data) {
      var widgetList = <Widget>[];
      widgetList.add(
        SizedBox(
          width: 70,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: SizedBox(
                  height: 60,
                  width: 60,
                  child: Icon(
                    HelperIcons.getIconData(data.icon),
                    size: 20,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 214, 213, 213),
                  shape: const CircleBorder(),
                ),
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
