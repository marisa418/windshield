import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:windshield/main.dart';
import 'package:windshield/models/financial_goal/financial_goal.dart';
import 'package:windshield/pages/home/overview/financial_goal/financial_goal_page.dart';
import 'package:windshield/providers/financial_goal_provider.dart';
import 'package:windshield/routes/app_router.dart';

import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/icon_convertor.dart';
import 'package:windshield/utility/number_formatter.dart';
import 'package:windshield/utility/progress.dart';
import './overview_comp/inc_exp.dart';

final provFGoal = ChangeNotifierProvider.autoDispose<FinancialGoalProvider>(
    (ref) => FinancialGoalProvider());

final apiFGoal = FutureProvider.autoDispose<List<FGoal>>((ref) async {
  ref.watch(provFGoal.select((value) => value.needFetchAPI));
  final data = await ref.read(apiProvider).getAllGoals();
  ref.read(provFGoal).setFgList(data);
  ref.read(provFGoal).setFgType();
  return data;
});

class Overview extends StatelessWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    MyTheme.kToDark.shade300,
                  ]),
            ),
            height: 210,
          ),
          Container(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const IncExp(),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            AutoRouter.of(context).push(const StatementRoute());
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 60,
                            child: FaIcon(
                              FontAwesomeIcons.chartPie,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: MyTheme.kToDark[50],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'แผนงบการเงิน',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            AutoRouter.of(context)
                                .push(const BalanceSheetRoute());
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 60,
                            child: FaIcon(
                              FontAwesomeIcons.balanceScale,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: MyTheme.kToDark[50],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'งบดุลการเงิน',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            AutoRouter.of(context)
                                .push(const FinancialGoalRoute());
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 60,
                            child: FaIcon(
                              FontAwesomeIcons.solidFlag,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: MyTheme.kToDark[50],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'เป้าหมาย\nทางการเงิน',
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            AutoRouter.of(context).push(const CategoryRoute());
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 60,
                            child: FaIcon(
                              FontAwesomeIcons.percentage,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: MyTheme.kToDark[50],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'จัดการ\nหมวดหมู่',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "เป้าหมายของคุณ",
                        style: MyTheme.textTheme.headline4,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                          width: 150,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Color(0x1A5236FF),
                            borderRadius: new BorderRadius.all(
                              Radius.circular(32),
                            ),
                          ),
                          child: FlatButton(
                            child: Text(
                              "ดูทั้งหมด",
                              style: MyTheme.whiteTextTheme.headline4!.merge(
                                TextStyle(color: Color(0xFF5236FF)),
                              ),
                              textAlign: TextAlign.right,
                            ),
                            onPressed: () {
                              AutoRouter.of(context)
                                  .push(const FinancialGoalRoute());
                            },
                          ),
                        )),
                  ],
                ),
                FinancialGoalList(),
                Container(
                  height: 200,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FinancialGoalList extends ConsumerWidget {
  const FinancialGoalList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(apiFGoal);
    final ListLenth = ref.watch(provFGoal).startedFg;
    return Container(
      padding: EdgeInsets.only(top: 10),
      height: ListLenth.isEmpty
          ? 90
          : ListLenth.length == 1
              ? 150
              : ListLenth.length == 2
                  ? 300
                  : 450,
      child: api.when(
        error: (error, stackTrace) => Text(stackTrace.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (data) {
          if (ListLenth.length < 3 && ListLenth.isNotEmpty) {
            return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemCount: ListLenth.length,
              itemBuilder: (context, index) {
                return ListPageStartAtHome(index);
              },
            );
          }
          if ((ListLenth.isEmpty)) {
            return Container(
              width: 400,
              height: 70,
              decoration: BoxDecoration(
                color: Color(0x1A5236FF),
                borderRadius: new BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  "+ เพิ่มเป้าหมายใหม่",
                  style: MyTheme.whiteTextTheme.headline2!.merge(
                    TextStyle(color: Color(0xFF5236FF)),
                  ),
                ),
                onPressed: () {
                  AutoRouter.of(context).push(const FinancialGoalRoute());
                },
              ),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            itemCount: 3,
            itemBuilder: (context, index) {
              return ListPageStartAtHome(index);
            },
          );
        },
      ),
    );
  }
}

class ListPageStartAtHome extends ConsumerWidget {
  const ListPageStartAtHome(this.index, {Key? key}) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fg = ref.watch(provFGoal).startedFg[index];
    final percentPeriod = HelperProgress.getPercent(
      fg.totalProg,
      fg.goal,
    );
    return GestureDetector(
      child: Card(
        elevation: 10,
        shadowColor: Colors.black.withOpacity(.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Slidable(
          child: Column(
            children: [
              Container(
                height: 100,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 25,
                      child: Container(
                        height: 75,
                        width: 75,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: MyTheme.primaryMajor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconsFinance.getIconData(
                                fg.icon,
                              ),
                              color: Colors.white,
                              size: 30,
                            ),
                            AutoSizeText(
                              HelperNumber.format(fg.progPerPeriod),
                              maxLines: 1,
                              minFontSize: 0,
                              style: MyTheme.whiteTextTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 53,
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              fg.name,
                              maxLines: 1,
                              style: MyTheme.textTheme.headline3,
                            ),
                            Text(
                                HelperNumber.format(fg.totalProg) +
                                    "/" +
                                    HelperNumber.format(fg.goal),
                                style: MyTheme.textTheme.headline4),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 22,
                      fit: FlexFit.tight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AutoSizeText(
                            fg.goalDate == null
                                ? ""
                                : fg.goalDate!.difference(DateTime.now()).inDays + 1 >
                                        365
                                    ? "ภายใน " +
                                        ((fg.goalDate!.difference(DateTime.now()).inDays + 1) / 365)
                                            .toStringAsFixed(0) +
                                        " ปี"
                                    : fg.goalDate!.difference(DateTime.now()).inDays + 1 > 30 &&
                                            fg.goalDate!.difference(DateTime.now()).inDays + 1 <
                                                365
                                        ? "ภายใน " +
                                            ((fg.goalDate!.difference(DateTime.now()).inDays + 1) / 30)
                                                .toStringAsFixed(0) +
                                            " เดือน"
                                        : fg.goalDate!.difference(DateTime.now()).inDays + 1 > 6 &&
                                                fg.goalDate!
                                                            .difference(
                                                                DateTime.now())
                                                            .inDays +
                                                        1 <
                                                    30 &&
                                                fg.goalDate!
                                                            .difference(
                                                                DateTime.now())
                                                            .inDays +
                                                        1 <
                                                    365
                                            ? "ภายใน " +
                                                ((fg.goalDate!.difference(DateTime.now()).inDays + 1) / 7)
                                                    .toStringAsFixed(0) +
                                                " สัปดาห์"
                                            : "ภายใน ${fg.goalDate!.difference(DateTime.now()).inDays + 1} วัน",
                            style: const TextStyle(color: Colors.red),
                            maxLines: 1,
                            minFontSize: 0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(10)),
                child: LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  animation: true,
                  lineHeight: 25.0,
                  animationDuration: 2500,
                  percent: percentPeriod,
                  center: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${HelperNumber.format(percentPeriod * 100)} %",
                          style: MyTheme.whiteTextTheme.bodyText1,
                        ),
                        Text(
                          "เริ่มต้น " + DateFormat.yMMMMd().format(fg.start),
                          style: MyTheme.whiteTextTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                  backgroundColor: Color.fromARGB(255, 55, 55, 55),
                  progressColor: MyTheme.primaryMajor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
