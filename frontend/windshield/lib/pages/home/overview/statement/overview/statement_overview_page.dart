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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'แผนงบการเงินของคุณ',
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .merge(const TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 15),
                const Expanded(
                  child: MonthList(),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 210,
            color: Colors.white,
            child: const StatementsInMonth(),
          ),
        ],
      ),
    );
  }
}
