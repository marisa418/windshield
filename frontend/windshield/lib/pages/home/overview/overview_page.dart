import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';

import 'package:windshield/main.dart';
import 'package:windshield/pages/home/analysis/stat/stat_model.dart';
import 'package:windshield/routes/app_router.dart';
import 'package:windshield/styles/theme.dart';
import './overview_comp/inc_exp.dart';

final apiHomeStat = FutureProvider<Stat>((ref) async {
  final data = await ref.read(apiProvider).analStat();
  return data;
});

class Overview extends ConsumerWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(apiHomeStat);
    return api.when(
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (stat) {
          final Color color = getColor(stat.financialHealth);
          final String string = getString(stat.financialHealth);
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: MyTheme.majorBackground,
                    ),
                  ),
                  height: 210,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.shieldAlt,
                              color: Colors.white,
                            ),
                            Text(
                                DateFormat('E d MMM y').format(DateTime.now())),
                            const FaIcon(
                              FontAwesomeIcons.user,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 225,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(100),
                                topRight: Radius.circular(100),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  string,
                                  style: MyTheme.textTheme.headline1!.merge(
                                    TextStyle(color: color),
                                  ),
                                ),
                                if (string == '?')
                                  Text(
                                    'ไม่มีข้อมูล',
                                    style: MyTheme.textTheme.headline3!.merge(
                                      TextStyle(color: color),
                                    ),
                                  )
                                else
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: stat.financialHealth.toString(),
                                          style: MyTheme.textTheme.headline3!
                                              .merge(
                                            TextStyle(color: color),
                                          ),
                                        ),
                                        TextSpan(
                                          text: '/100',
                                          style: MyTheme.textTheme.headline3!
                                              .merge(
                                            const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                Text(
                                  'สุขภาพทางการเงิน',
                                  style: MyTheme.textTheme.headline4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Expanded(
                      //   child: SfRadialGauge(
                      //     // backgroundColor: Colors.black,
                      //     axes: [
                      //       RadialAxis(
                      //         startAngle: 180,
                      //         endAngle: 0,
                      //         canScaleToFit: true,
                      //         showLabels: false,
                      //         showTicks: false,
                      //         ranges: [
                      //           GaugeRange(
                      //             startValue: 0,
                      //             endValue: 100,
                      //             color: Colors.white,
                      //             // startWidth: 20,
                      //             endWidth: 20,
                      //           ),
                      //         ],
                      //         annotations: [
                      //           GaugeAnnotation(
                      //             widget: Text('x'),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
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
                                  AutoRouter.of(context)
                                      .push(const StatementRoute());
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
                                  AutoRouter.of(context)
                                      .push(const CategoryRoute());
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
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  String getString(double? value) {
    if (value != null) {
      if (value >= 0 && value < 25) return 'แย่';
      if (value >= 25 && value < 50) return 'พอใช้';
      if (value >= 50 && value < 75) return 'ปานกลาง';
      return 'ดี';
    }
    return '?';
  }

  Color getColor(double? value) {
    if (value != null) {
      if (value >= 0 && value < 25) return MyTheme.positiveMajor;
      if (value >= 25 && value < 50) return MyTheme.assetPersonal[0];
      if (value >= 50 && value < 75) return MyTheme.expenseConsist[0];
      return MyTheme.negativeMajor;
    }
    return Colors.black;
  }
}
