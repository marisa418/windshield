import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:windshield/main.dart';
import 'package:windshield/styles/theme.dart';
import 'package:windshield/utility/icon_convertor.dart';

class DailyFlowOverviewPage extends ConsumerWidget {
  const DailyFlowOverviewPage({Key? key}) : super(key: key);
  getCurrentDate() {
    var date = DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";

    return formattedDate; //DateFormat.MMMd().format(today)
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 250,
                  width: 450,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Theme.of(context).primaryColor,
                          MyTheme.kToDark.shade300,
                        ]),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 0.0),
                            child: Text(
                              'บัญชีรายรับ-รายจ่าย',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(25.0, 10.0, 0.0, 0.0),
                        child: Text.rich(
                          TextSpan(
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                            children: [
                              const WidgetSpan(
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: '${getCurrentDate()}',
                              )
                            ],
                          ),
                        ),
                      ),
                      //DatePickerTimeline(),
                      const ExpenseIncome(),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  OverviewIncomeToday(),
                  OverviewExpenseToday(),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 75,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      label: Text(
                        'ย้อนกลับ  ',
                        style: MyTheme.whiteTextTheme.headline3,
                      ),
                      icon: const Icon(
                        Icons.arrow_left,
                        color: Colors.white,
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: MyTheme.primaryMajor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),
                      onPressed: () => AutoRouter.of(context).pop(),
                    ),
                  ),
                ),
                /*SizedBox(
                  height: 75,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      label: Text(
                        '22.00  ',
                        style: MyTheme.whiteTextTheme.headline3,
                      ),
                      icon: const Icon(
                        Icons.timer_rounded,
                        color: Colors.white,
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: MyTheme.primaryMajor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),*/
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*class DatePicker extends ConsumerWidget {
  var monthTextStyle;

  var currentDate;

  var width;

  var height;

  var dayTextStyle;

  var dateTextStyle;

  var selectionColor;

  var daysCount;

  var onDateChange;

  var locale;

  Date datetime;

  var startDate;

  var controller;

  var selectedTextColor;

  var deactivatedColor;

  var initialSelectedDate;

  var activeDates;

  var inactiveDates;

  DatePicker(
    this.startDate, {
    required Key key,
    this.width,
    this.height,
    this.controller,
    this.monthTextStyle,
    this.dayTextStyle,
    this.dateTextStyle,
    this.selectedTextColor,
    this.selectionColor,
    this.deactivatedColor,
    this.initialSelectedDate,
    this.activeDates,
    this.inactiveDates,
    this.daysCount,
    this.onDateChange,
    this.locale = "en_US",
  }) : super(key: key);

  set _selectedValue(_selectedValue) {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DatePicker(
          DateTime.now(),
          initialSelectedDate: DateTime.now(),
          selectionColor: Colors.black,
          selectedTextColor: Colors.white,
          onDateChange: (date) {
            // New date selected
            setState(() {
              _selectedValue = date;
            });
          },
        ),
      ],
    );
  }
}*/

