import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:windshield/styles/theme.dart';

import '../../../utility/icon_convertor.dart';

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
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        TabBar(
          labelColor: Colors.black,
          controller: _tabController,
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
              IncExpBackPage(),
              BudgetPage(),
              DebtAssetPage(),
              StatPage(),
            ],
          ),
        ),
      ],
    );
  }
}

class IncExpBackPage extends ConsumerWidget {
  const IncExpBackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'รายรับ-รายจ่ายย้อนหลัง',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Container(height: 150, color: Colors.amber),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'เฉลี่ยย้อนหลัง',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: MyTheme.primaryMajor),
                      backgroundColor: MyTheme.primaryMinor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {
                      null;
                    },
                    child: const Text('7วัน')),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ค่าใช้จ่าย',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text('XXXบ.',
                      style: TextStyle(
                        color: MyTheme.negativeMajor,
                        fontSize: 20,
                      )),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('รายจ่ายไม่คงที่',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                    Text('XXX บ.',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                        ))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('พอเหมาะ ',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 14,
                        )),
                    LinearPercentIndicator(
                      width: 200.0,
                      lineHeight: 16.0,
                      percent: 0.5,
                      animation: true,
                      animationDuration: 2500,
                      backgroundColor: Colors.grey[300],
                      progressColor: Colors.orange,
                      center: const Padding(
                        padding: EdgeInsets.only(right: 135),
                        child: Text("50.0%"),
                      ),
                      barRadius: const Radius.circular(20),
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('รายจ่ายคงที่',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                    Text('XXX บ.',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 18,
                        ))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('พอเหมาะ ',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 14,
                        )),
                    LinearPercentIndicator(
                      width: 200.0,
                      lineHeight: 16.0,
                      percent: 0.65,
                      animation: true,
                      animationDuration: 2500,
                      backgroundColor: Colors.grey[300],
                      progressColor: Colors.yellow,
                      center: const Padding(
                        padding: EdgeInsets.only(right: 135),
                        child: Text("65.0%"),
                      ),
                      barRadius: const Radius.circular(20),
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('การออมเเละการลงทุน',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                    Text('XXX บ.',
                        style: TextStyle(
                          color: MyTheme.primaryMajor,
                          fontSize: 18,
                        ))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('พอเหมาะ ',
                        style: TextStyle(
                          color: MyTheme.primaryMajor,
                          fontSize: 14,
                        )),
                    LinearPercentIndicator(
                      width: 200.0,
                      lineHeight: 16.0,
                      percent: 0.3,
                      animation: true,
                      animationDuration: 2500,
                      backgroundColor: Colors.grey[300],
                      progressColor: MyTheme.primaryMajor,
                      center: const Padding(
                        padding: EdgeInsets.only(right: 135),
                        child: Text("30.0%"),
                      ),
                      barRadius: const Radius.circular(20),
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ค่าใช้จ่ายจากหนี้สิน',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text('X,XXX บ.',
                      style: TextStyle(
                        color: MyTheme.negativeMajor,
                        fontSize: 20,
                      )),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('หนี้สินระยะสั้น',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                    Text('XXX บ.',
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontSize: 18,
                        ))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('พอเหมาะ ',
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontSize: 14,
                        )),
                    LinearPercentIndicator(
                      width: 200.0,
                      lineHeight: 16.0,
                      percent: 0.3,
                      animation: true,
                      animationDuration: 2500,
                      backgroundColor: Colors.grey[300],
                      progressColor: Colors.pinkAccent,
                      center: const Padding(
                        padding: EdgeInsets.only(right: 135),
                        child: Text("30.0%"),
                      ),
                      barRadius: const Radius.circular(20),
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('หนี้สินระยะยาว',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                    Text('XXX บ.',
                        style: TextStyle(
                          color: Colors.pink,
                          fontSize: 18,
                        ))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('พอเหมาะ ',
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontSize: 14,
                        )),
                    LinearPercentIndicator(
                      width: 200.0,
                      lineHeight: 16.0,
                      percent: 0.3,
                      animation: true,
                      animationDuration: 2500,
                      backgroundColor: Colors.grey[300],
                      progressColor: Colors.pinkAccent,
                      center: const Padding(
                        padding: EdgeInsets.only(right: 135),
                        child: Text("30.0%"),
                      ),
                      barRadius: const Radius.circular(20),
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ราบรับ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text('15,000 บ.',
                      style: TextStyle(
                        color: MyTheme.positiveMajor,
                        fontSize: 20,
                      )),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('รายรับจากการทำงาน',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                    Text('XXX บ.',
                        style: TextStyle(
                          color: MyTheme.positiveMajor,
                          fontSize: 18,
                        ))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('พอเหมาะ ',
                        style: TextStyle(
                          color: MyTheme.positiveMajor,
                          fontSize: 14,
                        )),
                    LinearPercentIndicator(
                      width: 200.0,
                      lineHeight: 16.0,
                      percent: 1.0,
                      animation: true,
                      animationDuration: 2500,
                      backgroundColor: Colors.grey[300],
                      progressColor: MyTheme.positiveMajor,
                      center: const Padding(
                        padding: EdgeInsets.only(right: 135),
                        child: Text("100.0%"),
                      ),
                      barRadius: const Radius.circular(20),
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('รายรับจากสินทรัพย์',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                    Text('XXX บ.',
                        style: TextStyle(
                          color: Colors.blue[300],
                          fontSize: 18,
                        ))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('พอเหมาะ ',
                        style: TextStyle(
                          color: Colors.blue[300],
                          fontSize: 14,
                        )),
                    LinearPercentIndicator(
                      width: 200.0,
                      lineHeight: 16.0,
                      percent: 0.3,
                      animation: true,
                      animationDuration: 2500,
                      backgroundColor: Colors.grey[300],
                      progressColor: Colors.blue[300],
                      center: const Padding(
                        padding: EdgeInsets.only(right: 135),
                        child: Text("30.0%"),
                      ),
                      barRadius: const Radius.circular(20),
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('รายรับอื่นๆ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                    Text('XXX บ.',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 18,
                        ))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('พอเหมาะ ',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 14,
                        )),
                    LinearPercentIndicator(
                      width: 200.0,
                      lineHeight: 16.0,
                      percent: 0.3,
                      animation: true,
                      animationDuration: 2500,
                      backgroundColor: Colors.grey[300],
                      progressColor: Colors.blueAccent,
                      center: const Padding(
                        padding: EdgeInsets.only(right: 135),
                        child: Text("30.0%"),
                      ),
                      barRadius: const Radius.circular(20),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BudgetPage extends ConsumerWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'สรุปการเงินที่ผ่านมา',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Container(
              width: 345,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    blurRadius: 4,
                    offset: const Offset(2, 4), // Shadow position
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('แผนงบการเงิน X',
                            style: TextStyle(fontSize: 14)),
                        Text(
                          '1 มกรา 2022 - 31 มกรา 2022',
                          style: TextStyle(
                              fontSize: 14, color: MyTheme.primaryMajor),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey[400],
                    height: 36,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'สภาพคล่องสุทธิ',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "-120",
                                style: TextStyle(
                                    color: MyTheme.negativeMajor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "/-420 ",
                                style: TextStyle(
                                    color: MyTheme.negativeMinor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              TextSpan(
                                text: "บ.",
                                style: TextStyle(
                                    color: MyTheme.negativeMajor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'รายรับรวม',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "15,000",
                                style: TextStyle(
                                    color: MyTheme.positiveMajor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "/15,000 ",
                                style: TextStyle(
                                    color: MyTheme.positiveMinor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              TextSpan(
                                text: "บ.",
                                style: TextStyle(
                                    color: MyTheme.positiveMajor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'รายรับจากการทำงาน',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text(
                          'ดูเพิ่มเติม ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: MyTheme.primaryMajor),
                        ),
                      ],
                    ),
                  ),
                  LinearPercentIndicator(
                    width: 345.0,
                    lineHeight: 16.0,
                    percent: 0.5,
                    animation: true,
                    animationDuration: 2500,
                    backgroundColor: Colors.grey[300],
                    progressColor: MyTheme.positiveMajor,
                    center: Padding(
                      padding: const EdgeInsets.only(right: 220),
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                              text: "15,000",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: "/15,000 ",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                            const TextSpan(
                              text: "บ.",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    barRadius: const Radius.circular(20),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 14, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'รายจ่าย',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "15,300",
                                style: TextStyle(
                                    color: MyTheme.negativeMajor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "/15,420 ",
                                style: TextStyle(
                                    color: MyTheme.negativeMinor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              TextSpan(
                                text: "บ.",
                                style: TextStyle(
                                    color: MyTheme.negativeMajor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'รายจ่ายไม่คงที่',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text(
                          'ดูเพิ่มเติม ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: MyTheme.primaryMajor),
                        ),
                      ],
                    ),
                  ),
                  LinearPercentIndicator(
                    width: 345.0,
                    lineHeight: 16.0,
                    percent: 0.5,
                    animation: true,
                    animationDuration: 2500,
                    backgroundColor: Colors.grey[300],
                    progressColor: const Color.fromARGB(255, 255, 115, 0),
                    center: Padding(
                      padding: const EdgeInsets.only(right: 220),
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                              text: "15,000",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: "/15,000 ",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                            const TextSpan(
                              text: "บ.",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    barRadius: const Radius.circular(20),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'รายจ่ายคงที่',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text(
                          'ดูเพิ่มเติม ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: MyTheme.primaryMajor),
                        ),
                      ],
                    ),
                  ),
                  LinearPercentIndicator(
                    width: 345.0,
                    lineHeight: 16.0,
                    percent: 0.5,
                    animation: true,
                    animationDuration: 2500,
                    backgroundColor: Colors.grey[300],
                    progressColor: Colors.orangeAccent,
                    center: Padding(
                      padding: const EdgeInsets.only(right: 220),
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                              text: "4,000",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: "/4,000 ",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                            const TextSpan(
                              text: "บ.",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    barRadius: const Radius.circular(20),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10, left: 10),
                    child: Text(
                      'ประเมินการปฎิบัติตามแผน',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'การทำบัญชีรายรับ-รายจ่าย',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "31",
                                style: TextStyle(
                                    color: MyTheme.primaryMajor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "/31 ",
                                style: TextStyle(
                                    color: MyTheme.primaryMinor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              TextSpan(
                                text: "วัน",
                                style: TextStyle(
                                    color: MyTheme.primaryMajor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}

class DebtAssetPage extends ConsumerWidget {
  const DebtAssetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'อัตราการเปลี่ยนเเปลงเฉลี่ย',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'หนี้สิน',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '-4,000 บ.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: MyTheme.negativeMajor),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'สินทรัพย์',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '0 บ.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.lightBlue),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ความมั่งคั่งสุทธิ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '-4,000 บ.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: MyTheme.primaryMajor),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'มูลค่าสูงสุด',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'หนี้สิน',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '210,000 บ.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: MyTheme.negativeMajor),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'สินทรัพย์',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '22,000 บ.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.lightBlue),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ความมั่งคั่งสุทธิ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '22,000 บ.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: MyTheme.primaryMajor),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'มูลค่าต่ำสุด',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'หนี้สิน',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '-4,000 บ.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: MyTheme.negativeMajor),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'สินทรัพย์',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '-4,000 บ.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.lightBlue),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ความมั่งคั่งสุทธิ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '-4,000 บ.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: MyTheme.primaryMajor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatPage extends ConsumerWidget {
  const StatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              'เกณฑ์การตัดสิน',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.rectangle_rounded,
                        size: 22,
                        color: Colors.greenAccent,
                      ),
                    ),
                    TextSpan(
                      text: "อยู่ในเกณฑ์ที่ ดี",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
              RichText(
                text: const TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.rectangle_rounded,
                        size: 22,
                        color: Colors.blueAccent,
                      ),
                    ),
                    TextSpan(
                      text: "อยู่ในเกณฑ์ที่ ปานกลาง",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.rectangle_rounded,
                        size: 22,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    TextSpan(
                      text: "อยู่ในเกณฑ์ที่ พอใช้",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 45),
                child: RichText(
                  text: const TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.rectangle_rounded,
                          size: 22,
                          color: Colors.redAccent,
                        ),
                      ),
                      TextSpan(
                        text: "อยู่ในเกณฑ์ที่ เเย่",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              'ความมั่งคั่งในปัจจุบัน',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 160,
                  width: 170,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Icon(HelperIcons.getIconData('comment-dollar'),
                              size: 60, color: Colors.white),
                        ),
                        Text(
                          'ความมั่งคั่งสุทธิ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text('X,XXX บ.',
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    height: 160,
                    width: 170,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Icon(HelperIcons.getIconData('dollar-sign'),
                                size: 60, color: Colors.white),
                          ),
                          const Text(
                            'กระเเสเงินสดสุทธิ',
                            style: TextStyle(color: Colors.white),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text('X,XXX บ.',
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white)),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    height: 160,
                    width: 170,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Icon(Icons.balance_rounded,
                                size: 60, color: Colors.white),
                          ),
                          Text(
                            'อัตราส่วนความมั่งคั่ง',
                            style: TextStyle(color: Colors.white),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text('X.X',
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white)),
                          )
                        ],
                      ),
                    )),
                Container(
                    height: 160,
                    width: 170,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Icon(Icons.mood_bad_rounded,
                                size: 60, color: Colors.white),
                          ),
                          Text(
                            'อัตราส่วนความอยู่รอด',
                            style: TextStyle(color: Colors.white),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text('X.X',
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white)),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              'สภาพคล่องเเละ \nความสามารถในการชำระหนี้',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    height: 160,
                    width: 170,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Icon(HelperIcons.getIconData('coins'),
                                size: 60, color: Colors.white),
                          ),
                          Text(
                            'อัตราส่วน\nสภาพคล่องพื้นฐาน',
                            style: TextStyle(color: Colors.white),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('X,XXX บ.',
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white)),
                          )
                        ],
                      ),
                    )),
                Container(
                    height: 160,
                    width: 170,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Icon(
                                HelperIcons.getIconData('hand-holding-usd'),
                                size: 60,
                                color: Colors.white),
                          ),
                          Text(
                            'อัตราส่วนการชำระ\nหนี้สินจากรายได้',
                            style: TextStyle(color: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text('X.X',
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white)),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              'โอกาสในการสร้างความมั่งคั่ง',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    height: 160,
                    width: 170,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Icon(HelperIcons.getIconData('piggy-bank'),
                                size: 60, color: Colors.white),
                          ),
                          const Text(
                            'อัตราส่วนการออม',
                            style: TextStyle(color: Colors.white),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text('X.X',
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white)),
                          )
                        ],
                      ),
                    )),
                Container(
                    height: 160,
                    width: 170,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Icon(HelperIcons.getIconData('chart-line'),
                                size: 60, color: Colors.white),
                          ),
                          const Text(
                            'อัตราส่วนการลงทุน',
                            style: TextStyle(color: Colors.white),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text('X.X',
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white)),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
