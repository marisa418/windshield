import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:windshield/routes/app_router.dart';

import 'package:windshield/styles/theme.dart';

import '../overview/overview_page.dart';
import 'asset_debt/asset_debt.dart';
import 'budget/budget.dart';
import 'inc_exp/inc_exp.dart';
import 'stat/stat.dart';

class Analysis extends ConsumerStatefulWidget {
  const Analysis({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnalysisState();
}

class _AnalysisState extends ConsumerState<Analysis>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0)
      ..addListener(() {
        setState(() {});
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
      if (value >= 0 && value < 25) return MyTheme.negativeMajor;
      if (value >= 25 && value < 50) return MyTheme.expenseConsist[0];
      if (value >= 50 && value < 75) return MyTheme.assetPersonal[0];
      return MyTheme.positiveMajor;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final home = ref.watch(apiHomeStat);
    return home.when(
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (stat) {
        final Color color = getColor(stat.financialHealth);
        final String string = getString(stat.financialHealth);
        return Stack(
          children: [
            Column(
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
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.shieldAlt,
                              color: Colors.white,
                            ),
                            Text(
                              DateFormat('E d MMM y').format(DateTime.now()),
                              style: MyTheme.whiteTextTheme.headline4,
                            ),
                            GestureDetector(
                              onTap: () => AutoRouter.of(context)
                                  .push(const UserEditRoute()),
                              child: const FaIcon(
                                FontAwesomeIcons.user,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 300,
                              padding: const EdgeInsets.only(top: 30),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(150),
                                  topRight: Radius.circular(150),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    string,
                                    style: MyTheme.textTheme.headline3!.merge(
                                      TextStyle(color: color),
                                    ),
                                  ),
                                  if (string == '?')
                                    Text(
                                      'ข้อมูลไม่พอ',
                                      style: MyTheme.textTheme.headline3!.merge(
                                        TextStyle(color: color),
                                      ),
                                    )
                                  else
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                '${stat.financialHealth!.floor()}',
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
                      ),
                    ],
                  ),
                ),
                TabBar(
                  labelColor: Colors.black,
                  controller: _tabController,
                  onTap: (e) {
                    if (e == 0) {
                      ref.refresh(apiIncExp);
                      ref.refresh(apiIncExpGraph);
                    } else if (e == 1) {
                      ref.refresh(apiBud);
                    }
                  },
                  tabs: [
                    Tab(
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            FontAwesomeIcons.exchangeAlt,
                            color: Colors.black,
                          ),
                          AutoSizeText(
                            'รายรับ-รายจ่าย',
                            maxLines: 1,
                            minFontSize: 0,
                            maxFontSize: 10,
                            style: MyTheme.textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            FontAwesomeIcons.chartPie,
                            color: Colors.black,
                          ),
                          AutoSizeText(
                            'งบการเงิน',
                            maxLines: 1,
                            minFontSize: 0,
                            maxFontSize: 10,
                            style: MyTheme.textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            FontAwesomeIcons.chartLine,
                            color: Colors.black,
                          ),
                          AutoSizeText(
                            'สินทรัพย์-หนี้สิน',
                            maxLines: 1,
                            minFontSize: 0,
                            maxFontSize: 10,
                            style: MyTheme.textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            FontAwesomeIcons.calculator,
                            color: Colors.black,
                          ),
                          AutoSizeText(
                            'สถิติทั่วไป',
                            maxLines: 1,
                            minFontSize: 0,
                            maxFontSize: 10,
                            style: MyTheme.textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const <Widget>[
                      IncExpTab(),
                      BudgetTab(),
                      AssetDebtTab(),
                      StatTab(),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 27),
                child: Container(
                  height: 225,
                  child: SfRadialGauge(
                    animationDuration: 2500,
                    axes: <RadialAxis>[
                      RadialAxis(
                        showLabels: false,
                        showTicks: false,
                        startAngle: 180,
                        endAngle: 0,
                        radiusFactor: 0.9,
                        canScaleToFit: true,
                        axisLineStyle: AxisLineStyle(
                          thickness: 0.1,
                          thicknessUnit: GaugeSizeUnit.factor,
                          color: Color(0xFFECECEC),
                          cornerStyle: CornerStyle.startCurve,
                        ),
                        pointers: <GaugePointer>[
                          RangePointer(
                            value: stat.financialHealth ?? 0,
                            width: 0.1,
                            sizeUnit: GaugeSizeUnit.factor,
                            gradient: SweepGradient(
                              colors: (stat.financialHealth?.floor() ?? 0) <= 50
                                  ? const <Color>[
                                      Color(0xFFFF0000),
                                      Color(0xFFFFC700),
                                    ]
                                  : (stat.financialHealth?.floor() ?? 0) <= 75
                                      ? const <Color>[
                                          Color(0xFFFF0000),
                                          Color(0xFFFFC700),
                                          Color(0xFF00FF23),
                                        ]
                                      : const <Color>[
                                          Color(0xFFFF0000),
                                          Color(0xFF00FF23),
                                          Color(0xFFFFC700),
                                          Color(0xFF00FFD1),
                                        ],
                            ),
                          ),
                          MarkerPointer(
                            markerHeight: 20,
                            markerWidth: 20,
                            value: stat.financialHealth?.floorToDouble() ??
                                0, //stat.floor(),
                            markerType: MarkerType.circle,
                            color: Colors.white,
                            borderColor: Colors.black,
                            borderWidth: .3,
                            elevation: 3,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
