import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';

import 'package:windshield/main.dart';
import 'package:windshield/models/statement.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/routes/app_router.dart';

class StatementsInMonth extends ConsumerWidget {
  const StatementsInMonth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statement = ref.watch(providerStatement);
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: statement.statementsInMonth.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: statement.statementsInMonth[index].name == '' ? 130 : 200,
          width: MediaQuery.of(context).size.width,
          child: Container(
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
            child: statement.statementsInMonth[index].name == ''
                ? GestureDetector(
                    onTap: () {
                      ref
                          .read(providerStatement)
                          .setStartDate(statement.startDate);
                      ref.read(providerStatement).setEndDate(statement.endDate);
                      ref.read(providerStatement).setCreatePageIndex(1);
                      ref.read(providerStatement).setSkipDatePage(true);
                      ref.read(providerStatement).setTwoMonthLimited(false);
                      AutoRouter.of(context).push(const StatementCreateRoute());
                    },
                    child: Container(
                      color: MyTheme.kToDark.shade50,
                      child: Center(
                        child: Text(
                          '+ เพิ่มแผนใหม่',
                          style: Theme.of(context).textTheme.headline2!.merge(
                                const TextStyle(
                                  color: MyTheme.kToDark,
                                ),
                              ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text('''${statement.statementsInMonth[index].name}\n
                        ${statement.statementsInMonth[index].id}\n
                        ${statement.statementsInMonth[index].start}\n
                        ${statement.statementsInMonth[index].end}''',
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
          ),
        );
      },
    );
  }
}
