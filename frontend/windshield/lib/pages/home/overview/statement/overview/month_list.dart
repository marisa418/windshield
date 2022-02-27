import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:windshield/main.dart';
import 'package:auto_route/auto_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:windshield/models/statement.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/utility/month_name_convertor.dart';

class MonthList extends ConsumerWidget {
  const MonthList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statement = ref.watch(providerStatement);
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: statement.existedMonth.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            margin: const EdgeInsets.all(10),
            child: TextButton(
              onPressed: () {
                final dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
                ref.read(providerStatement).setStartDate(dateNow);
                ref.read(providerStatement).setEndDate(dateNow);
                ref.read(providerStatement).setCreatePageIndex(0);
                ref.read(providerStatement).setSkipDatePage(false);
                ref.read(providerStatement).setTwoMonthLimited(false);
                AutoRouter.of(context).push(const StatementCreateRoute());
              },
              child: const FaIcon(
                FontAwesomeIcons.plus,
                color: Colors.white,
              ),
              style: TextButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: Colors.white24),
            ),
          );
        } else {
          return Container(
            margin: const EdgeInsets.all(10),
            child: TextButton(
              onPressed: () {
                ref.read(providerStatement).setStatementMonthIndex(index);
                ref.read(providerStatement).setStatementsInMonth();
              },
              style: TextButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: statement.statementMonthIndex == index
                    ? Colors.white
                    : Colors.white24,
              ),
              child: Text(
                HelperMonth.inttoMMM(statement.existedMonth[index]),
                style: Theme.of(context).textTheme.bodyText1!.merge(
                      const TextStyle(fontWeight: FontWeight.w600),
                    ),
              ),
            ),
          );
        }
      },
    );
  }
}