class ExpenseIncome extends ConsumerWidget {
  const ExpenseIncome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = ref.watch(provDFlow.select((e) => e.pageIdx));
    final incTotal = ref.watch(provDFlow.select((e) => e.incTotal));
    final expTotal = ref.watch(provDFlow.select((e) => e.expTotal));
    return Padding(
      padding: const EdgeInsets.only(top: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Badge(
            position: BadgePosition(top: 0, end: 0, isCenter: false),
            animationType: BadgeAnimationType.scale,
            showBadge: true,
            badgeContent: const Text(
              '3',
              style: TextStyle(fontSize: 15),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 75, //height of button
                  width: 75, //width of button
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      shadowColor: Colors.transparent, //remove shadow on button
                      primary: Colors.white,

                      textStyle: const TextStyle(fontSize: 12),
                      padding: const EdgeInsets.all(6),

                      shape: const CircleBorder(),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          HelperIcons.getIconData('hand-holding-usd'),
                          color: MyTheme.positiveMajor,
                        ),
                        Text(
                          '+${incTotal}',
                          style: TextStyle(
                            fontSize: 12,
                            color: MyTheme.positiveMajor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const Text(
                  'Love U',
                  style: TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.none,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'So much ',
                  style: TextStyle(
                    fontSize: 10,
                    decoration: TextDecoration.none,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          /*CircularPercentIndicator(
            radius: 60,
            progressColor: Colors.white,
            percent: 0.5,
            animation: true,
            animationDuration: 2000,
            lineWidth: 8,
          ),*/
          Badge(
            position: BadgePosition(top: 0, end: 0, isCenter: false),
            animationType: BadgeAnimationType.scale,
            showBadge: true,
            badgeContent: const Text(
              '3',
              style: TextStyle(fontSize: 15),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 75, //height of button
                  width: 75, //width of button
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      shadowColor: Colors.transparent, //remove shadow on button
                      primary: Colors.white,

                      textStyle: const TextStyle(fontSize: 12),
                      padding: const EdgeInsets.all(6),

                      shape: const CircleBorder(),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt,
                          color: MyTheme.negativeMajor,
                        ),
                        Text(
                          '-${expTotal}',
                          style: TextStyle(
                            fontSize: 12,
                            color: MyTheme.negativeMajor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const Text(
                  'Love U',
                  style: TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.none,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'So much ',
                  style: TextStyle(
                    fontSize: 10,
                    decoration: TextDecoration.none,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OverviewIncomeToday extends ConsumerWidget {
  const OverviewIncomeToday({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 30.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('รายรับวันนี้', style: MyTheme.textTheme.headline3),
          GridView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 100,
            ),
            itemBuilder: (_, index) {
              return Column(
                children: [
                  Expanded(
                    child: Badge(
                      position: const BadgePosition(
                        top: -9,
                        end: 2,
                        isCenter: false,
                      ),
                      animationType: BadgeAnimationType.scale,
                      showBadge: true,
                      badgeContent: Text(
                        '3',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 75, //height of button
                            width: 75, //width of button
                            child: ElevatedButton(
                              onPressed: () {
                                /*ref
                                    .read(provDFlow)
                                    .setColorBackground('income');
                                ref
                                    .read(provDFlow)
                                    .setCurrCat(incWorkingList[index]);
                                AutoRouter.of(context)
                                    .push(const DailyFlowCreateRoute());
                                ref.watch(provDFlow).currCat.flows;*/
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                shadowColor: Colors
                                    .transparent, //remove shadow on button
                                primary: //incWorkingList[index].budgets.isEmpty ?
                                    const Color(0xffE0E0E0),
                                //: MyTheme.incomeWorking[0],
                                textStyle: const TextStyle(fontSize: 12),
                                padding: const EdgeInsets.all(10),

                                shape: const CircleBorder(),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.access_alarms,
                                    color: Colors.white,
                                  ),
                                  Text('น้ำเต้าปูปลา',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ))
                                  /*if (incWorkingList[index]
                                      .flows
                                      .isNotEmpty) ...[
                                    Text(
                                      _loopFlow(incWorkingList[index].flows),
                                    ),
                                  ],*/
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: AutoSizeText(
                      'Hew A',
                      style: MyTheme.textTheme.bodyText2,
                      minFontSize: 8,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class OverviewExpenseToday extends ConsumerWidget {
  const OverviewExpenseToday({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 30.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('รายจ่ายวันนี้', style: MyTheme.textTheme.headline3),
          GridView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 100,
            ),
            itemBuilder: (_, index) {
              return Column(
                children: [
                  Expanded(
                    child: Badge(
                      position: const BadgePosition(
                        top: -9,
                        end: 2,
                        isCenter: false,
                      ),
                      animationType: BadgeAnimationType.scale,
                      showBadge: true,
                      badgeContent: Text(
                        '3',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 75, //height of button
                            width: 75, //width of button
                            child: ElevatedButton(
                              onPressed: () {
                                /*ref
                                    .read(provDFlow)
                                    .setColorBackground('income');
                                ref
                                    .read(provDFlow)
                                    .setCurrCat(incWorkingList[index]);
                                AutoRouter.of(context)
                                    .push(const DailyFlowCreateRoute());
                                ref.watch(provDFlow).currCat.flows;*/
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                shadowColor: Colors
                                    .transparent, //remove shadow on button
                                primary: //incWorkingList[index].budgets.isEmpty ?
                                    const Color(0xffE0E0E0),
                                //: MyTheme.incomeWorking[0],
                                textStyle: const TextStyle(fontSize: 12),
                                padding: const EdgeInsets.all(10),

                                shape: const CircleBorder(),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.access_alarms,
                                    color: Colors.white,
                                  ),
                                  Text('น้ำเต้าปูปลา',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ))
                                  /*if (incWorkingList[index]
                                      .flows
                                      .isNotEmpty) ...[
                                    Text(
                                      _loopFlow(incWorkingList[index].flows),
                                    ),
                                  ],*/
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: AutoSizeText(
                      'Hew A',
                      style: MyTheme.textTheme.bodyText2,
                      minFontSize: 8,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
