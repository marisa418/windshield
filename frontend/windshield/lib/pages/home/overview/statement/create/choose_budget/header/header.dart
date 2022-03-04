import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windshield/main.dart';

import 'package:windshield/styles/theme.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        // textDirection: TextDirection.LTR,
        children: [
          Positioned(
            top: 0,
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      MyTheme.kToDark.shade300,
                    ]),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              // margin: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,

              child: const HeaderInfo(),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderInfo extends ConsumerWidget {
  const HeaderInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(providerStatement.select((e) => e.statementName));
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          TextFormField(
            initialValue: name,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.edit),
            ),
            onChanged: (e) {
              ref.read(providerStatement).setStatementName(e);
            },
          ),
          const Divider(),
          const IncomeExpenseButton(),
          const IncomeExpenseSummary(),
        ],
      ),
    );
  }
}

class IncomeExpenseButton extends ConsumerWidget {
  const IncomeExpenseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(providerCategory);
    return Container(
      margin: const EdgeInsets.all(10),
      // height: 60,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                ref.read(providerCategory).setIsIncomePage(0);
              },
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xff14b6da),
                        Color(0xff2ae194),
                      ]),
                ),
                padding: const EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'งบรายรับ',
                      style: MyTheme.whiteTextTheme.bodyText2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${category.incomeTotal} บ.',
                          style: MyTheme.whiteTextTheme.headline4,
                        ),
                        Text(
                          '${(category.incomeTotal / (category.incomeTotal + category.expenseTotal) * 100).toStringAsFixed(2)}%',
                          style: MyTheme.whiteTextTheme.bodyText1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                ref.read(providerCategory).setIsIncomePage(1);
              },
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xffdf4833),
                        Color(0xffee3884),
                      ]),
                ),
                padding: const EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'งบรายจ่าย',
                      style: MyTheme.whiteTextTheme.bodyText2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${category.expenseTotal} บ.',
                          style: MyTheme.whiteTextTheme.headline4,
                        ),
                        Text(
                          '${(category.expenseTotal / (category.incomeTotal + category.expenseTotal) * 100).toStringAsFixed(2)}%',
                          style: MyTheme.whiteTextTheme.bodyText1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IncomeExpenseSummary extends ConsumerWidget {
  const IncomeExpenseSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(providerCategory);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'รายรับจากการทำงาน',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      '${category.incomeWorkingTotal} บ.',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'รายจ่ายไม่คงที่',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      '${category.expenseInconsistencyTotal} บ.',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'รายรับจากสินทรัพย์',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      '${category.incomeAssetTotal} บ.',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'รายจ่ายคงที่',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      '${category.expenseConsistencyTotal} บ.',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'รายรับอื่นๆ',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      '${category.incomeOtherTotal} บ.',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'การออมและการลงทุน',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      '${category.savingAndInvestTotal} บ.',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
