import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:windshield/core/statement/statement.dart';

import 'package:windshield/main.dart';
import 'package:windshield/pages/home/home_page.dart';
import 'package:windshield/pages/home/overview/statement/statement_create_page.dart';
import 'package:windshield/models/statement.dart';
import 'package:windshield/routes/app_router.dart';

class StatementPage extends ConsumerWidget {
  StatementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statementApi = ref.watch(statementApiProvider);
    final statement = ref.watch(statementProvider);
    print('BUILT');
    return statementApi.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Text('Text : $error'),
        data: (data) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            if (statement.statementList.length == 1) {
              AutoRouter.of(context).replace(StatementCreateRoute());
            }
          });
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
                        Palette.kToDark.shade300,
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
                const StatementCard(),
              ],
            ),
          );
        });
  }
}

class MonthList extends ConsumerWidget {
  const MonthList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('MONTH BUILT');
    final statement = ref.watch(statementProvider);
    final month = [];
    for (var item in statement.statementList) {
      if (!month.contains(item.month)) {
        month.add(item.month);
      }
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: month.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            margin: const EdgeInsets.all(10),
            child: TextButton(
              onPressed: () {
                AutoRouter.of(context).replace(StatementCreateRoute());
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
                ref.read(statementProvider).setSelectedMonth(month[index]);
              },
              style: TextButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: statement.selectedMonth == month[index]
                    ? Colors.white
                    : Colors.white24,
              ),
              child: Text(
                month[index].toString(),
                style: Theme.of(context).textTheme.bodyText1!,
              ),
            ),
          );
        }
      },
    );
  }
}

class StatementCard extends ConsumerWidget {
  const StatementCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('CARD BUILT');
    final statement = ref.watch(statementProvider);
    final List<Statement> randomList = [];
    for (var item in statement.statementList) {
      if (item.month == statement.selectedMonth || item.id == '') {
        randomList.add(item);
      }
    }
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: _generate(randomList, context),
      ),
    );
  }

  List<Widget> _generate(List<Statement> obj, BuildContext context) {
    var list = obj.map<List<Widget>>(
      (data) {
        var widgetList = <Widget>[];
        widgetList.add(
          SizedBox(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  // margin: const EdgeInsets.all(10),
                  // width: MediaQuery.of(context).size.width,
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.red,
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
                    child: data.name == ''
                        ? Center(
                            child: Text(
                              'เพิ่มแผนการเงินใหม่',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          )
                        : Center(
                            child: Text(
                                '${data.name}\n${data.id}\n${data.start}\n${data.end}',
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                  ),
                )
              ],
            ),
          ),
        );
        return widgetList;
      },
    ).toList();
    var flat = list.expand((element) => element).toList();
    return flat;
  }
}
