import 'package:flutter/material.dart';
import 'package:windshield/styles/theme.dart';

import 'month_list.dart';
import 'statements_in_month.dart';

class StatementOverviewPage extends StatelessWidget {
  const StatementOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.topLeft,
            height: 210,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Theme.of(context).primaryColor,
                  MyTheme.kToDark.shade300,
                ],
              ),
            ),
            child: Column(
              children: [
                Text(
                  'แผนงบการเงิน',
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .merge(const TextStyle(color: Colors.white)),
                ),
                const Expanded(
                  child: MonthList(),
                ),
              ],
            ),
          ),
          const StatementsInMonth(),
        ],
      ),
    );
  }
}
